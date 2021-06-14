#lang racket

(require "./execute.rkt")

(require web-server/servlet
         web-server/servlet-env)
(require web-server/templates)

(define title "BioHackrXiv preview service")
(define left-title
  '(a ((href "http://preview.biohackrxiv.org/")) "PDF Generator"))
(define biohackrxiv
  '(a ((href "https://biohackrxiv.org")) "BioHackrXiv" ))
(define guidelines
  '(a ((href "https://github.com/biohackrxiv/biohackrxiv.github.io"))
      "journal guidelines" ))
(define paper-repo-url
  '(a ((href "https://github.com/biohackrxiv/bhxiv-gen-pdf"))
      "https://github.com/biohackrxiv/bhxiv-gen-pdf"))
(define code-repo-url
  '(a ((href "https://github.com/biohackrxiv/bhxiv-gen-pdf/blob/master/web/pdf-web-gen.rkt"))
      "code"))

(define intro
  `(div "You can use this page to compile your " ,biohackrxiv " paper
before submitting. Enter the location of your Git repository that
contains your " (code "paper.md") " file in markdown format
and " (code "paper.bib" ) " in BibTex format. For more information on
how to format your paper, please take a look at our " ,guidelines))

(define (start request)
  (response/xexpr
   `(html ((lang "en"))
          (head (title ,title)
                (link ((rel "stylesheet")
                       (href "/style.css")
                       (type "text/css")))
                (link ((rel "stylesheet")
                       (href "/biohackrxiv.css")
                       (type "text/css"))))
          (body
           (header
            (h1 ,left-title))
           (section ((class "page-body"))
                    ;; ,(include-template/xml "templates/preview.html"))
                    (h1 ,title)

                    (div ((class "logo"))
                         (a ((href "https://biohackrxiv.org"))
                            (img ((src "/BioHackrXiv-logo-transparent-340x140.png")))))
                    (p ,intro)
                    (form ([id "preview-form"][action "gen-pdf"]
                                              [accept-charset "UTF-8"])
                          (div "Repository: " (input ([name "repository"][size "60"][id "repository"][required ""][placeholder "https://github.com/biohackrxiv/submission-templates.git"])))
                          (p "For example paste URL: " ,paper-repo-url)

                          (label ((for "journal")) "Compile paper for:")
                          (div (radio-group

                                (div (radio (input ([type "radio"][name "journal"][value "Japan2018"]) "NBDC/DBCLS BioHackathon, Matsue, Japan, 2018" )))
                                (div (radio (input ([type "radio"][name "journal"][value "Japan2019"]) "NBDC/DBCLS BioHackathon, Fukuoka, Japan, 2019" )))
                                (div (radio (input ([type "radio"][name "journal"][value "France2019"]) "BioHackathon EUROPE, Paris, France, 2019" )))
                                (div (radio (input ([type "radio"][name "journal"][value "Covid2020"][checked "1"]) "Virtual BioHackathon Covid-2020" )))
                                ))
                          (div (input ([type "submit"][name "commit"][value "submit"]))))

           (footer
            (hr)
            (div ((class "copyright")) "Source " ,code-repo-url
                 " by the " ,biohackrxiv " team"))
           )))))

(define (call-gen-pdf fn)
  (with-input-from-file fn
    (lambda () (read-bytes (file-size fn)))))

(define (gen-pdf request)
  (define bindings (request-bindings request))
  (define journal (extract-binding/single 'journal bindings))
  (define repository (extract-binding/single 'repository bindings))
  (define tmpdir (path->string (make-temporary-file "paper~a" 'directory)))
  (define tmp-pdf (path->string (build-path tmpdir "paper.pdf")))
  (define compile
    (begin
      (current-directory tmpdir)
      (invoke (string-append "git clone " repository))
      (let ([papermds (find-files (lambda (filen) (string-contains? (path->string filen) "paper.md")))])
        (if (= (length papermds) 0)
            (error (string-append "paper.md not found in " repository))
            (invoke (string-append "ruby /home/wrk/iwrk/opensource/code/jro/bhxiv-gen-pdf/bin/gen-pdf " (path->string (path-only (first papermds))) " " journal " " tmp-pdf))))))
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
    [("") start]
    ;; [("gen-pdf") #:method "post" gen-pdf]
    [("gen-pdf") gen-pdf]
    ; [else (error "There is no procedure to handle the url.")]))
    ))

(define (request-handler request)
  (dispatch request))

(serve/servlet request-handler
               #:port 8080
               #:launch-browser? #t
               #:stateless? #t
               #:servlet-path "/"
               #:servlets-root "/"
               #:servlet-regexp	#rx"start|gen-pdf|\\s*"
               #:server-root-path (current-directory)
               #:file-not-found-responder error-handler
               #:extra-files-paths
               (list
                (build-path (current-directory) "web/static"))
               )
