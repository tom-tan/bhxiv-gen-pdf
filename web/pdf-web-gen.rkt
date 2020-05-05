#lang racket

(require "./execute.rkt")

(require web-server/servlet
         web-server/servlet-env)
(require web-server/templates)

(define title "BioHackrXiv Preview Service")
(define biohackrxiv
  '(a ((href "https://biohackrxiv.org")) "BioHackrXiv" ))
(define guidelines
  '(a ((href "https://github.com/biohackrxiv/biohackrxiv.github.io"))
      "guidelines" ))

(define intro
  `(div "You can use this page to compile your " ,biohackrxiv " paper
before submitting. Enter the location of your Git repository that
contains your " (code "paper.md") " file in markdown format. For more
information on how to format your paper, please take a look at our "
,guidelines))

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
           (section ((class "page-body"))
                    (h1 ,title)
                    (p ,intro))
                    ;; ,(include-template/xml "templates/preview.html"))
           (section ((class "page-form"))
                    (form ([id "preview-form"][action "gen-pdf"]
                                              [accept-charset "UTF-8"])
                     (div "Repository: " (input ([name "repository"][id "repository"])))
                     (label ((for "journal")) "Compile paper for:")
                     (div (radio-group
                            (radio (input ([type "radio"][name "journal"][value "bh2019"]) "BH2019" ))
                            (radio (input ([type "radio"][name "journal"][value "vbh2020"][checked "1"]) "VBH2020" ))
                            ))
                     (div (input ([type "submit"][name "commit"][value "submit"][id "button3"])))))


           (section ((class "page-footer"))
                    (hr)
                    (div ((class "copyright"))
                         (div "by the " ,biohackrxiv " team")))
           ))))

(define (call-gen-pdf data)
  (define in (open-input-file "/home/wrk/tmp/paper15886923181588692318576/paper.pdf"))
  (read-bytes 1000000 in)
  )

(define (gen-pdf2 request)
  (define data (request-post-data/raw request))
  ;; given: #"repository=&commit=Generate+PDF"
  (define str (format "got post data: ~v" data))
  (response/full
    200                  ; HTTP response code.
    #"OK"                ; HTTP response message.
    (current-seconds)    ; Timestamp.
    ; TEXT/HTML-MIME-TYPE  ; MIME type for content.
    ; Content-Type: text/html; charset=utf-8
    #"application/pdf"
    '(
      "Content-Disposition:attachment;filename='downloaded.pdf'")                  ; Additional HTTP headers.
    (bytes->list                ; Content (in bytes) to send to the browser.
      (call-gen-pdf str))))


(define (gen-pdf request)
  (define bindings (request-bindings request))
  (define journal (extract-binding/single 'journal bindings))
  (define repository (extract-binding/single 'repository bindings))
  (define promise2 (number->string (current-seconds)))
  (define tmpdir (path->string (make-temporary-file "paper~a" 'directory)))
  (define tmp-pdf (path->string (build-path tmpdir "paper.pdf")))
  (define promise4
    (begin
      (current-directory tmpdir)
      (with-output-to-string (λ () (system (string-append "git clone " repository))))
      (let ([papermd (first (find-files (lambda (filen) (string-contains? (path->string filen) "paper.md"))))])
      (with-output-to-string (λ () (system (string-append "ruby /home/wrk/iwrk/opensource/code/jro/bhxiv-gen-pdf/bin/gen-pdf " (path->string (path-only papermd)) " Covid2020 " tmp-pdf)))))
      ))
  (response/full
    200                  ; HTTP response code.
    #"OK"                ; HTTP response message.
    (current-seconds)    ; Timestamp.
    #"application/pdf"
    ; (make-header #"Content-Disposition" #"attachment")
    (list (make-header #"filename" #"biohackrxiv-paper.pdf"))
    (list (call-gen-pdf tmp-pdf))))

(define (error-handler request)
  (response/xexpr
   `(html
     (body
      (h1 "ERROR")))))

(define-values (dispatch generate-url)
  (dispatch-rules
    [("start") start]
    ;; [("gen-pdf") #:method "post" gen-pdf]
    [("gen-pdf") gen-pdf]
    ; [("style.css") (λ (_) (file-response 200 #"OK" "style.css"))])
    [else (error "There is no procedure to handle the url.")]))

(define (request-handler request)
  (dispatch request))

(serve/servlet request-handler
               #:port 8080
               #:launch-browser? #t
               #:stateless? #t
               #:servlet-path "/start"
               #:servlets-root "/"
               #:servlet-regexp	#rx"(preview)|(start)|(gen-pdf)"
               #:server-root-path (current-directory)
               #:file-not-found-responder error-handler
               #:extra-files-paths
               (list
                (build-path "static"))
               )
