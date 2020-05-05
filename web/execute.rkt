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

#|
 (let* ((out-str-port (open-output-string))
        (err-str-port (open-output-string))
        (system-rv
         (parameterize ((current-output-port out-str-port) (current-error-port err-str-port))
           (system "echo -n foo; echo bar 1>&2"))))
|#
