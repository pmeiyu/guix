;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2016 Jan Nieuwenhuizen <janneke@gnu.org>
;;; Copyright © 2016, 2017 Mathieu Lirzin <mthl@gnu.org>
;;; Copyright © 2017, 2020 Mathieu Othacehe <m.othacehe@gmail.com>
;;; Copyright © 2017, 2019, 2020 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2018 Clément Lassieur <clement@lassieur.org>
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

(define-module (gnu packages ci)
  #:use-module ((guix licenses) #:prefix l:)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages mail)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages perl-compression)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml)
  #:use-module (guix build-system gnu))

;; Guile-Sqlite3 package adding SQL query logging support.
;; Remove it when next Guile-Sqlite3 release is out.
(define-public guile-sqlite3-dev
  (let ((commit "22ef45d268de7707cbbb943c404f9b0c1668e2e1")
        (revision "1"))
    (package
      (inherit guile-sqlite3)
      (name "guile-sqlite3")
      (version (git-version "0.1.2" revision commit))
      (home-page "https://notabug.org/mothacehe/guile-sqlite3.git")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url home-page)
                      (commit commit)))
                (sha256
                 (base32
                  "1q90f8zhw9n1c39szd2ba7aj5fi92m09pnlv0z7jbhnnjam5jwcd"))
                (file-name (string-append name "-" version "-checkout")))))))

(define-public cuirass
  (let ((commit "b310f17aaff8f17af0e7cf77b0b9d6866fe89abe")
        (revision "47"))
    (package
      (name "cuirass")
      (version (git-version "0.0.1" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://git.savannah.gnu.org/git/guix/guix-cuirass.git")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "19cgwqsgikn2mf95406jzsaqa65whh8ygqripawnzl0hl7pnmrvn"))))
      (build-system gnu-build-system)
      (arguments
       '(#:modules ((guix build utils)
                    (guix build gnu-build-system)
                    (ice-9 rdelim)
                    (ice-9 popen))

         #:configure-flags '("--localstatedir=/var") ;for /var/log/cuirass

         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'disable-repo-tests
             (λ _
               ;; Disable tests that use a connection to the Guix daemon.
               (substitute* "Makefile.am"
                 (("tests/repo.scm \\\\") "\\"))
               #t))
           (add-after 'disable-repo-tests 'patch-/bin/sh
             (lambda _
               (substitute* "build-aux/git-version-gen"
                 (("#!/bin/sh") (string-append "#!" (which "sh"))))
               #t))
           (add-after 'install 'wrap-program
             (lambda* (#:key inputs outputs #:allow-other-keys)
               ;; Wrap the 'cuirass' command to refer to the right modules.
               (let* ((out    (assoc-ref outputs "out"))
                      (gcrypt (assoc-ref inputs "guile-gcrypt"))
                      (json   (assoc-ref inputs "guile-json"))
                      (sqlite (assoc-ref inputs "guile-sqlite3"))
                      (git    (assoc-ref inputs "guile-git"))
                      (bytes  (assoc-ref inputs "guile-bytestructures"))
                      (fibers (assoc-ref inputs "guile-fibers"))
                      (zlib   (assoc-ref inputs "guile-zlib"))
                      (guix   (assoc-ref inputs "guix"))
                      (deps   (list gcrypt json sqlite git bytes fibers
                                    zlib guix))
                      (guile  (assoc-ref %build-inputs "guile"))
                      (effective (read-line
                                  (open-pipe* OPEN_READ
                                              (string-append guile "/bin/guile")
                                              "-c" "(display (effective-version))")))
                      (mods   (string-drop-right  ;drop trailing colon
                               (string-join deps
                                            (string-append "/share/guile/site/"
                                                           effective ":")
                                            'suffix)
                               1))
                      (objs   (string-drop-right
                               (string-join deps
                                            (string-append "/lib/guile/" effective
                                                           "/site-ccache:")
                                            'suffix)
                               1)))
                 ;; Make sure 'cuirass' can find the 'evaluate' command, as
                 ;; well as the relevant Guile modules.
                 (wrap-program (string-append out "/bin/cuirass")
                   `("PATH" ":" prefix (,(string-append out "/bin")))
                   `("GUILE_LOAD_PATH" ":" prefix (,mods))
                   `("GUILE_LOAD_COMPILED_PATH" ":" prefix (,objs)))
                 #t))))))
      (inputs
       `(("guile" ,guile-3.0/libgc-7)
         ("guile-fibers" ,guile-fibers)
         ("guile-gcrypt" ,guile-gcrypt)
         ("guile-json" ,guile-json-4)
         ("guile-sqlite3" ,guile-sqlite3-dev)
         ("guile-git" ,guile-git)
         ("guile-zlib" ,guile-zlib)
         ;; FIXME: this is propagated by "guile-git", but it needs to be among
         ;; the inputs to add it to GUILE_LOAD_PATH.
         ("guile-bytestructures" ,guile-bytestructures)
         ("guix" ,guix)))
      (native-inputs
       `(("autoconf" ,autoconf)
         ("automake" ,automake)
         ("pkg-config" ,pkg-config)
         ("texinfo" ,texinfo)))
      (native-search-paths
       ;; For HTTPS access, Cuirass itself honors these variables, with the
       ;; same semantics as Git and OpenSSL (respectively).
       (list (search-path-specification
              (variable "GIT_SSL_CAINFO")
              (file-type 'regular)
              (separator #f)                      ;single entry
              (files '("etc/ssl/certs/ca-certificates.crt")))
             (search-path-specification
              (variable "SSL_CERT_DIR")
              (files '("etc/ssl/certs")))))
      (synopsis "Continuous integration system")
      (description
       "Cuirass is a continuous integration tool using GNU Guix.  It is
intended as a replacement for Hydra.")
      (home-page "https://www.gnu.org/software/guix/")
      (license l:gpl3+))))
