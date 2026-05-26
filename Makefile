# ── ac Makefile ───────────────────────────────────────────────────────────
CC      ?= cc
CFLAGS  ?= -O2 -Wall -Wno-unused-result -Wno-unused-function
LDFLAGS ?= -lm -lpthread

ifdef BLAS
  CFLAGS  += -DUSE_BLAS -DACCELERATE
  LDFLAGS += -framework Accelerate
endif

all: ac

notorch.o: notorch.c notorch.h
	$(CC) $(CFLAGS) -c notorch.c -o notorch.o

loragrad.o: loragrad.c loragrad.h notorch.h
	$(CC) $(CFLAGS) -c loragrad.c -o loragrad.o

ac.o: ac.c notorch.h loragrad.h
	$(CC) $(CFLAGS) -c ac.c -o ac.o

ac: ac.o notorch.o loragrad.o
	$(CC) ac.o notorch.o loragrad.o $(LDFLAGS) -o ac

run: ac
	./ac origin.txt

clean:
	rm -f ac ac.o notorch.o loragrad.o

.PHONY: all run clean
