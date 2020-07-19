; Tests
(load "tests/tests-driver.scm")
(load "tests/tests-1.1-req.scm")
(load "tests/tests-1.2-req.scm")

; Step 1, or chapter 1.2 "Immediate Constants"
; <Expr> -> fixnum | boolean | char | null
;   An immediate constant is something which can be
;   represented in a register without an extra pointer.
; ===========================================

; see section on fixnums
; Yulia's notes: How is the bitmask implemented? A fixnum is a number as it is
; represented on the target machine's architecture.  For example,
; 00000000000000000000000000000000 is ... 0, on a 32 bit machine.  This is
; represented in the tutorial as 00...0000b. As described in the paper, we need
; to tell the computer architecture that this is a fixnum. We do this by
; using a couple of those 32 bits. In the end, 0 is
; +-----------------------------------+
; | 000000000000000000000000000000 00 |
; |                              ^  ^ |
; |        the number in binary--+  | |
; |                       the tag --+ |
; +-----------------------------------+
; The tutorial refers to these tags as being positioned in "the least siginficant digits".
; This refers to the digits that represent the smallest two numbers. In other words, the
; number we record in the 32 bit register, is shifted by 1 (fxshift 2). The fxmask is represented
; in hexedecimal in the paper (#x03). It represents "11" in binary (the number 3). This is hard to
; read. We can instead use binary in scheme, using #b11. It makes it clearer what we are trying to
; do.  In the original paper it is present, but not used. It might be used to check if something
; is a fixnum at a later point. It is used in startup.c at this point.
;
(define fxshift 2)
;(define fxmask #b11) ; in the paper exersize as #x03

; Similarily, all other values have a mask of least siginficant digits starting with #b1111, as you
; see in the bool definition and charmask/chartag. See section on bools for more info.
(define bool_f #b0101111) ; in the paper exercise as #x2F.
(define bool_t #b1101111) ; in the paper exercise as #x6f.

; see section on characters
(define charmask  #b1111) ; in the paper exercise as #x0F
(define chartag   #b1111) ; in the paper exercise as #x0F

(define charshift 8)

; see section on nil
(define list_nil #b111111) ; in thee paper exercise as #x3F

(define wordsize 4) ; bytes!

; fixnum :
; Yulia's notes: what this is doing, is it is taking the evalue, and "arithmetically shifting it"
; with fxshift.  An arithmetic shift on the binary number 01 by 1, (ash #b01 #b01), would result
; in "#b10", or "2". Simliarily, (ash #b11 #b01), or (ash 3 1) results in #b110, or "6".
;
; So, what does this do? remember that we have a tag of 00 in our numbers. So any plain number, like
; say, "2", in binary, would have to be shifted 2 numbers to the left. Instead of 0010, it is
; represented on the machine as 1000, leaving room for 2 bits as a tag. The tag allows us to
; represent the number and communicate what it is.
(define (to-fixnum x) (ash x fxshift))

(define fixnum-bits (- (* wordsize 8) fxshift))

(define fxlower (- (expt 2 (- fixnum-bits 1))))

(define fxupper (sub1 (expt 2 (- fixnum-bits 1))))

(define (fixnum? x)
  (and (integer? x) (exact? x) (<= fxlower x fxupper)))

; to-char : (Char char) -> encoded
; Yulia's notes: this returns an encoding of a character.
(define (to-char x)
  (bitwise-ior (ash (char->integer x) charshift) chartag))

(define (immediate? x)
  (or (fixnum? x) (boolean? x) (char? x) (null? x)))

(define (immediate-rep x)
  (cond
    [(fixnum? x) (ash x fxshift)]
    [(boolean? x) (if x bool_t bool_f)]
    [(char? x) (to-char x)]
    [(null? x) list_nil]
    [else #f])) ; its not an immediate

; ===========================================

(define (compile-program x)
  (unless (immediate? x) (error 'compile-program (format "'~s' s not an immediate" x)))
  (emit "  .text")
  (emit "  .globl _scheme_entry")
  (emit "_scheme_entry:")
  (emit "  movl $~s, %eax" (immediate-rep x))
  (emit "  ret"))

(define (compile-program->web x)
  (unless (immediate? x) (error 'compile-program (format "'~s' s not an immediate" x)))
  (emit "(module")
  (emit "  (import \"env\" \"print\" (func $print (param i32)))")
  (emit "  (memory $0 1)")
  (emit "  (data (i32.const 8) $~s)" (immediate-rep x))
  (emit "  (export \"pagememory\" (memory $0))")
  (emit "  (func $out")
  (emit "    (call $print (i32.const 8))")
  (emit "  )")
  (emit "  (export \"out\" (func $out))")
  (emit ")"))

;; Just the basic Hello World for now
(define (compile-program->wasi x)
  (unless (immediate? x) (error 'compile-program (format "'~s' s not an immediate" x)))
  (emit "(module")
  (emit "    (import \"wasi_unstable\" \"fd_write\" (func $fd_write (param i32 i32 i32 i32) (result i32)))")
  (emit "    (memory 1)")
  (emit "    (export \"memory\" (memory 0))")
  (emit "    (data (i32.const 8) $~s)" (immediate-rep x))
  (emit "    (func $main (export \"_start\")")
  (emit "        (i32.store (i32.const 0) (i32.const 8))")
  (emit "        (i32.store (i32.const 4) (i32.const 12))")
  (emit "        (call $fd_write")
  (emit "            (i32.const 1) ")
  (emit "            (i32.const 0)")
  (emit "            (i32.const 1)")
  (emit "            (i32.const 20)")
  (emit "        )")
  (emit "        drop ")
  (emit "    )")
  (emit ")"))
