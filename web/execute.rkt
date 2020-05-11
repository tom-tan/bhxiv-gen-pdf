#lang racket

(provide invoke)

(define (invoke repository)
  (error
   (call-with-output-string
    (lambda (p) (parameterize ([current-error-port p])
                  (system (string-append "git clone " repository))))))
  )

#|
 (let* ((out-str-port (open-output-string))
        (err-str-port (open-output-string))
        (system-rv
         (parameterize ((current-output-port out-str-port) (current-error-port err-str-port))
           (system "echo -n foo; echo bar 1>&2"))))
      (error
       (call-with-output-string
         (lambda (p) (parameterize ([current-error-port p])
               (system (string-append "git clone " repository))))))
      ; (with-output-to-string (λ () (system (string-append "git clone " repository)))))
|#
