#lang racket

(provide execute2 promise3)

; (require racket/date)

(define execute2
    ; (display "YES")
    ; (sleep 2)
    (number->string (current-seconds)) )

(define promise3
  (begin
    (current-seconds)
    (with-output-to-string (λ () (system "date")))))

(define promise4
  (begin
;     (with-output-to-string (λ () (system "../bin/gen-pdf ~/iwrk/opensource/code/jro/bhxiv-gen-pdf/example/logic/")))
    (number->string (current-seconds))
                              ))
