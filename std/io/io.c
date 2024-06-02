#include <stdio.h>

void io_print(char *fmt) {
  printf("%s", fmt);
}

void io_println(char *fmt) {
  printf("%s\n", fmt);
}

void io_info(char *fmt) {
  char *info;
  sprintf(info, "info: %s", fmt);
  io_print(info);
}

void io_infoln(char *fmt) {
  char *info;
  sprintf(info, "info: %s", fmt);
  io_print(info);
}