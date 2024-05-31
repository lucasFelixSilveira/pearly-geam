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


struct DEF_SHOWMESSAGE {
  u8 *text;
};

int
main()
{
  int back_showMessage = 0;
goto after_def_showMessage;
struct DEF_SHOWMESSAGE call_showMessage;
showMessage: {

  u8 *text = call_showMessage.text;

  {   
    printf("Hello, world! He is your text: \"%s\"\n", text);
    }
    if(back_showMessage == 0) goto back_point_0;
// back-stack from 'showMessage'.
}
after_def_showMessage:
  {  
  printf("before the function is called.\n");
  }
  u8 *msg =    "My name is Lucas!"; 
  call_showMessage.text = msg;
  back_showMessage = 0;
goto showMessage;
back_point_0: {}
  {  
  free(msg);
  }
  {  
  printf("back-stack working properly.\n");
  }
   
  return 0;
 

}