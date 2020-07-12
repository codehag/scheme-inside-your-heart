#include <stdio.h>

/* define all scheme constants */

#define bool_f   0x2F
#define bool_t   0x6F
#define fx_mask  0x03
#define fx_tag   0x00
#define fx_shift 0x02

/* all scheme values aree of type "pointer" ptr */
typedef unsigned int ptr;

ptr scheme_entry();

static void print_ptr(ptr x) {
  /*
   * Step 1, or chapter 1.2 "Immediate Constants"
   * <Expr> -> fixnum | boolean | char | null
   *  * for fixnums, the lower bits (mask= 11b) must be 0 (tag = 00b). This leaves 30 bits to hold value
   *    of a fix num.
   *  * Characters are tagged with 8 bits (tag = 00001111b) leaving 24 bits for the value,
   *    7 of which are actually used to encode characters.
   *  * Booleans  are given a 7-bit tag (tag = 0011111b) and a 1-bit value.
   *  * The empty list is given the value 00101111b.
   *
   * & is a bitshift addition. If thee bitshift matches fxtag..*/
  if ((x & fx_mask) == fx_tag) {
    printf("%d", ((int) x) >> fx_shift);
  } else if (x == bool_f) {
    printf("#f");
  } else if (x == bool_t) {
    printf("#t");
  } else {
    // Print out the unknown input hex value
    printf("#<unknown 0x%08x>", x);
  }
  printf("\n");
}

int main(int argc, char** argv) {
  printf("%d\n", scheme_entry());
  return 0;
}
