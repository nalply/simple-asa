#ifndef ASA_H
#define ASA_H

#include <fftw3.h>


#define W_BOXCAR         0
#define W_HANN           1
#define W_FLATTOP        2
#define W_BLACKMANHARRIS 3
#define W_FIRST          W_BOXCAR
#define W_LAST           W_BLACKMANHARRIS

extern const char* window_names[];

extern const int x;

#define C_SIZE 1000

typedef struct asa_param_t { //                          limits
  int s;         // number of samples in a sequence      1 <= s <= x
  int n;         // fft input size                       s <= n <= x 
  int m;         // fft output size                      m = 1 + n / 2
  int b0;        // index of first bin                   0 <= b0 <= b1
  int b1;        // index of last bin                    b0 <= b1 <= m
  int b;         // number of bins in fft output         b = b1 - b0
  double p;      // distribution matching to power       1 <= p <= 2
  int l;         // number of lines in analyser output   1 <= l <= b
  int *g;        // distribution of bins to lines g[l]
  int r;         // number of sequences per spectrum     1 <= r <= x
  int d;         // distance between sequence starts     1 <= d <= x
  int w;         // window function
} asa_param_t;


typedef struct asa_struct_t {
  asa_param_t param;
  int fd_in;              // file descriptor of input (PCM s16le)
  int fd_out;             // file descriptor of output (u8 spectrum data)
  int num_in;             // how many sequences of s s16le samples read 
  int num_out;            // how many spectrums of b u8 magnitudes written
  int16_t *s16le;         // buffer for a sequence of s s16le samples
  double *d;              // input for fft, then bins, then lines
  double max_mag;         // maximum magnitude after asa_spectrum()
  fftw_complex *c;        // output of fft
  fftw_plan plan;         // fftw3 plan
} *asa_t;

extern int* asa_distribute_bins(int l, int b, double p);

extern void asa_init_fft(asa_t asa);

extern int asa_read(asa_t asa);

extern void asa_pad_and_window(asa_t asa);

extern void asa_run_fft(asa_t asa);

// Get bins from the complex fft result then combine bins to lines
extern void asa_lines(asa_t asa);

extern void asa_write(asa_t asa);

extern void asa_cleanup(asa_t asa);

static inline int sum(int *g, int l) {
  int result = 0;
  for (int i = 0; i < l; i++) result += g[i];
  return result;
}

#define min(a, b) ({ \
  __typeof__ (a) _a = (a); \
  __typeof__ (b) _b = (b); \
  _a < _b ? _a : _b; \
})




#endif
