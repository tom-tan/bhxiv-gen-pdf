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
   `(html ((lang "en"))
          (head (title "BioHackrXiv PDF generator")
                (link ((rel "stylesheet")
                       (href "/preview.css")
                       (type "text/css"))))
          (body
           (section ((class "header"))
                    (div ((class "logo"))
                         (a ((href "https://biohackrxiv.org"))
                            (img ((width "150") (src "/biohackrxiv-logo-medium.png"))))))
           (h1 "Testing")
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
