#ifndef UNCERTAIN_H
# define UNCERTAIN_H
# define DEF_T_RESULT 0
# define DEF_T_OPTION 1

typedef struct {
  char _;
  char t;
  void *value;
} T_RESULT, T_OPTION, LIB_UNCERTAIN;

LIB_UNCERTAIN init_uncertain(char *t);
void uncertain_assert_operator(LIB_UNCERTAIN __struct, char *op);

void uncertain_def_ok(LIB_UNCERTAIN *__struct, void *generic);
void uncertain_def_some(LIB_UNCERTAIN *__struct, void *generic);
void uncertain_def_err(LIB_UNCERTAIN *__struct, void *generic);
void uncertain_def_none(LIB_UNCERTAIN *__struct);

void uncertain_debug(LIB_UNCERTAIN *__struct);
#endif