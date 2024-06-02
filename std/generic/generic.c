#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "generic.h"

GENERIC generic_string(char* str) {
  char* copy = malloc(strlen(str) + 1);
  
  if( copy == NULL ) {
    printf("\nGeneric error: [Allocation memory]\n- Fail to alloc memory.\n");
    exit(1);
  }
  
  strcpy(copy, str);

  return (void*)copy;
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
