#lang web-server/insta

(require web-server/templates)

(define title "BioHackrXiv Preview Service")

(static-files-path "static")

(define (fast-template thing)
  (include-template "templates/test.html"))

(define (start request)
  (response/xexpr
   `(html ((lang "en"))
          (head (title ,title)
                (link ((rel "stylesheet")
                       (href "/preview.css")
                       (type "text/css"))))
          (body
           (section ((class "page-header"))
                    (div ((class "logo"))
                         (a ((href "https://biohackrxiv.org"))
                            (img ((width "150") (src "/biohackrxiv-logo-medium.png"))))))
           (hr)
           (section ((class "page-body"))
                    (h1 ,title)
                    ,(include-template/xml "templates/preview.html"))
           (hr)
           ))))

   ; (response/xexpr
   ; `(html ,(include-template/xml "templates/preview.html") op)))

  ; (response/xexpr
  ;  '(html
  ;    (head (title "My Blog"))
  ;    (body (h1 "Under construction")))))
