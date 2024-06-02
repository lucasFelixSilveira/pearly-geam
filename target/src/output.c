#include   <stdio.h>  
#include   <stdlib.h>  
#include "lib/uncertain.h"


char *put_uncertain;

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
  u8 *str;
};

int
main()
{
  int back_print = 0;
goto after_def_print;
struct DEF_PRINT call_print;
print: {

  u8 *str = call_print.str;

  {   
    printf("printed: %s\n", str);
    }
  free(str);
    if(back_print == 0) goto back_point_0;
// back-stack from 'print'.
}
after_def_print: {}
  u8 *msg =    "My name is Lucas!"; 
  call_print.str = msg;
  back_print = 0;
goto print;
back_point_0: {}
  put_uncertain = "[@result]";
  LIB_UNCERTAIN test = init_uncertain(put_uncertain);
  free(put_uncertain);
  free(msg);
   
  return 0;
 

}