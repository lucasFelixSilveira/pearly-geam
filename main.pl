use strict;

my $buff;
my $linha;
my @tokens;
my $scope = 0;
my $file_name;
my $tk_len = 0;
my $macros = "";
my $structs = "";
my $content = "";
my @closses_stack = ();
my $closses_len = 0;

my $stack_size = 0;
my @stack_calls = ();

my @modules = ();

my $result = "typedef char bool;
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


// structs arguments

int
main()
{\n"; 

my $puts = "";

my $type_len = 0;
my @types = (
  "u8", "i8", "bool",
  "u16", "i16",
  "u32", "i32",
  "u64", "i64",
  "u128", "i128",
  "result", "option",
  "void"
);

sub get_ident {
  my $ident = "  ";
  my $max = shift @_;
  while($max > 0) {
    $ident = " $ident ";    
    $max--;
  }
  return $ident;
}

sub add_struct {
  my $struct = shift @_;
  $structs = "$structs\n$struct";
}

sub add_macro {
  my $macro = shift @_;
  my $max = shift @_;
  my $ident = "";
  while($max > 0) {
    $ident = " $ident ";    
    $max--;
  }
  $macros = "$macros#$ident$macro\n";
}

sub add_end_stack {
  my $end = shift @_;
  @closses_stack[$closses_len++] = $end;
}

sub add_line {
  my $line = shift @_;
  my $jump_line = shift @_;
  my $ident = "  ";
  my $max = $scope;
  my $line_feed = "\x0a";
  if( $jump_line eq 0 ) {
    $line_feed = "";
  }
  while($max > 0) {
    $ident = " $ident ";    
    $max--;
  }
  $result = "$result$ident$line$line_feed";
}

my $token_type_mismatch = 0;
my $its_not_sign = 1;
my $its_not_collon = 2;
my $its_not_collon_sign = 3;
my $its_not_semi_sign = 4;
my $its_not_semi = 5;
my $its_not_type = 6;
my $its_not_codeblock = 7;
my $error_in_def = 8;
my $its_not_literal = 9;
my $its_not_reference = 10;
my $its_not_dot = 11;
my $its_not_pointer = 12;
sub spawn_error {
  my $error = shift @_;
  my @errors = (
    "TokenType mismatch",
    "It's not a sign",
    "It's not a collon",
    "It's not a collon or a sign",
    "It's not a semi or a sign",
    "It's not a semi",
    "It's not valid type",
    "It's not a code-block string",
    "Error in def",
    "It's not a Litearal",
    "It's not a Reference",
    "It's not a dot",
    "It's not a pointer"
  );

  print "Error! - [$error]\n x ", @errors[$error], "\n";
  exit 0;
}

sub validate {
  my @keywords = (
    "use",   "my",   "our",  "end",   "def",    "type",   "then", "end_process",
    "spawn", "goto", "type", "union", "struct", "static", "do",   "macro", "call"
  );

  my $keyword;
  foreach $keyword (@keywords) {
    if( $keyword eq $buff ) {
      return 1;
    }
  }

  if( $buff =~ /^[a-zA-Z_]{1}[a-zA-Z0-9_]*$/ ) {
    return 3;
  }

  if( $buff eq "=" ) {
    return 4;
  }

  if( $buff eq ":" ) {
    return 5;
  }

  if( $buff eq ";" ) {
    return 6;
  }

  my $start = substr($buff, 0, 3);
  my $end   = substr($buff, -3, 3);
  if( $start eq "{->" and $end eq "<-}" ) {
    return 7;
  }

  if( $buff eq "." ) {
    return 8;
  }

  return 0;
}

sub is_identifier {
  my $name = shift @_;

  $buff = $name;
  if( validate() ne 3 ) {
    spawn_error $token_type_mismatch;
  }
}

sub is_sign {
  my $sign = shift @_;

  $buff = $sign;
  if( validate() ne 4 ) {
    spawn_error $its_not_sign;
  }
}

sub is_dot {
  my $dot = shift @_;

  $buff = $dot;
  if( validate() ne 8 ) {
    spawn_error $its_not_dot;
  }
}

sub is_code_block {
  my $code_block = shift @_;

  $buff = $code_block;
  if( validate() ne 7 ) {
    spawn_error $its_not_codeblock;
  }
}

sub is_collon {
  my $sign = shift @_;

  $buff = $sign;
  if( validate() ne 5 ) {
    spawn_error $its_not_collon;
  }
}

sub is_semi {
  my $sign = shift @_;

  $buff = $sign;
  if( validate() ne 6 ) {
    spawn_error $its_not_semi;
  }
}

sub is_semi_sign {
  my $sign = shift @_;

  $buff = $sign;
  if( validate() ne 6 and validate() ne 4 ) {
    spawn_error $its_not_semi_sign;
  } else {
    return validate();
  }
}

sub is_collon {
  my $sign = shift @_;

  $buff = $sign;
  if( validate() ne 5 ) {
    spawn_error $its_not_collon;
  }
}

sub is_literal {
  my $literal = shift @_;

  if( not $literal =~ /[[][!](\w*|\W*\d*)[]]/ ) {
    spawn_error $its_not_literal;
  }
}

sub is_pointer {
  my $pointer = shift @_;

  if( not $pointer =~ /[[][*][-][>](\w*|\W*\d*)[]]/ ) {
    spawn_error $its_not_pointer;
  }
}

sub is_reference {
  my $reference = shift @_;

  if( not $reference =~ /[[][@](\w*|\W*\d*)[]]/ ) {
    spawn_error $its_not_reference;
  }
}

sub is_type {
  my $type = shift @_;
  my $name = shift @_;
  my $only_get = shift @_;
  if( $type =~ /[\[]((\d+|_)[;]|[&]*)\s*(\w+|\W+)[\]]/ ) { 
    if($1 ne "_") {
      if( $only_get ) {
        return 1;
      }

      my $size = $1;
      my $type = $3;
      if( $size =~ /\d+/ ) {
        return "$type $name\[$size]";
      } elsif( $size =~ /[&]+/ ){
        my $ptr = "";
        my $level = 0;
        my $qnt = length($size);
        while($level < $qnt) {
          $level++;
          $ptr = "$ptr*";
        }
        return "$type $ptr$name";
      }
    } else {
      if( $only_get ) {
        return 1;
      }
      return "$2 *$name";
    }
  } else {
    foreach my $type_ (@types) {
      if( $type_ eq $type ) {
        if( $only_get ) {
          return 1;
        }
        return "$type $name";
      }
    }
    if( $only_get ) {
      return 0;
    }
    spawn_error $its_not_type;
  }
}

sub closses {
  $closses_len--;
  my $last = @closses_stack[$closses_len];
  my $ident = get_ident $scope;

  my $result = "$ident$last";
  return $result;
}

sub lexer {
  my $content = shift @_;
  my @tape =  split //, $content;

  my $entry = 0;
  my $tk = 0;
  my $t = 1;
  my $type = "";
  my $i = 0;
  my $ignore = 0;
  foreach my $c (@tape) {
    if( $ignore ge 1 ) {
      $ignore--;
    } 
    elsif( $c eq "{" and @tape[$i+1] eq "-" and @tape[$i+2] eq ">" ) {
      $ignore = 2;
      if( $buff ne "" ) {
        @tokens[$tk++] = $buff;
        $buff = "";
      }
      $i+=3;

      my $assembly_c = "";
      my $l = 1;
      while($l) {
        $ignore++;
        my $char = @tape[$i++];
        if( $char eq "<" and @tape[$i++] eq "-" ) {
          if( @tape[$i++] eq "}" ) {
            $l = 0;
            $ignore+=2;
          } else {
            $i-=2;
          }
        } elsif($char eq "<") {
          $i--;
        }

        if( $l eq 1 ) {
          $assembly_c = "$assembly_c$char";
        }
      }

      @tokens[$tk++] = "{-> $assembly_c <-}";

    } else {
      $i++;

      if( ($entry eq 0 or $c eq "[" or $c eq "]") and ( $c eq "\x20" or $c eq "\n" or not $c =~ /[A-Za-z0-9]/ ) ) {
        if( $buff ne "" ) {
          @tokens[$tk++] = $buff;
          $buff = "";
        }

        if( $c eq "[" or ( $c eq "]" and $entry ge 1 ) ) {
          if( $c eq "]" ) {
            $entry--;
            if( $entry eq 0 ) {
              @tokens[$tk++] = "$type]";
              $type = "";
            }
          } else {
            $entry++;
            $type = $c;
          }
        } else {
          if( $c ne "\x20" and $c ne "\x0a" and $c ne "\x0d" ) {
            @tokens[$tk++] = $c;
          }
        }
      } elsif( $entry ge 1 ) {
        $type = "$type$c";
      } else {
        $buff = "$buff$c";
      }

    }
  }

  # print "{\n";
  for my $token (@tokens) {
  #   print "  Token[$tk_len] {\n    buff: '$token'\n  },\n";
    $tk_len++;
  }
  # print "}\n";
}

sub parser {
  my $i = 0;
  my $id = 0;

  my $in_pendence;
  my $pendence = 0;

  my @inputs = ();

  my @puts = ();

  while($i < $tk_len) {
    my $token = @tokens[$i++];

    if( $token eq "my" or $token eq "our" ) {
      my $is_my = ($token eq "my");
  
      if( $is_my ) {
        add_line "{";
        add_end_stack "}";
        $scope++;
      }
      my $name = @tokens[$i++];
      is_identifier $name;

      my $collon = @tokens[$i++];
      is_collon $collon;


      my $type = is_type @tokens[$i++], $name;

      my $semi_sign = @tokens[$i++];
      my $rslt = is_semi_sign $semi_sign;

      if( $rslt eq 6 ) {
        add_line "$type;"
      } else {
        add_line "$type = ", 0;
      }
    } elsif( $token eq "spawn" ) {
      my $code_block = @tokens[$i++];
      my $is_public = 0;
      if( $code_block eq "our" ) {
        $code_block = @tokens[$i++];
        $is_public = 1;
      }
      is_code_block $code_block;

      my $code = substr($code_block, 3, length($code_block)-6);
      if( $is_public ) {
        add_line "$code";
      } else {
        add_line "{ $code }";
      }
    } elsif( $token eq "macro" ) {
      my $name = @tokens[$i++];
      is_identifier $name;

      my $code_block = @tokens[$i++];
      is_code_block $code_block;

      my $code = substr($code_block, 3, length($code_block)-6);
      add_macro "$name $code"
    } elsif( $token eq "def" ) {
      my $name = @tokens[$i++];
      is_identifier $name;

      my $open = @tokens[$i++];
      if( $open ne "(" ) {
        spawn_error $error_in_def;
      } 

      my $t = 1;
      my $j = 0;
      my @args = ();
      my @names = ();
      my $arg = 0;
      while($t) {
        my $k = 0;
        my $current = @tokens[$i++];
        if( $current eq ")" ) {
          $t = 0;
        } else {
          if( $j ge 1 ) {
            if( $current eq "," ) {
              $current = @tokens[$i++];
            } else {
              spawn_error $error_in_def;
            }
          }

          $i--;
          my $name = @tokens[$i++];
          is_identifier $name;

          my $collon = @tokens[$i++];
          is_collon $collon;

          my $type = is_type @tokens[$i++], $name;
          @names[$arg] = $name;
          @args[$arg++] = $type;

        }

      }

      my $n = uc($name);
      my $struct_name = "DEF_$n"; 

      my $args = "";
      my $struct = "struct $struct_name {";
      my $j = 0;
      my $ident = get_ident $scope;
      my $fun_name = $name;
      foreach $arg (@args) {
        my $name = @names[$j++];
        $args = "$ident$args$arg = call_$fun_name.$name;\n";
        $struct = "$struct\n  $arg;"
      }
      $struct = "$struct\n};";

      add_struct $struct;

      my $def = "";
      if( $j ne 0 ) {
        $def = "\nstruct $struct_name call_$name;";
      }
      add_line "int back_$name = 0;\ngoto after_def_$name;$def\n$name: {\n\n$args";

      add_end_stack "// back-stack from '$name'.\n}\nafter_def_$name: {}", 1;
    } elsif( $token eq "end" ) {
      $scope--;
      add_line closses();
    } elsif( $token eq "pendence" and $pendence eq 0) {
      my $name = @tokens[$i++];
      is_identifier $name;

      $in_pendence = $name;
      $pendence = 1;
    } elsif( $token eq "arg" and $pendence eq 1 ) {
      my $arg_name = @tokens[$i++];
      is_literal $arg_name;
      $arg_name = substr $arg_name, 2, -1; 

      my $var = @tokens[$i++];
      is_identifier $var;

      add_line "call_$in_pendence.$arg_name = $var;"
    } elsif( $token eq "call" ) {
      my $name;
      if( $pendence eq 0 ) {
        $name = @tokens[$i++];
        is_identifier $name;
      } else {
        $name = $in_pendence;
      }

      push @stack_calls, { name => $name, id => $id };
      $stack_size++;

      add_line "back_$name = $id;\ngoto $name;\nback_point_$id: {}";
      $id++;
    } elsif ( $token eq "use" ) {
      my $reference = @tokens[$i++];
      is_reference $reference;

      my $literal = substr($reference, 2, -1);
      foreach my $module (@modules) {
        my $name = $module->{aka};
        if( $name eq $literal ) {
          my $h_code = $module->{h};
          open(my $h, '>', "$name.h");
          print $h "$h_code";
          close $h;

          my $c_code = $module->{c};
          open(my $c, '>', "$name.c");
          print $c "$c_code";
          close $c;
          print "created lib: '$name' in your workspace.\n";

          add_macro "include \"$name.h\"";
          $puts = "$puts\nchar *put_$name;";
        }
      }
      $puts = "$puts\n";
    }else {
      print $token;
      if( $token =~ /[[][@](\w*|\W*\d*)[]]/ ) {
        my $reference = $1;
        my $strong = uc($reference);
        my $dot = @tokens[$i++];
        is_dot $dot;

        my $fun = @tokens[$i++];
        is_identifier $fun;

        if( $fun eq "init" ) {
          my $pointer = @tokens[$i++]; 
          is_pointer $pointer;

          my $name = substr($pointer, 4, -1);
          my $arg = "";
          foreach my $put (@puts) {
            my $owner = $put->{owner};
            if( $owner eq $reference ) {
              $arg = "put_$reference";
            }
          }
          add_line "LIB_$strong $name = init_$reference($arg);";
          
          if( $arg eq "" ) {
            my @nputs = ();
            foreach my $put (@puts) {
              my $owner = $put->{owner};
              if( $owner ne $reference ) {
                push @nputs, { owner => $reference };
              }
            }
            @puts = @nputs;
          }
        } elsif( $fun eq "put" ) {
          my $input = @tokens[$i++];

          if( 
            $input =~ /[[][@](\w*|\W*\d*)[]]/ or 
            $input =~ /[[][!](\w*|\W*\d*)[]]/ 
          ) {
            add_line "put_$reference = \"$input\";";
            push @puts, { owner => $reference };
          }
        } elsif( $fun eq "dump" and $reference eq "memory" ) {
          my $next = @tokens[$i++];
          
          if( 
            $next =~ /[[][@](\w*|\W*\d*)[]]/ 
          ) {
            add_line "free(put_$1);";
          } elsif( 
            $next =~ /[[][*][-][>](\w*|\W*\d*)[]]/ 
          ) {
            add_line "free($1);";
          }
        } else {
          spawn_error $token_type_mismatch;
        }
      }
    }
  } 
}

sub stack_call {
  foreach my $call (@stack_calls) {
    my $name = $call->{name};
    my $id = $call->{id};
    
    $result =~ s{// back-stack from '$name'.}{if(back_$name == $id) goto back_point_$id;\n// back-stack from '$name'.};
  }
}

my @std = (
  "uncertain"
);

foreach my $module (@std) {
  print "presseting module '$module'.. - Status: Waiting";
	open my $c, '<:encoding(UTF-8)', "./modules/$module/$module.c";

  my $file_c = "";
  while($linha = <$c>){
    $file_c = "$file_c$linha";
	}

  close $c;

  open my $h, '<:encoding(UTF-8)', "./modules/$module/$module.h";

  my $file_h = "";
  while($linha = <$h>){
    $file_h = "$file_h$linha";
	}

  close $h;

  push @modules, { aka => $module, h => $file_h, c => $file_c };
  print "\rpresseting module '$module'.. - Status: Completed successfully!\n";
}  

foreach $file_name (@ARGV){
	print "Reading file: $file_name\n";
	open FILE, '<:encoding(UTF-8)', $file_name;

  while($linha = <FILE>){
    $content = "$content$linha";
	}

  $content = "$content\x03";
	
  close FILE;
  lexer $content;
  parser();

  $result = "$macros\n$puts\n$result\n}";

  $result =~ s{// structs arguments}{$structs};

  stack_call();

  open(my $output, '>', "output.c");
  print $output "$result";
  close $output;
}