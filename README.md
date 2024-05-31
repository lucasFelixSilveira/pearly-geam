It is not a project to be taken forward, but the project consists of:
a programming language created in Perl, which transpiles to C and is compiled. The purpose of being called "pearly gem" is in reference to Ruby and Perl. Since it will be created in Perl and will have a syntax similar to Ruby.

Keep in mind that this is a project that I will tinker with in my spare time, not something that I will commit frequently.

Thanks for seeing this. Here's a small example of Hello world in the language (so far, there will be future changes like Bootstraping).

```pgem
macro define {-><stdio.h><-}
spawn our {->
  printf("Hello, world!");
  return 0;
<-}
```
Or, you can choose to create a print function, so that you can use it as your main print function.

```pgem
macro include {-> <stdio.h> <-}
macro include {-> <stdlib.h> <-}

def print(str: [&u8])
  spawn {-> 
    printf("printed: %s\n", str);
  <-}
end

our msg: [&u8] = spawn our {->"My name is Lucas!";<-}
pendence print
arg [!str] msg
call

spawn our {->
  free(msg);
  return 0;
<-}
```