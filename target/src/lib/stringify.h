#ifndef STRINGIFY_H
# define STRINGIFY_H
  typedef char* STRINGIFIED;

  STRINGIFIED stringify_u8(unsigned char u8);
  STRINGIFIED stringify_u16(unsigned short u16);
  STRINGIFIED stringify_u32(unsigned int u32);
  STRINGIFIED stringify_u64(unsigned long u32);
  STRINGIFIED stringify_u128(unsigned long long u128);
  
  STRINGIFIED stringify_i8(char i8);
  STRINGIFIED stringify_i16(short i16);
  STRINGIFIED stringify_i32(int i32);
  STRINGIFIED stringify_i64(long i64);
  STRINGIFIED stringify_i128(long long i64);
#endif