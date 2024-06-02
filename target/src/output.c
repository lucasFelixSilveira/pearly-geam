#include  <stdio.h> 
#include  <stdlib.h> 
#include "lib/stringify.h"
#include "lib/process.h"


char *put_stringify;

char *put_process;

typedef char bool;
typedef unsigned char u8;
typedef char i8;
typedef unsigned short u16;
typedef short i16;
typedef unsigned int u32;
typedef int i32;
typedef unsigned long u64;
typedef long i64;
typedef unsigned long long u128;
typedef long long i128;
typedef char* string;



struct DEF_PRINT {
  i8 *str;
};

int
main()
{
  int back_print = 0;
goto after_def_print;
struct DEF_PRINT call_print;
print: {

  i8 *str = call_print.str;

  {   
    printf("printed: %s\n", str);
    }
  free(str);
    if(back_print == 0) goto back_point_0;
// back-stack from 'print'.
}
after_def_print: {}
  i32 y = 3;  i8 *x;
  x = stringify_i32(y);
  call_print.str = x;
  back_print = 0;
goto print;
back_point_0: {}
  process_exit(0);

}