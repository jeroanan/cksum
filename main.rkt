#lang racket/base

; Copyright 2020 David Wilson
; See COPYING for details.

(provide get-cksum)

(require ffi/unsafe
         racket/list
         racket/runtime-path
         racket/string
         (for-syntax racket/base))

(define-runtime-path lib-path (build-path "private" "cksum"))
(define clib (ffi-lib lib-path))

(define _cksum-file
  (get-ffi-obj "cksum" clib
               (_fun _string _bool (o : (_ptr o _cksum)) 
                     -> (r : _int)
                     -> o)))

(define (_bytes/len n)
  (make-ctype (make-array-type _byte n)
              ;; see https://github.com/dyoo/ffi-tutorial

              ;; ->c
              (lambda (v)
                (unless (and (bytes? v) (= (bytes-length v) n))
                  (raise-argument-error '_chars/bytes 
                                        (format "bytes of length ~a" n)
                                        v))
                v)

              ;; ->racket
              (lambda (v)
                (make-sized-byte-string v n))))

(define _cksum-len 99)
(define _cksum (_bytes/len _cksum-len))

(define (bytes->string bs)
  (define bytes-list (bytes->list bs))  
  (define first-null (index-of bytes-list 0))
  (define no-nulls (take bytes-list first-null))
  (define output (list->bytes no-nulls))
  (bytes->string/utf-8 output))

(define (get-cksum filename)
  (define raw-cksum (_cksum-file filename #t))
  (define string-output (bytes->string raw-cksum))
  (define split (string-split string-output " "))
  (list (first split)
        (string->number (second split))
        (string-join (rest (rest split)) " ")))
