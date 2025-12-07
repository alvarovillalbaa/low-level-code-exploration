#include <stdio.h>
#include <stdint.h>
#include <string.h>

static const char MARK[] = "PCEPROOF";
static const size_t MARKLEN = 8;

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "usage: %s binary\n", argv[0]);
    return 1;
  }
  FILE *f = fopen(argv[1], "rb");
  if (!f) return 1;
  if (fseek(f, 0, SEEK_END) != 0) return 1;
  long sz = ftell(f);
  if (sz < (long)(sizeof(MARK) + 4)) return 1;
  long tail = (long)MARKLEN + 4;
  if (fseek(f, sz - tail, SEEK_SET) != 0) return 1;
  char mark[9] = {0};
  if (fread(mark, 1, MARKLEN, f) != MARKLEN) return 1;
  if (memcmp(mark, MARK, MARKLEN) != 0) {
    fprintf(stderr, "marker missing\n");
    return 1;
  }
  uint32_t plen = 0;
  if (fread(&plen, sizeof(plen), 1, f) != 1) return 1;
  if (plen > (uint32_t)sz) {
    fprintf(stderr, "invalid proof length\n");
    return 1;
  }
  long proof_off = sz - tail - (long)plen;
  if (proof_off < 0) return 1;
  if (fseek(f, proof_off, SEEK_SET) != 0) return 1;
  for (uint32_t i = 0; i < plen; ++i) {
    int c = fgetc(f);
    if (c == EOF) break;
    putchar(c);
  }
  fclose(f);
  return 0;
}

