use strict;

my $buff;
my $linha;
my @tokens;
my $scope = 0;
my $file_name;
my $tk_len = 0;
my $macros = "";
my $content = "";
my @closses_when = ();
my @closses_stack = ();
my $closses_when_len = 0;
my @closses_stack_index = ();
my $closses_stack_length = 0;

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
typedef char* string;\n\nint\nmain()\n{\n"; 

my $type_len = 0;
my @types = (
  "u8", "i8", "bool",
  "u16", "i16",
  "u32", "i32",
  "u64", "i64",
  "u128", "i128",
  "string"
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
  my $first = shift @_;

  if( $first eq 1 ) {
    @closses_when[$closses_when_len++] = $scope; 
  }

  @closses_stack[$closses_stack_length] = $end;
  @closses_stack_index[$closses_stack_length] = $scope;
  $closses_stack_length++;
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
    "It's not a code-block string"
  );

  print "Error! - [$error]\n x ", @errors[$error], "\n";
  exit 0;
}

sub validate {
  my @keywords = (
    "use",   "my",   "our",  "end",   "sub",    "type",   "then", "end_process",
    "spawn", "goto", "type", "union", "struct", "static", "do",   "macro"
  );

  my $keyword;
  foreach $keyword (@keywords) {
    if( $keyword eq $buff ) {
      return 1;
    }
  }

  if( $buff =~ /^[a-zA-Z_][a-zA-Z0-9_]*$/ ) {
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

sub is_type {
  my $type = shift @_;
  my $name = shift @_;
  my $only_get = shift @_;
  if( $type =~ /[\[](\d+|_); (\w+|\W+)[\]]/ ) { 
    if($1 ne "_") {
      return "$2 $name\[$1]";
    } else {
      return "$2 *$name";
    }
  } else {
    foreach my $type_ (@types) {
      if( $type_ eq $type ) {
        return "$type $name";
      }
    }
    spawn_error $its_not_type;
  }
}

sub closses {
  my $period = @closses_when[$closses_when_len];
  $closses_when_len--;
  if( $period eq $closses_stack_length ) {
    $closses_stack_length--;

    my $bracket = @closses_stack[$closses_stack_length];
    my $ident = get_ident(@closses_stack_index[$closses_stack_length]);
    
    return "$ident$bracket"
  } elsif( $period < $closses_stack_length ) {
    my $i = $closses_stack_length;

    my $result = "";
    while($i > $period) {
      $closses_stack_length--;
      my $ident = get_ident(@closses_stack_index[$closses_stack_length]);
      my $bracket = @closses_stack[$closses_stack_length];
      $result = "$result$ident$bracket\n";
      $i--;
    }
    return $result;
  }
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
    elsif( $c == "{" and @tape[$i+1] eq "-" and @tape[$i+2] eq ">" ) {
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
        print $char;
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

  print "{\n";
  for my $token (@tokens) {
    print "  Token[$tk_len] {\n    buff: '$token'\n  },\n";
    $tk_len++;
  }
  print "}\n";
}

sub parser {
  my $i = 0;

  add_end_stack "\x0d}", 1;

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
    }
  }
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

  my $close = closses(); 
  $result = "$macros\n$result\n$close";

  print $result;
  open(my $output, '>', "output.c");
  print $output "$result";
  close $output;
}