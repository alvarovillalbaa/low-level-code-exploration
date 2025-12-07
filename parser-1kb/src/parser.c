#include <stdio.h>
#include <string.h>

static int count_skills(const char *line) {
  int c = 1;
  for (const char *p = line; *p; ++p) if (*p == ',') c++;
  return (strlen(line) == 0) ? 0 : c;
}

int main(void) {
  char name[128] = {0}, role[128] = {0}, skills[256] = {0};
  char buf[256];
  while (fgets(buf, sizeof(buf), stdin)) {
    if (strncmp(buf, "name:", 5) == 0) sscanf(buf + 5, " %127[^\n]", name);
    else if (strncmp(buf, "role:", 5) == 0) sscanf(buf + 5, " %127[^\n]", role);
    else if (strncmp(buf, "skills:", 7) == 0) sscanf(buf + 7, " %255[^\n]", skills);
  }
  int n = (skills[0] == 0) ? 0 : count_skills(skills);
  printf("%s (%s) has %d skills.\n", name, role, n);
  return 0;
}

