#include   <stdio.h>  
#include   <stdlib.h>  

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
  u8 *fmt;
};

int
main()
{
  int back_print = 0;
goto after_def_print;
struct DEF_PRINT call_print;
print: {

  u8 *fmt = call_print.fmt;

  {   
    printf("printed: %s\n", fmt);
    }
    if(back_print == 0) goto back_point_0;
// back-stack from 'print'.
}
after_def_print: {}
  u8 *msg =    "My name is Lucas!"; 
  call_print.fmt = msg;
  back_print = 0;
goto print;
back_point_0: {}
   
  free(msg);
  return 0;
 

}