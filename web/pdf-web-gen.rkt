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
                       (href "/style.css")
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
           (section ((class "page-footer"))
                    (hr)
                    (div ((class "copyright"))
                         (div "by the BioHackrXiv team")))
           ))))

(define (call-gen-pdf data)
  (eprintf data)
  "Generating the PDF..."
  )

(define (gen-pdf request)
  (define data (request-post-data/raw request))
  (define str (format "got post data: ~v" data))
  (response/full
    200                  ; HTTP response code.
    #"OK"                ; HTTP response message.
    (current-seconds)    ; Timestamp.
    TEXT/HTML-MIME-TYPE  ; MIME type for content.
    '()                  ; Additional HTTP headers.
    (list                ; Content (in bytes) to send to the browser.
      (string->bytes/utf-8 (call-gen-pdf str)))))

(define (preview request)
  (response/xexpr
   `(html
     (body
      (h1 "HELLO WORLD")))))

(define (error-handler request)
  (response/xexpr
   `(html
     (body
      (h1 "ERROR")))))

(define-values (dispatch generate-url)
  (dispatch-rules
    [("start") start]
    [("preview") preview]
    [("gen-pdf") #:method "post" gen-pdf]
    [else (error "There is no procedure to handle the url.")]))

(define (request-handler request)
  (dispatch request))

(serve/servlet request-handler
               #:port 8080
               #:launch-browser? #t
               #:servlet-path "/start"
               #:servlet-regexp	#rx"(preview)|(start)|(gen-pdf)"
               #:server-root-path (current-directory)
               #:file-not-found-responder error-handler
               #:extra-files-paths
               (list
                (build-path "static"))
               )
