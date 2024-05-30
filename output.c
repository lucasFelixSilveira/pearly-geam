#include   <stdio.h>  

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

int
main()
{
  u8 codeExit =    0; 
  int back_test = 0;
goto after_def_test;
test: {


  {   
    printf("Hello world");
    }
    if(back_test == 0) goto back_point_0;
// back-stack from 'test'.
}
after_def_test:
  back_test = 0;
goto test;
back_point_0: {}
   
  return 0;
 

}