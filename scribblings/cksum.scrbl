#lang scribble/manual
@require[@for-label[cksum
                    racket/base]]

@title{cksum}
@author{David Wilson}

@defmodule[cksum]
Allows for calculation of CRC checksums of files in the style of the cksum utility from GNU Coreutils. Uses code from GNU Coreutils and gnulib.

@table-of-contents[]

@section[#:tag "Usage"]{Usage}
> (require cksum)

> (get-cksum "main.rkt")
'("1628897698" 1607 "main.rkt")

get-cksum returns a list of three elements:

1. The checksum
2. The count of bytes in the file
3. The filename

