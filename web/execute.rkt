#lang racket

(provide execute2 promise3)

; (require racket/date)

(define execute2
    ; (display "YES")
    ; (sleep 2)
    (number->string (current-seconds)) )

(define promise3
  (begin
    (with-output-to-string (λ () (system "ls /tmp")))))
