#include <stdio.h>
#include <stdlib.h>
#include "stringify.h"

STRINGIFIED stringify_i32(int i32) {
  char *string;
  sprintf(string, "%d", i32);
  return string;
}