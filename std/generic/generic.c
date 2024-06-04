#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "generic.h"

GENERIC generic_string(unsigned char* str) {
  char* copy = (char*)malloc(strlen(str) + 1);
  
  if( copy == NULL ) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
  
  strcpy(copy, str);
  return (void*)copy;
}

GENERIC generic_i8(char value) {
  char* ptr = (char*)malloc(sizeof(char));
    
  if (ptr == NULL) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
    
  *ptr = value;
  return (void*)ptr;
}

GENERIC generic_i16(short value) {
  short* ptr = (short*)malloc(sizeof(short));
    
  if (ptr == NULL) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
    
  *ptr = value;
  return (void*)ptr;
}


GENERIC generic_i32(int value) {
  int* ptr = (int*)malloc(sizeof(int));
    
  if (ptr == NULL) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
    
  *ptr = value;
  return (void*)ptr;
}

GENERIC generic_i64(long value) {
  long* ptr = (long*)malloc(sizeof(long));
    
  if (ptr == NULL) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
    
  *ptr = value;
  return (void*)ptr;
}

GENERIC generic_i128(long long value) {
  long long* ptr = (long long*)malloc(sizeof(long long));
    
  if (ptr == NULL) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
    
  *ptr = value;
  return (void*)ptr;
}

GENERIC generic_u8(unsigned char value) {
  unsigned char* ptr = (unsigned char*)malloc(sizeof(unsigned char));
    
  if (ptr == NULL) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
    
  *ptr = value;
  return (void*)ptr;
}

GENERIC generic_u16(unsigned short value) {
  unsigned short* ptr = (unsigned short*)malloc(sizeof(unsigned short));
    
  if (ptr == NULL) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
    
  *ptr = value;
  return (void*)ptr;
}


GENERIC generic_u32(unsigned int value) {
  unsigned int* ptr = (unsigned int*)malloc(sizeof(unsigned int));
    
  if (ptr == NULL) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
    
  *ptr = value;
  return (void*)ptr;
}

GENERIC generic_u64(unsigned long value) {
  unsigned long* ptr = (unsigned long*)malloc(sizeof(unsigned long));
    
  if (ptr == NULL) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
    
  *ptr = value;
  return (void*)ptr;
}

GENERIC generic_u128(unsigned long long value) {
  unsigned long long* ptr = (unsigned long long*)malloc(sizeof(unsigned long long));
    
  if (ptr == NULL) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
    
  *ptr = value;
  return (void*)ptr;
}

/*---------------- ~~~~~~~~~~~~~~~~~~ -------------------*/
/*-----------------> Revese Process <-------------------*/
/*---------------- ~~~~~~~~~~~~~~~~~~ -----------------*/

char generic_toi8(GENERIC generic) {
  char* ptr = (char*)generic;
  return *ptr;
}

short generic_toi16(GENERIC generic) {
  short* ptr = (short*)generic;
  return *ptr;
}

int generic_toi32(GENERIC generic) {
  int* ptr = (int*)generic;
  return *ptr;
}

long generic_toi64(GENERIC generic) {
  long* ptr = (long*)generic;
  return *ptr;
}

long long generic_toi128(GENERIC generic) {
  long long* ptr = (long long*)generic;
  return *ptr;
}

unsigned char generic_tou8(GENERIC generic) {
  unsigned char* ptr = (unsigned char*)generic;
  return *ptr;
}

unsigned short generic_tou16(GENERIC generic) {
  unsigned short* ptr = (unsigned short*)generic;
  return *ptr;
}

unsigned int generic_tou32(GENERIC generic) {
  unsigned int* ptr = (unsigned int*)generic;
  return *ptr;
}

long generic_tou64(GENERIC generic) {
  long* int_ptr = (long*)generic;
  return *int_ptr;
}

unsigned long long generic_tou128(GENERIC generic) {
  unsigned long long* ptr = (unsigned long long*)generic;
  return *ptr;
}