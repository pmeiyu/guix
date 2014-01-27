;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2012, 2013, 2014 Ludovic Courtès <ludo@gnu.org>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages libffi)
  #:use-module (gnu packages)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu))

(define-public libffi
  (let ((post-install-phase
         ;; Keep headers where libffi.pc expects them, but also make them
         ;; available in $includedir where some users expect them.
         '(lambda* (#:key outputs #:allow-other-keys)
            (define out (assoc-ref outputs "out"))
            (symlink (string-append out "/lib/libffi-3.0.13/include")
                     (string-append out "/include")))))
   (package
    (name "libffi")
    (version "3.0.13")
    (source (origin
             (method url-fetch)
             (uri
              (string-append "ftp://sourceware.org/pub/libffi/"
                             name "-" version ".tar.gz"))
             (sha256
              (base32
               "077ibkf84bvcd6rw1m6jb107br63i2pp301rkmsbgg6300adxp8x"))
             (patches (list (search-patch "libffi-mips-n32-fix.patch")))))
    (build-system gnu-build-system)
    (arguments `(#:phases (alist-cons-after 'install 'post-install
                                            ,post-install-phase
                                            %standard-phases)))
    (outputs '("out" "debug"))
    (synopsis "Foreign function call interface library")
    (description
     "The libffi library provides a portable, high level programming interface
to various calling conventions.  This allows a programmer to call any
function specified by a call interface description at run-time.

FFI stands for Foreign Function Interface.  A foreign function interface is
the popular name for the interface that allows code written in one language
to call code written in another language.  The libffi library really only
provides the lowest, machine dependent layer of a fully featured foreign
function interface.  A layer must exist above libffi that handles type
conversions for values passed between the two languages.")
    (home-page "http://sources.redhat.com/libffi/")

    ;; See <http://github.com/atgreen/libffi/blob/master/LICENSE>.
    (license expat))))

