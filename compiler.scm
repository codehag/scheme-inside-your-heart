(load "tests/tests-driver.scm")
;(load "tests/tests-1.1-req.scm")
(load "tests/tests-1.2-req.scm")

; Step 1, or chapter 1.2 "Immediate Constants"
; <Expr> -> fixnum | boolean | char | null
; ===========================================

(define fxshift 2)
(define fxmask #x03)
(define bool_f #x2F)
(define book_t #x6F)
(define wordsize 4) ; bytes!

(define fixnum-bits (- (* wordsize 8) fxshift))

(define fxlower (- (expt 2 (- fixnum-bits 1))))

(define fxupper (sub1 (expt 2 (- fixnum-bits 1))))

(define (fixnum? x)
  (and (integer? x) (exact? x) (<= fxlower x fxupper)))

(define (immediate? x)
  (or (fixnum? x) ; (boolean? x)
      ))

(define (immediate-rep x)
  (cond
    [(fixnum? x) (ash x fxshift)]
    ; the tutorial has a weird notation for "etc". It looks lik
    ; `---`. Just... put and else in there.
    [else #f])) ; its not a fixnum

; ===========================================

(define (compile-program x)
  (unless (immediate? x) (error 'emit-program (format "'~s' not an immediate" x)))
  (emit "  .text")
  (emit "  .globl _scheme_entry")
  (emit "_scheme_entry:")
  (emit "  movl $~s, %eax" (immediate-rep x))
  (emit "  ret"))
