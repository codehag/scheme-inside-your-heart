(add-tests-with-string-output "write-char"
  [(begin 
    (write-char #\a)
    (flush-output-port (current-output-port))
    (exit)) => "a"]
  [(begin 
    (write-char #\a)
    (close-output-port (current-output-port))
    (exit)) => "a"]
  [(begin 
    (write-char #\H)
    (write-char #\e)
    (write-char #\l)
    (write-char #\l)
    (write-char #\o)
    (write-char #\space)
    (flush-output-port)
    (write-char #\W)
    (write-char #\o)
    (write-char #\r)
    (write-char #\l)
    (write-char #\d)
    (write-char #\!)
    (flush-output-port (current-output-port))
    (exit)) => "Hello World!"]
)
