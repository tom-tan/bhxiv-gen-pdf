#lang racket

(require web-server/servlet
         web-server/servlet-env)
(require web-server/templates)

(define title "BioHackrXiv Preview Service")

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

(define (preview request)
  (response/xexpr
   `(html
     (body
      (h1 "HELLO WORLD")))))

(serve/servlet start
               #:port 8080
               #:servlet-path "/preview"
               #:extra-files-paths
               (list
                (build-path "static"))
               )
