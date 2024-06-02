#include "uncertain.h"
#include <string.h>

LIB_UNCERTAIN init_uncertain(char *t) {
  char _ = strcmp("[@result]", t) == 0 ? 0 : 1;
  return (LIB_UNCERTAIN) {
    .t = _,
    ._ = 0,
    .value = (void*)("INVALID")
  };
}