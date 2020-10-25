#lang racket/base

(provide pre-installer)

(require racket/file
         racket/system)
(require file/untgz)

(define (pre-installer collections-top-path racl-path)
  (define private-path (build-path racl-path "private"))
  (define unpacked-path (path->string (build-path private-path "gnulib")))
  (define gnulib-path (path->string (build-path unpacked-path "gllib")))
  (define gnulib-objects (path->string (build-path gnulib-path  "*.o")))
  
  (define fadvise-path (path->string (build-path private-path "fadvise" "fadvise.c")))
  (define fadvise-output-path (path->string (build-path private-path "fadvise.o")))

  (define cksum-path (path->string (build-path private-path "cksum.c")))
  (define cksum-output-path (path->string (build-path private-path "cksum.o")))

  (define output-path (path->string (build-path private-path "cksum.so")))

  (untgz (build-path private-path "gnulib.tgz") #:dest private-path)
  (system (string-append "cd " unpacked-path " && ./configure && make CFLAGS='-fPIC'"))
  (system (string-append "gcc -c -fPIC "fadvise-path" -o "fadvise-output-path))
  (system (string-append "gcc -c -fPIC "cksum-path" -o"cksum-output-path" -I"gnulib-path))
  (system (string-append "gcc "cksum-output-path" "fadvise-output-path" "gnulib-objects" -shared -o "output-path" -I"gnulib-path))
  

  (delete-directory/files unpacked-path)
  (delete-file fadvise-output-path)
  (delete-file cksum-output-path))


  
  
