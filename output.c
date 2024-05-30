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
  int back_showMessage = 0;
goto after_def_showMessage;
showMessage: {


  {   
    printf("Hello, world!\n");
    }
    if(back_showMessage == 0) goto back_point_0;
// back-stack from 'showMessage'.
}
after_def_showMessage:
  {  
  printf("before the function is called.\n");
  }
  back_showMessage = 0;
goto showMessage;
back_point_0: {}
  {  
  printf("back-stack working properly.\n");
  }
   
  return 0;
 

}