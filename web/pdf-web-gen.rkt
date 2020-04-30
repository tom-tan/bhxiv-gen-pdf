#lang web-server/insta

(require web-server/templates)

(static-files-path "static")

(define (start1 request)
  ; (response/output
  ; (include-template "templates/preview.html")))

  (response/output
   (λ (op) (display (include-template "templates/preview.html") op))))

(define (fast-template thing)
  (include-template "templates/test.html"))

(define (start request)
  (response/xexpr
   `(html (head (title "Testing")
                (link ((rel "stylesheet")
                       (href "/preview.css")
                       (type "text/css"))))
          (body (h1 "Testing")
                (h2 "This is a header")
                (p (fast-template "templates/test.html"))
                ,(include-template/xml "templates/test.html")
                (p "This is " (span ((class "hot")) "hot") ".")))))

   ; (response/xexpr
   ; `(html ,(include-template/xml "templates/preview.html") op)))

  ; (response/xexpr
  ;  '(html
  ;    (head (title "My Blog"))
  ;    (body (h1 "Under construction")))))
