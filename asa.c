#include <unistd.h>
#include <math.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "asa.h"
#include "y_dbg.h"


const char* window_names[] = { 
  "boxcar", "hann", "flattop", "blackmanharris"
};

const int x = 1 << 20;

int* asa_distribute_bins(int l, int b, double p) {
  y_assert(p >= 1.0 && p <= 2.0);
  y_assert_e(p == 1.0 || l != b, "for b == l avoid p > 1");

  int *lines = malloc(l * sizeof(int));
  if (!lines) y_oom();

  // p == 1 means distribute linearly because p ^ x == 1 ^ x == 1, but we need
  // a special case: the formula for the exponents's sum diverges for p == 1 
  if (p == 1) {
    for (int j = 0; j < l; j++) lines[j] = b / l;
    int missing = b - sum(lines, l);
    double step = l / (1.0 + missing);
    for (double j = step; j < l; j += step) lines[(int)j]++;

    return lines;
  }

  double g[l];  
  int wb = y_dbg_o(Y_OUT_START, "lines: approximation:");
  for (int j = 0; j < l; j++) {
    double r = b * (1-p) * pow(p, j) / (1 - pow(p, l));
    g[j] = r;
    lines[j] = ceil(r);
    y_assert_e(lines[j] > 0, "lines[j] %d", lines[j]);
    
    wb += y_dbg_o(Y_OUT_CONT, " %d", lines[j]);
    if (wb > 70) { wb = 0; y_dbg_o(Y_OUT_CONT, "\n "); };
  }
  int lines_sum = sum(lines, l);
  if (wb > 30) y_dbg_o(Y_OUT_CONT, "\n ");
  y_dbg_o(Y_OUT_END, " sum %d overshoot %d", lines_sum, lines_sum - b);

  // trace g
  y_trc_o(Y_OUT_START, "g:\n ");
  for (int j = 0; j < l; j++) {
    wb += y_trc_o(Y_OUT_CONT, " %g", g[j]);
    if (wb > 70) { wb = 0; y_trc_o(Y_OUT_CONT, "\n "); };
  }
  y_trc_o(Y_OUT_END, "");

  // Take away overdistributed bins where it hurts the least by weighting lines
  // Criteria: line > 1 and relative distance to real g
  int iteration = 0;
  double weights[l];
  y_assert(lines_sum >= b);
  while (sum(lines, l) > b) { // no more than l iterations
    iteration++;
    y_trc_o(Y_OUT_START, "weights iteration %d:\n ", iteration);
    wb = 0;
    int zero = 1;
    for (int j = 0; j < l; j++) {
      if (lines[j] == 1) { weights[j] = 0; continue; }
      if (zero) wb += y_trc_o(Y_OUT_CONT, " 0 (%d tines)", j - 1);
      zero = 0;
      double distance = fabs(lines[j] - g[j]);
      double relative = log(g[j]);
      weights[j] = distance * relative;
      wb += y_trc_o(Y_OUT_CONT, " %.2g", weights[j]);
      if (wb > 70) { wb = 0; y_trc_o(Y_OUT_CONT, "\n "); };
    }

    double max = -INFINITY;
    int index = 0;
    for (int j = 0; j < l; j++)
      if (weights[j] > max) 
        max = weights[j], index = j;

    if (wb > 30) y_trc_o(Y_OUT_CONT, "\n ");
    y_trc_o(Y_OUT_END, " take away bin at index %d: %d", index, lines[index]);
    lines[index] -= 1; // Take one bin away
  }

  // debug lines
  wb = y_dbg_o(Y_OUT_START, "lines:");
  for (int j = 0; j < l; j++) {
    wb += y_dbg_o(Y_OUT_CONT, " %d", lines[j]);
    if (wb > 70) { wb = 0; y_dbg_o(Y_OUT_CONT, "\n "); };
  }
  y_dbg_o(Y_OUT_END, "");

  y_assert(sum(lines, l) == b);
  return lines;
}


void asa_init_fft(asa_t asa) {
  asa->d = fftw_alloc_real(asa->param.n);    // these sizes are needed by fftw3
  asa->c = fftw_alloc_complex(asa->param.m); // rtfm fftw.org (see r2c_1d)
  if (!asa->d || !asa->c) y_oom();
  asa->plan = fftw_plan_dft_r2c_1d(
    asa->param.n, asa->d, asa->c, FFTW_ESTIMATE);
  if (!asa->plan) y_error("fftw plan failed");
}


void asa_run_fft(asa_t asa) {
  fftw_execute(asa->plan);
}


#define S16 sizeof(int16_t)

