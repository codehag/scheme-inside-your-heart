(module

  ;; Import our print function
  (import "env" "print" (func $print (param i32)))

  ;; Define a single page memory of 64KB.
  (memory $0 1)

  ;; OUTPUT
  ;; Store the digit as a number (null terminated) string at byte offset 0
  (data (i32.const 8) "7\00")

  ;; Export the memory so it can be access in the host environment.
  (export "pagememory" (memory $0))

  ;; Define a function to be called from our host
  (func $out
    (call $print (i32.const 8))
  )

  ;; Export the out function for the host to call.
  (export "out" (func $out))
)
