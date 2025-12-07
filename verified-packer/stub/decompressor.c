#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "usage: %s packed.bin\n", argv[0]);
    return 1;
  }
  FILE *f = fopen(argv[1], "rb");
  if (!f) return 1;
  uint32_t len = 0;
  if (fread(&len, sizeof(len), 1, f) != 1) return 1;
  uint8_t *buf = malloc(len);
  if (!buf) return 1;
  if (fread(buf, 1, len, f) != len) return 1;
  fwrite(buf, 1, len, stdout);
  free(buf);
  fclose(f);
  return 0;
}

