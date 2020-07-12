#include <stdio.h>

/* define all scheme constants */
 /* original paper values
  * fx_mask     0x03
  * fx_tag      0x00
  * fx_shift    0x02
  *
  * bool_f      0x2F
  * bool_t      0x6F
  *
  * char_mask   0x0F
  * char_tag    0x0F
  * char_shift  8
  *
  * list_nil    0x3F
  */
#define fx_mask     0b11
#define fx_tag      0b00
#define fx_shift    0b10

#define bool_f      0b0101111
#define bool_t      0b1101111

#define char_mask   0b1111
#define char_tag    0b1111
#define char_shift  8

#define list_nil    0b111111


/* all scheme values are of type "pointer" ptr. Maybe its spec'd like that, maybe its maybeline. */
/* see http://www.cs.rpi.edu/academics/courses/fall00/ai/scheme/reference/schintro-v14/schintro_30.html */
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
  } else if (x == list_nil) {
    printf("()");
  } else if ((x & char_mask) == char_tag) {
    char c = (char) (x >> char_shift);
    switch(c) {
      case '\t': printf("#\\tab"); break;
      case '\n': printf("#\\newline"); break;
      case '\r': printf("#\\return"); break;
      case ' ' : printf("#\\space"); break;
      default  : printf("#\\%c", c); break;
    }
  } else {
    // Print out the unknown input hex value
    printf("#<unknown 0x%08x>", x);
  }
  printf("\n");
}

int main(int argc, char** argv) {
  print_ptr(scheme_entry());
  return 0;
}
