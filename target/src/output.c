#include   <stdio.h>  
#include   <stdlib.h>  
#include "lib/uncertain.h"
#include "lib/stringify.h"
#include "lib/generic.h"
#include "lib/cast.h"


char *put_uncertain;

char *put_stringify;

char *put_generic;

char *put_cast;

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
if(back_print == 1) goto back_point_1;
// back-stack from 'print'.
}
after_def_print: {}
  i8 *msg =    "My name is Lucas!"; 
  call_print.str = msg;
  back_print = 0;
goto print;
back_point_0: {}
  put_uncertain = "[@result]";
  LIB_UNCERTAIN test = init_uncertain(put_uncertain);
  void *text;
  i32 defined = 4;  text = generic_i32(defined);
  uncertain_def_ok(&test, text);
  uncertain_assert_operator(test, "Ok");
  if( test._ == 1 ) {
  void *x = test.value;
  uncertain_debug(&test);
  i32 y;
  i8 *z;
  y = cast_gtoi32(x);
  z = stringify_i32(y);
  call_print.str = z;
  back_print = 1;
goto print;
back_point_1: {}
    }
  free(put_uncertain);
  free(msg);
  free(text);
   
  return 0;
 

}