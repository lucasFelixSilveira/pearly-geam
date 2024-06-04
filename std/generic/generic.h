#ifndef GENERIC_H
# define GENERIC_H

typedef void* GENERIC;

GENERIC            generic_string(unsigned char* str);

GENERIC            generic_i8(char value);
GENERIC            generic_i16(short value);
GENERIC            generic_i32(int value);
GENERIC            generic_i64(long value);
GENERIC            generic_i128(long long value);

GENERIC            generic_u8(unsigned char value);
GENERIC            generic_u16(unsigned short value);
GENERIC            generic_u32(unsigned int value);
GENERIC            generic_u64(unsigned long value);
GENERIC            generic_u128(unsigned long long value);

char               generic_toi8(GENERIC generic);
short              generic_toi16(GENERIC generic);
int                generic_toi32(GENERIC generic);
long               generic_toi64(GENERIC generic);
long long          generic_toi128(GENERIC generic);

unsigned char      generic_tou8(GENERIC generic);
unsigned short     generic_tou16(GENERIC generic);
unsigned int       generic_tou32(GENERIC generic);
long               generic_tou64(GENERIC generic);
unsigned long long generic_tou128(GENERIC generic);
#endif