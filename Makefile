CC=clang
CFLAGS=-Wall -g
LDLIBS=-lfftw3 -lm

EXE=asa-s16le
EXEOBJ=$(EXE:=.o)
SRC=$(wildcard *.c)
OBJ=$(filter-out $(EXEOBJ),$(SRC:.c=.o))
DEP=$(SRC:.c=.d)

-include $(DEP)

all: $(EXE)

.PHONY: clean
clean:
	$(RM) *.o *.d $(EXE)

%: %.o $(OBJ)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

%.d: %.c
	$(CPP) $(CFLAGS) $< -MM -MT $(@:.d=.o) >$@

%.o: %.d
