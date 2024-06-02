<div align="center">
  <img src="https://imgur.com/1Cu6txI.png" alt="Perly-gem-icon">
</div>

It is not a project to be taken forward, but the project consists of:
a programming language created in Perl, which transpiles to C and is compiled. The purpose of being called "pearly gem" is in reference to Ruby and Perl. Since it will be created in Perl and will have a syntax similar to Ruby.

Keep in mind that this is a project that I will tinker with in my spare time, not something that I will commit frequently.

Thanks for seeing this. Here's a small example of Hello world in the language (so far, there will be future changes like Bootstraping).

```pgem
macro include {-><stdio.h><-}
spawn our {->
  printf("Hello, world!");
  return 0;
<-}
```
Or, you can choose to create a print function, so that you can use it as your main print function.

```pgem
macro include {-><stdio.h><-}
macro include {-><stdlib.h><-}

def print(str: [&u8])
  spawn {-> 
    printf("printed: %s\n", str);
  <-}
  [@memory].dump [*->str]
end

our msg: [&u8] = spawn our {->"My name is Lucas!";<-}
pendence print
arg [!str] msg
call

[@memory].dump [*->msg]
spawn our {->
  return 0;
<-}
``` 

# Printing numbers

- Using `stringify` standard library
```pgem
macro include {-><stdio.h><-}
macro include {-><stdlib.h><-}
use [@stringify]

def print(str: [&u8])
  spawn {-> 
    printf("printed: %s\n", str);
  <-}
  [@memory].dump [*->str]
end

our y: i32 = 3;
our x: [&i8];
[@stringify].i32 [*->y] => [*->x]

pendence print
  arg [!str] x
call

spawn our {->
  return 0;
<-}
```
- Using C

```pgem
macro include {-><stdio.h><-}
macro include {-><stdlib.h><-}

def print(str: number)
  spawn {-> 
    printf("printed: %d\n", number);
  <-}
end

our y: i32 = 3;
pendence print
  arg [!str] y
call

spawn our {->
  return 0;
<-}
```
# Dictionary

- **[@arg]** `Reference to something external`
- **[!lit]** `Literally literal`
- **[*->var]** `Pointing to a variable`

### Types
- **u8** `Primitives`
- **[16; u8]** `Array`
- **[_; u8]** `Array of indefinite size`
- **[&u8]** `Pointer of respective type`

# Standard libraries
- **@uncertain** -> For returns with more than one possible value (of different types)
- **@stringify** -> Transforms other types of values ​​into strings 
- **@generic** -> Transforms types into a single type, accepted by any function as long as the parameter is of type **[&void]**.
- **@memory** -> By default it is already imported. Some functions necessary for HEAP cleaning.
- **@cast** -> Cast from one type to another