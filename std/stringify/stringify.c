#include <stdio.h>
#include <stdlib.h>
#include "stringify.h"



STRINGIFIED stringify_u8(unsigned char u8) {
  char *string;
  sprintf(string, "%d", u8);
  return string;
}

STRINGIFIED stringify_u16(unsigned short u16) {
  char *string;
  sprintf(string, "%d", u16);
  return string;
}

STRINGIFIED stringify_u32(unsigned int u32) {
  char *string;
  sprintf(string, "%d", u32);
  return string;
}

STRINGIFIED stringify_u64(unsigned long u64) {
  char *string;
  sprintf(string, "%d", u64);
  return string;
}

STRINGIFIED stringify_u128(unsigned long long u128) {
  char *string;
  sprintf(string, "%d", u128);
  return string;
}

STRINGIFIED stringify_i8(char i8) {
  char *string;
  sprintf(string, "%d", i8);
  return string;
}

STRINGIFIED stringify_i16(short i16) {
  char *string;
  sprintf(string, "%d", i16);
  return string;
}

STRINGIFIED stringify_i32(int i32) {
  char *string;
  sprintf(string, "%d", i32);
  return string;
}

STRINGIFIED stringify_i64(long i64) {
  char *string;
  sprintf(string, "%d", i64);
  return string;
}

STRINGIFIED stringify_i128(long long i128) {
  char *string;
  sprintf(string, "%d", i128);
  return string;
}