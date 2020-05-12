#lang racket

(provide invoke)

(define (invoke command)
  (let* ([out-str-port (open-output-string)]
         [err-str-port (open-output-string)]
         [system-rv
          (begin
            (display (string-append "Executing: " command) (current-error-port))
            (parameterize ((current-output-port out-str-port) (current-error-port err-str-port))
            (system command)))])
    (match (list system-rv (get-output-string out-str-port) (get-output-string err-str-port))
      [(list #f stdout stderr) (error (string-append stdout stderr))]
      [else #t]
      )))