int asa_read(asa_t asa) {
  int size = S16 * asa->param.s;
  char *p = (char*)asa->s16le;
  
  // Overlap? Copy rest of s16le buffer to front
  if (asa->num_in && asa->param.s > asa->param.d) {
    int overlap = S16 * (asa->param.s - asa->param.d);
    y_trc("overlap %d", overlap);
    memmove(asa->s16le, asa->s16le + asa->param.d, overlap);
    size -= overlap;
    p += overlap;
  }

  const int in = asa->fd_in;

  // Skip? Dummy read (seek doesn't work on pipes)
  if (asa->num_in && asa->param.s < asa->param.d) {
    int skip = S16 * (asa->param.d - asa->param.s);
    while (1) {
      char dummy[2000];
      int size = min(skip, sizeof(dummy));
      ssize_t len = read(in, dummy, size);
      y_trc("skip: read(%d, dummy, %d): %ld", in, size, len);

      if (len == size) break;
      if (len == 0) return 0; // End of file
      if (len == -1) y_error("skipping: %s", y_strerr);

      size -= len;
    }
  }

  while (1) {
    y_assert(p + size == (char*)(asa->s16le + asa->param.s));

    ssize_t len = read(in, p, size);
    y_trc("seq #%d: read(%d, p, %d): %ld", asa->num_in, in, size, len);

    // Done!
    if (len == size) {
      asa->num_in++;
      return 1;
    }

    // End of file!
    if (len == 0) {
      y_info("end of file after reading %i sequences(s)", asa->num_in);
      ssize_t unused = p - (char*)asa->s16le;
      if (unused) y_warn("%ld bytes discarded", unused);
      return 0;
    }

    // Error!
    if (len == -1) y_error("read pcm: %s", y_strerr);
    
    size -= len;
    p += len;
  }
}


void asa_pad_and_window(asa_t asa) {
  memset(asa->d, 0, sizeof(*asa->d) * asa->param.n);

  const double N = M_PI / (asa->param.n - 1);
  const int i0 = (asa->param.n - asa->param.s) / 2;
  const int i1 = i0 + asa->param.s;

  y_assert(asa->param.w >= W_FIRST && asa->param.w <= W_LAST);
  switch (asa->param.w) {

    #define WINDOW(f) \
      for (int i = i0; i < i1; i++) asa->d[i] = asa->s16le[i] * (f)
    #define COS2 cos(2 * i * N)
    #define COS4 cos(4 * i * N)
    #define COS6 cos(6 * i * N)
    #define COS8 cos(8 * i * N)

    case W_BOXCAR: {
      WINDOW(1);
    } break;

    case W_HANN: {
      // wikipedia.org/wiki/Hann_function
      const double a0=.5;
      WINDOW(a0 - a0 * COS2);
    } break;

    case W_FLATTOP: {
      // wikipedia.org/wiki/Window_function#Flat_top_window
      const double a0=.21557895, a1=.41663158, a2=.277263158,
        a3=.083578947, a4=.006947368;
      WINDOW(a0 - a1 * COS2 + a2 * COS4 - a3 * COS6 + a4 * COS8);
    } break;

    case W_BLACKMANHARRIS: {
      // wikipedia.org/wiki/Window_function#Blackman–Harris_window
      const double a0=0.35875, a1=0.48829, a2=0.14128, a3=0.01168;
      WINDOW(a0 - a1 * COS2 + a2 * COS4 - a3 * COS6);
    } break;
  }
}


void asa_lines(asa_t asa) {
  y_assert(asa->param.b0 <= asa->param.b1);

  double *const d = asa->d;
  fftw_complex *const c = asa->c;

  // calculate magnitudes from c[b0:b1] to d[1:b] (note 1 as first index for d)
  int b0 = asa->param.b0 - 1, b = asa->param.b + 1;
  for (int i = 1; i < b; i++) {
    d[i] = hypot(c[i + b0][0], c[i + b0][1]);
  }

  asa->max_mag = 0; // hypot() is non-negative, so 0 is the minimum possible

  // combine bins from d[1:b] to d[0:l-1] (note from 1 to 0 as first index)
  // and simultaneously find maximum magnitude of lines
  int l = asa->param.l, *g = asa->param.g, j = 0, i;
  for (i = 0; i < l; i++) {
    d[i] = 0;
    for (int k = 0; k < g[i]; k++) d[i] += d[j++];
    d[i] /= (double)g[i];

    if (asa->max_mag < d[i]) asa->max_mag = d[i];
  }

  // help debugging by setting -1 then clearing
  if (i < asa->param.n) d[i] = -1;
  i++;
  for (; i < asa->param.n; i++) d[i] = 0;
}


void asa_write(asa_t asa) {
  y_assert(asa->param.b0 <= asa->param.b1);

  const int l = asa->param.l;
  const int fd = asa->fd_out;
  uint8_t spectrum[l];

  for (int i = 0; i < l; i++) {
    spectrum[i] = (uint8_t)(255 * asa->d[i] / asa->max_mag);
  }

  ssize_t result = write(fd, spectrum, l);
  y_trc("spectrum #%d write(%d, p, %d): %ld", asa->num_out, fd, l, result);
  if (result == -1) y_error("write: %s", y_strerr);
  asa->num_out++;
}


void asa_cleanup(asa_t asa) {
  if (asa->d) fftw_free(asa->d);
  if (asa->c) fftw_free(asa->c);
  if (asa->plan) fftw_destroy_plan(asa->plan);
  fftw_cleanup();

  asa = (asa_t){ 0 };
}
