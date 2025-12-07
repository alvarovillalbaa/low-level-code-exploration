#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  const char *path = (argc > 1) ? argv[1] : "polyglot.png";
  FILE *f = fopen(path, "rb");
  if (!f) return 1;
  int c;
  while ((c = fgetc(f)) != EOF) putchar(c);
  fclose(f);
  return 0;
}

