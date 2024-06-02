#ifndef UNCERTAIN_H
# define UNCERTAIN_H
# define DEF_T_RESULT 0
# define DEF_T_OPTION 1

typedef union {
  char _;
  char t;
  void *value;
} T_RESULT, T_OPTION, LIB_UNCERTAIN;

LIB_UNCERTAIN init_uncertain(char *t);
#endif