int cast_gtoi32(void* generic) {
  int* int_ptr = (int*)generic;
  return *int_ptr;
}