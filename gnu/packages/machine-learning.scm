;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015, 2016, 2017, 2018, 2019, 2020, 2021 Ricardo Wurmus <rekado@elephly.net>
;;; Copyright © 2016, 2020, 2021 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016, 2017, 2020 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2016 Hartmut Goebel <h.goebel@crazy-compilers.com>
;;; Copyright © 2018, 2019, 2020 Tobias Geerinckx-Rice <me@tobias.gr>
;;; Copyright © 2018 Kei Kebreau <kkebreau@posteo.net>
;;; Copyright © 2018 Mark Meyer <mark@ofosos.org>
;;; Copyright © 2018 Ben Woodcroft <donttrustben@gmail.com>
;;; Copyright © 2018 Fis Trivial <ybbs.daans@hotmail.com>
;;; Copyright © 2018 Julien Lepiller <julien@lepiller.eu>
;;; Copyright © 2018 Björn Höfling <bjoern.hoefling@bjoernhoefling.de>
;;; Copyright © 2019 Nicolas Goaziou <mail@nicolasgoaziou.fr>
;;; Copyright © 2019, 2020 Guillaume Le Vaillant <glv@posteo.net>
;;; Copyright © 2019 Brett Gilio <brettg@gnu.org>
;;; Copyright © 2020 Konrad Hinsen <konrad.hinsen@fastmail.net>
;;; Copyright © 2020 Edouard Klein <edk@beaver-labs.com>
;;; Copyright © 2020, 2021 Vinicius Monego <monego@posteo.net>
;;; Copyright © 2020 Maxim Cournoyer <maxim.cournoyer@gmail.com>
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

(define-module (gnu packages machine-learning)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix download)
  #:use-module (guix svn-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system ocaml)
  #:use-module (guix build-system python)
  #:use-module (guix build-system r)
  #:use-module (guix git-download)
  #:use-module (gnu packages)
  #:use-module (gnu packages adns)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages check)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages cran)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages dejagnu)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages image)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages mpi)
  #:use-module (gnu packages ocaml)
  #:use-module (gnu packages onc-rpc)
  #:use-module (gnu packages parallel)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-science)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages rpc)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages sphinx)
  #:use-module (gnu packages statistics)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages swig)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module (ice-9 match))

(define-public fann
  ;; The last release is >100 commits behind, so we package from git.
  (let ((commit "d71d54788bee56ba4cf7522801270152da5209d7"))
    (package
      (name "fann")
      (version (string-append "2.2.0-1." (string-take commit 8)))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/libfann/fann")
                      (commit commit)))
                (file-name (string-append name "-" version "-checkout"))
                (sha256
                 (base32
                  "0ibwpfrjs6q2lijs8slxjgzb2llcl6rk3v2ski4r6215g5jjhg3x"))))
      (build-system cmake-build-system)
      (arguments
       `(#:phases
         (modify-phases %standard-phases
           (replace 'check
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out")))
                 (with-directory-excursion (string-append (getcwd) "/tests")
                   (invoke "./fann_tests"))))))))
      (home-page "http://leenissen.dk/fann/wp/")
      (synopsis "Fast Artificial Neural Network")
      (description
       "FANN is a neural network library, which implements multilayer
artificial neural networks in C with support for both fully connected and
sparsely connected networks.")
      (license license:lgpl2.1))))

(define-public libsvm
  (package
    (name "libsvm")
    (version "3.23")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://www.csie.ntu.edu.tw/~cjlin/libsvm/"
                           name "-" version ".tar.gz"))
       (sha256
        (base32 "0jpaq0rr92x38p4nk3gjan79ip67m6p80anb28z1d8601miysyi5"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no "check" target
       #:phases (modify-phases %standard-phases
                  (delete 'configure)
                  (replace
                   'install             ; no ‘install’ target
                   (lambda* (#:key outputs #:allow-other-keys)
                     (let* ((out (assoc-ref outputs "out"))
                            (bin (string-append out "/bin/")))
                       (mkdir-p bin)
                       (for-each (lambda (file)
                                   (copy-file file (string-append bin file)))
                                 '("svm-train"
                                   "svm-predict"
                                   "svm-scale")))
                     #t)))))
    (home-page "https://www.csie.ntu.edu.tw/~cjlin/libsvm/")
    (synopsis "Library for Support Vector Machines")
    (description
     "LIBSVM is a machine learning library for support vector
classification, (C-SVC, nu-SVC), regression (epsilon-SVR, nu-SVR) and
distribution estimation (one-class SVM).  It supports multi-class
classification.")
    (license license:bsd-3)))

(define-public python-libsvm
  (package (inherit libsvm)
    (name "python-libsvm")
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no "check" target
       #:make-flags '("-C" "python")
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (replace
          'install                      ; no ‘install’ target
          (lambda* (#:key inputs outputs #:allow-other-keys)
            (let ((site (string-append (assoc-ref outputs "out")
                                       "/lib/python"
                                       (string-take
                                        (string-take-right
                                         (assoc-ref inputs "python") 5) 3)
                                       "/site-packages/")))
              (substitute* "python/svm.py"
                (("../libsvm.so.2") "libsvm.so.2"))
              (mkdir-p site)
              (for-each (lambda (file)
                          (copy-file file (string-append site (basename file))))
                        (find-files "python" "\\.py"))
              (copy-file "libsvm.so.2"
                         (string-append site "libsvm.so.2")))
            #t)))))
    (inputs
     `(("python" ,python)))
    (synopsis "Python bindings of libSVM")))

(define-public ghmm
  ;; The latest release candidate is several years and a couple of fixes have
  ;; been published since.  This is why we download the sources from the SVN
  ;; repository.
  (let ((svn-revision 2341))
    (package
      (name "ghmm")
      (version (string-append "0.9-rc3-0." (number->string svn-revision)))
      (source (origin
                (method svn-fetch)
                (uri (svn-reference
                      (url "http://svn.code.sf.net/p/ghmm/code/trunk")
                      (revision svn-revision)))
                (file-name (string-append name "-" version "-checkout"))
                (sha256
                 (base32
                  "0qbq1rqp94l530f043qzp8aw5lj7dng9wq0miffd7spd1ff638wq"))))
      (build-system gnu-build-system)
      (arguments
       `(#:imported-modules (,@%gnu-build-system-modules
                             (guix build python-build-system))
         #:modules          ((guix build python-build-system)
                             ,@%gnu-build-system-modules)
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'enter-dir
             (lambda _ (chdir "ghmm") #t))
           (delete 'check)
           (add-after 'install 'check
             (assoc-ref %standard-phases 'check))
           (add-before 'check 'fix-PYTHONPATH
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let ((python-version (python-version
                                      (assoc-ref inputs "python"))))
                 (setenv "PYTHONPATH"
                         (string-append (getenv "PYTHONPATH")
                                        ":" (assoc-ref outputs "out")
                                        "/lib/python" python-version
                                        "/site-packages")))
               #t))
           (add-after 'enter-dir 'fix-runpath
             (lambda* (#:key outputs #:allow-other-keys)
               (substitute* "ghmmwrapper/setup.py"
                 (("^(.*)extra_compile_args = \\[" line indent)
                  (string-append indent
                                 "extra_link_args = [\"-Wl,-rpath="
                                 (assoc-ref outputs "out") "/lib\"],\n"
                                 line
                                 "\"-Wl,-rpath="
                                 (assoc-ref outputs "out")
                                 "/lib\", ")))
               #t))
           (add-after 'enter-dir 'disable-broken-tests
             (lambda _
               (substitute* "tests/Makefile.am"
                 ;; GHMM_SILENT_TESTS is assumed to be a command.
                 (("TESTS_ENVIRONMENT.*") "")
                 ;; Do not build broken tests.
                 (("chmm .*") "")
                 (("read_fa .*") "")
                 (("mcmc .*") "")
                 (("label_higher_order_test.*$")
                  "label_higher_order_test\n"))

               ;; These Python unittests are broken as there is no gato.
               ;; See https://sourceforge.net/p/ghmm/support-requests/3/
               (substitute* "ghmmwrapper/ghmmunittests.py"
                 (("^(.*)def (testNewXML|testMultipleTransitionClasses|testNewXML)"
                   line indent)
                  (string-append indent
                                 "@unittest.skip(\"Disabled by Guix\")\n"
                                 line)))
               #t)))))
      (inputs
       `(("python" ,python-2) ; only Python 2 is supported
         ("libxml2" ,libxml2)))
      (native-inputs
       `(("pkg-config" ,pkg-config)
         ("dejagnu" ,dejagnu)
         ("swig" ,swig)
         ("autoconf" ,autoconf)
         ("automake" ,automake)
         ("libtool" ,libtool)))
      (home-page "http://ghmm.org")
      (synopsis "Hidden Markov Model library")
      (description
       "The General Hidden Markov Model library (GHMM) is a C library with
additional Python bindings implementing a wide range of types of @dfn{Hidden
Markov Models} (HMM) and algorithms: discrete, continuous emissions, basic
training, HMM clustering, HMM mixtures.")
      (license license:lgpl2.0+))))

(define-public mcl
  (package
    (name "mcl")
    (version "14.137")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "http://micans.org/mcl/src/mcl-"
                    (string-replace-substring version "." "-")
                    ".tar.gz"))
              (sha256
               (base32
                "15xlax3z31lsn62vlg94hkm75nm40q4679amnfg13jm8m2bnhy5m"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags (list "--enable-blast")))
    (inputs
     `(("perl" ,perl)))
    (home-page "http://micans.org/mcl/")
    (synopsis "Clustering algorithm for graphs")
    (description
     "The MCL algorithm is short for the @dfn{Markov Cluster Algorithm}, a
fast and scalable unsupervised cluster algorithm for graphs (also known as
networks) based on simulation of (stochastic) flow in graphs.")
    ;; In the LICENCE file and web page it says "The software is licensed
    ;; under the GNU General Public License, version 3.", but in several of
    ;; the source code files it suggests GPL3 or later.
    ;; http://listserver.ebi.ac.uk/pipermail/mcl-users/2016/000376.html
    (license license:gpl3)))

(define-public ocaml-mcl
  (package
    (name "ocaml-mcl")
    (version "12-068oasis4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fhcrc/mcl")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0009dc3h2jp3qg5val452wngpqnbfyhbcxylghq0mrjqxx0jdq5p"))))
    (build-system ocaml-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-before 'configure 'patch-paths
           (lambda _
             (substitute* "setup.ml"
               (("LDFLAGS=-fPIC")
                (string-append "LDFLAGS=-fPIC\"; \"SHELL=" (which "sh")))
               (("-std=c89") "-std=gnu99")

               ;; This is a mutable string, which is no longer supported.  Use
               ;; a byte buffer instead.
               (("String.make \\(String.length s\\)")
                "Bytes.make (String.length s)")

               ;; These two belong together.
               (("OASISString.replace_chars")
                "Bytes.to_string (OASISString.replace_chars")
               ((" s;")
                " s);"))
             (substitute* "myocamlbuild.ml"
               (("std=c89") "std=gnu99"))
             ;; Since we build with a more recent OCaml, we have to use C99 or
             ;; later.  This causes problems with the old C code.
             (substitute* "src/impala/matrix.c"
               (("restrict") "restrict_"))
             #t)))))
    (native-inputs
     `(("ocamlbuild" ,ocamlbuild)))
    (home-page "https://github.com/fhcrc/mcl")
    (synopsis "OCaml wrappers around MCL")
    (description
     "This package provides OCaml bindings for the MCL graph clustering
algorithm.")
    (license license:gpl3)))

(define-public randomjungle
  (package
    (name "randomjungle")
    (version "2.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://www.imbs.uni-luebeck.de/fileadmin/files/Software"
             "/randomjungle/randomjungle-" version ".tar_.gz"))
       (patches (search-patches "randomjungle-disable-static-build.patch"))
       (sha256
        (base32
         "12c8rf30cla71swx2mf4ww9mfd8jbdw5lnxd7dxhyw1ygrvg6y4w"))))
    (build-system gnu-build-system)
    (arguments
     `(#:configure-flags
       (list "--disable-static"
             (string-append "--with-boost="
                            (assoc-ref %build-inputs "boost")))
       #:phases
       (modify-phases %standard-phases
         (add-before
          'configure 'set-CXXFLAGS
          (lambda _
            (setenv "CXXFLAGS" "-fpermissive ")
            #t)))))
    (inputs
     `(("boost" ,boost)
       ("gsl" ,gsl)
       ("libxml2" ,libxml2)
       ("zlib" ,zlib)))
    (native-inputs
     `(("gfortran" ,gfortran)
       ("gfortran:lib" ,gfortran "lib")))
    ;; Non-portable assembly instructions are used so building fails on
    ;; platforms other than x86_64 or i686.
    (supported-systems '("x86_64-linux" "i686-linux"))
    (home-page "https://www.imbs.uni-luebeck.de/forschung/software/details.html#c224")
    (synopsis "Implementation of the Random Forests machine learning method")
    (description
     "Random Jungle is an implementation of Random Forests.  It is supposed to
analyse high dimensional data.  In genetics, it can be used for analysing big
Genome Wide Association (GWA) data.  Random Forests is a powerful machine
learning method.  Most interesting features are variable selection, missing
value imputation, classifier creation, generalization error estimation and
sample proximities between pairs of cases.")
    (license license:gpl3+)))

(define-public openfst
  (package
    (name "openfst")
    (version "1.7.9")
    (source (origin
              (method url-fetch)
              (uri (string-append "http://www.openfst.org/twiki/pub/FST/"
                                  "FstDownload/openfst-" version ".tar.gz"))
              (sha256
               (base32
                "1pmx1yhn2gknj0an0zwqmzgwjaycapi896244np50a8y3nrsw6ck"))))
    (build-system gnu-build-system)
    (home-page "http://www.openfst.org")
    (synopsis "Library for weighted finite-state transducers")
    (description "OpenFst is a library for constructing, combining,
optimizing, and searching weighted finite-state transducers (FSTs).")
    (license license:asl2.0)))

(define-public shogun
  (package
    (name "shogun")
    (version "6.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "ftp://shogun-toolbox.org/shogun/releases/"
             (version-major+minor version)
             "/sources/shogun-" version ".tar.bz2"))
       (sha256
        (base32
         "1rn9skm3nw6hr7mr3lgp2gfqhi7ii0lyxck7qmqnf8avq349s5jp"))
       (modules '((guix build utils)
                  (ice-9 rdelim)))
       (snippet
        '(begin
           ;; Remove non-free sources and files referencing them
           (for-each delete-file
                     (find-files "src/shogun/classifier/svm/"
                                 "SVMLight\\.(cpp|h)"))
           (for-each delete-file
                     (find-files "examples/undocumented/libshogun/"
                                 (string-append
                                  "(classifier_.*svmlight.*|"
                                  "evaluation_cross_validation_locked_comparison).cpp")))
           ;; Remove non-free functions.
           (define (delete-ifdefs file)
             (with-atomic-file-replacement file
               (lambda (in out)
                 (let loop ((line (read-line in 'concat))
                            (skipping? #f))
                   (if (eof-object? line)
                       #t
                       (let ((skip-next?
                              (or (and skipping?
                                       (not (string-prefix?
                                             "#endif //USE_SVMLIGHT" line)))
                                  (string-prefix?
                                   "#ifdef USE_SVMLIGHT" line))))
                         (when (or (not skipping?)
                                   (and skipping? (not skip-next?)))
                           (display line out))
                         (loop (read-line in 'concat) skip-next?)))))))
           (for-each delete-ifdefs
                     (append
                      (find-files "src/shogun/classifier/mkl"
                                  "^MKLClassification\\.cpp")
                      (find-files "src/shogun/classifier/svm"
                                  "^SVMLightOneClass\\.(cpp|h)")
                      (find-files "src/shogun/multiclass"
                                  "^ScatterSVM\\.(cpp|h)")
                      (find-files "src/shogun/kernel/"
                                  "^(Kernel|CombinedKernel|ProductKernel)\\.(cpp|h)")
                      (find-files "src/shogun/regression/svr"
                                  "^(MKLRegression|SVRLight)\\.(cpp|h)")
                      (find-files "src/shogun/transfer/domain_adaptation"
                                  "^DomainAdaptationSVM\\.(cpp|h)")))
           #t))))
    (build-system cmake-build-system)
    (arguments
     '(#:tests? #f ;no check target
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'delete-broken-symlinks
           (lambda _
             (for-each delete-file '("applications/arts/data"
                                     "applications/asp/data"
                                     "applications/easysvm/data"
                                     "applications/msplicer/data"
                                     "applications/ocr/data"
                                     "examples/meta/data"
                                     "examples/undocumented/data"))
             #t))
         (add-after 'unpack 'change-R-target-path
           (lambda* (#:key outputs #:allow-other-keys)
             (substitute* '("src/interfaces/r/CMakeLists.txt"
                            "examples/meta/r/CMakeLists.txt")
               (("\\$\\{R_COMPONENT_LIB_PATH\\}")
                (string-append (assoc-ref outputs "out")
                               "/lib/R/library/")))
             #t))
         (add-after 'unpack 'fix-octave-modules
           (lambda* (#:key outputs #:allow-other-keys)
             (substitute* "src/interfaces/octave/CMakeLists.txt"
               (("^include_directories\\(\\$\\{OCTAVE_INCLUDE_DIRS\\}")
                "include_directories(${OCTAVE_INCLUDE_DIRS} ${OCTAVE_INCLUDE_DIRS}/octave")
               ;; change target directory
               (("\\$\\{OCTAVE_OCT_LOCAL_API_FILE_DIR\\}")
                (string-append (assoc-ref outputs "out")
                               "/share/octave/packages")))
             (substitute* '("src/interfaces/octave/swig_typemaps.i"
                            "src/interfaces/octave/sg_print_functions.cpp")
               ;; "octave/config.h" and "octave/oct-obj.h" deprecated in Octave.
               (("octave/config\\.h") "octave/octave-config.h")
               (("octave/oct-obj.h") "octave/ovl.h"))
             #t))
         (add-after 'unpack 'move-rxcpp
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((rxcpp-dir "shogun/third-party/rxcpp"))
               (mkdir-p rxcpp-dir)
               (install-file (assoc-ref inputs "rxcpp") rxcpp-dir)
               #t)))
         (add-before 'build 'set-HOME
           ;; $HOME needs to be set at some point during the build phase
           (lambda _ (setenv "HOME" "/tmp") #t)))
       #:configure-flags
       (list "-DCMAKE_BUILD_WITH_INSTALL_RPATH=TRUE"
             "-DUSE_SVMLIGHT=OFF" ;disable proprietary SVMLIGHT
             "-DBUILD_META_EXAMPLES=OFF" ;requires unpackaged ctags
             ;;"-DINTERFACE_JAVA=ON" ;requires unpackaged jblas
             ;;"-DINTERFACE_RUBY=ON" ;requires unpackaged ruby-narray
             ;;"-DINTERFACE_PERL=ON" ;"FindPerlLibs" does not exist
             ;;"-DINTERFACE_LUA=ON"  ;fails because lua doesn't build pkgconfig file
             "-DINTERFACE_OCTAVE=ON"
             "-DINTERFACE_PYTHON=ON"
             "-DINTERFACE_R=ON")))
    (inputs
     `(("python" ,python)
       ("numpy" ,python-numpy)
       ("r-minimal" ,r-minimal)
       ("octave" ,octave-cli)
       ("swig" ,swig)
       ("eigen" ,eigen)
       ("hdf5" ,hdf5)
       ("atlas" ,atlas)
       ("arpack" ,arpack-ng)
       ("lapack" ,lapack)
       ("glpk" ,glpk)
       ("libxml2" ,libxml2)
       ("lzo" ,lzo)
       ("zlib" ,zlib)))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("rxcpp" ,rxcpp)))
    ;; Non-portable SSE instructions are used so building fails on platforms
    ;; other than x86_64.
    (supported-systems '("x86_64-linux"))
    (home-page "https://shogun-toolbox.org/")
    (synopsis "Machine learning toolbox")
    (description
     "The Shogun Machine learning toolbox provides a wide range of unified and
efficient Machine Learning (ML) methods.  The toolbox seamlessly
combines multiple data representations, algorithm classes, and general purpose
tools.  This enables both rapid prototyping of data pipelines and extensibility
in terms of new algorithms.")
    (license license:gpl3+)))

(define-public onnx
  (package
    (name "onnx")
    (version "1.9.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/onnx/onnx")
                    (commit (string-append "v" version))))
              (sha256
               (base32
                "1xnii361f68x0masxgfc4ai7hh3wlxxk56aznwf4m4yr6wqx47ml"))
              (file-name (git-file-name name version))
              (patches (search-patches "onnx-use-system-googletest.patch"
                                       "onnx-shared-libraries.patch"
                                       "onnx-skip-model-downloads.patch"))
              (modules '((guix build utils)))
              (snippet '(delete-file-recursively "third_party"))))
    (build-system python-build-system)
    (arguments
     '(#:phases (modify-phases %standard-phases
                  (add-before 'build 'pass-cmake-arguments
                    (lambda* (#:key outputs #:allow-other-keys)
                      ;; Pass options to the CMake-based build process.
                      (define out
                        (assoc-ref outputs "out"))

                      (define args
                        ;; Copy arguments from 'cmake-build-system', plus ask
                        ;; for shared libraries.
                        (list "-DCMAKE_BUILD_TYPE=RelWithDebInfo"
                              (string-append "-DCMAKE_INSTALL_PREFIX=" out)
                              "-DCMAKE_INSTALL_LIBDIR=lib"
                              "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=TRUE"
                              (string-append "-DCMAKE_INSTALL_RPATH=" out
                                             "/lib")
                              "-DCMAKE_VERBOSE_MAKEFILE=ON"

                              "-DBUILD_SHARED_LIBS=ON"))

                      ;; This environment variable is honored by 'setup.py',
                      ;; which passes it down to 'cmake'.
                      (setenv "CMAKE_ARGS" (string-join args))

                      ;; This one is honored by 'setup.py' and passed to 'make
                      ;; -j'.
                      (setenv "MAX_JOBS"
                              (number->string (parallel-job-count)))))
                  (add-before 'check 'make-test-directory-writable
                    (lambda _
                      ;; Make things writable for tests.
                      (setenv "HOME" (getcwd))
                      (for-each make-file-writable
                                (find-files "onnx/examples" "."
                                            #:directories? #t))))
                  (add-after 'install 'install-from-cmake
                    (lambda _
                      ;; Run "make install" in the build tree 'setup.py'
                      ;; created for CMake so that libonnx.so,
                      ;; libonnx_proto.so, etc. are installed.
                      (invoke "make" "install"
                              "-C" ".setuptools-cmake-build"))))))
    (native-inputs
     `(("cmake" ,cmake)
       ("googletest" ,googletest)
       ("pybind11" ,pybind11)
       ("python-coverage" ,python-coverage)
       ("python-nbval" ,python-nbval)
       ("python-pytest" ,python-pytest)
       ("python-pytest-runner" ,python-pytest-runner)))
    (inputs
     `(("protobuf" ,protobuf)))
    (propagated-inputs
     `(("python-numpy" ,python-numpy)
       ("python-protobuf" ,python-protobuf)
       ("python-six" ,python-six)
       ("python-tabulate" ,python-tabulate)
       ("python-typing-extensions"
        ,python-typing-extensions)))
    (home-page "https://onnx.ai/")
    (synopsis "Open Neural Network Exchange")
    (description
     "Open Neural Network Exchange (ONNX) provides an open source format for
AI models, both deep learning and traditional ML.  It defines an extensible
computation graph model, as well as definitions of built-in operators and
standard data types.")
    (license license:expat)))

(define-public python-onnx
  ;; This used to be called "python-onnx" because it provided nothing but
  ;; Python bindings.  The package now provides shared libraries and C++
  ;; headers, hence the name change.
  (deprecated-package "python-onnx" onnx))

(define-public rxcpp
  (package
    (name "rxcpp")
    (version "4.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ReactiveX/RxCpp")
             (commit (string-append "v" version))))
       (sha256
        (base32 "1rdpa3jlc181jd08nk437aar085h28i45s6nzrv65apb3xyyz0ij"))
       (file-name (git-file-name name version))))
    (build-system cmake-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'remove-werror
           (lambda _
             (substitute* (find-files ".")
               (("-Werror") ""))
             #t))
         (replace 'check
           (lambda _
             (invoke "ctest"))))))
    (native-inputs
     `(("catch" ,catch-framework)))
    (home-page "http://reactivex.io/")
    (synopsis "Reactive Extensions for C++")
    (description
     "The Reactive Extensions for C++ (RxCpp) is a library of algorithms for
values-distributed-in-time.  ReactiveX is a library for composing asynchronous
and event-based programs by using observable sequences.

It extends the observer pattern to support sequences of data and/or events and
adds operators that allow you to compose sequences together declaratively while
abstracting away concerns about things like low-level threading,
synchronization, thread-safety, concurrent data structures, and non-blocking
I/O.")
    (license license:asl2.0)))

(define-public gemmlowp-for-tensorflow
  ;; The commit hash is taken from "tensorflow/workspace.bzl".
  (let ((commit "38ebac7b059e84692f53e5938f97a9943c120d98")
        (revision "2"))
    (package
      (name "gemmlowp")
      (version (git-version "0" revision commit))
      (source (origin
                (method url-fetch)
                (uri (string-append "https://mirror.bazel.build/"
                                    "github.com/google/gemmlowp/archive/"
                                    commit ".zip"))
                (file-name (string-append "gemmlowp-" version ".zip"))
                (sha256
                 (base32
                  "0n56s2g8hrssm4w8qj1v58gfm56a04n9v992ixkmvk6zjiralzxq"))))
      (build-system cmake-build-system)
      (arguments
       `(#:configure-flags
         (list ,@(match (%current-system)
                   ((or "x86_64-linux" "i686-linux")
                    '("-DCMAKE_CXX_FLAGS=-msse2"))
                   (_ '())))
         #:phases
         (modify-phases %standard-phases
           ;; This directory contains the CMakeLists.txt.
           (add-after 'unpack 'chdir
             (lambda _ (chdir "contrib") #t))
           ;; There is no install target
           (replace 'install
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (lib (string-append out "/lib/"))
                      (inc (string-append out "/include/")))
                 (install-file "../build/libeight_bit_int_gemm.so" lib)
                 (for-each (lambda (dir)
                             (let ((target (string-append inc "/" dir)))
                               (mkdir-p target)
                               (for-each (lambda (h)
                                           (install-file h target))
                                         (find-files (string-append "../" dir)
                                                     "\\.h$"))))
                           '("meta" "profiling" "public" "fixedpoint"
                             "eight_bit_int_gemm" "internal"))
                 #t))))))
      (native-inputs
       `(("unzip" ,unzip)))
      (home-page "https://github.com/google/gemmlowp")
      (synopsis "Small self-contained low-precision GEMM library")
      (description
       "This is a small self-contained low-precision @dfn{general matrix
multiplication} (GEMM) library.  It is not a full linear algebra library.
Low-precision means that the input and output matrix entries are integers on
at most 8 bits.  To avoid overflow, results are internally accumulated on more
than 8 bits, and at the end only some significant 8 bits are kept.")
      (license license:asl2.0))))

(define-public dlib
  (package
    (name "dlib")
    (version "19.20")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "http://dlib.net/files/dlib-" version ".tar.bz2"))
              (sha256
               (base32
                "139jyi19qz37wwmmy48gil9d1kkh2r3w3bwdzabha6ayxmba96nz"))
              (modules '((guix build utils)))
              (snippet
               '(begin
                  ;; Delete ~13MB of bundled dependencies.
                  (delete-file-recursively "dlib/external")
                  (delete-file-recursively "docs/dlib/external")
                  #t))))
    (build-system cmake-build-system)
    (arguments
     `(#:configure-flags '("-DBUILD_SHARED_LIBS=ON")
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'disable-asserts
           (lambda _
             ;; config.h recommends explicitly enabling or disabling asserts
             ;; when building as a shared library. By default neither is set.
             (substitute* "dlib/config.h"
               (("^//#define DLIB_DISABLE_ASSERTS") "#define DLIB_DISABLE_ASSERTS"))
             #t))
         (add-after 'disable-asserts 'disable-failing-tests
           (lambda _
             ;; One test times out on MIPS, so we need to disable it.
             ;; Others are flaky on some platforms.
             (let* ((system ,(or (%current-target-system)
                                 (%current-system)))
                    (disabled-tests (cond
                                     ((string-prefix? "mips64" system)
                                      '("object_detector" ; timeout
                                        "data_io"))
                                     ((string-prefix? "armhf" system)
                                      '("learning_to_track"))
                                     ((string-prefix? "i686" system)
                                      '("optimization"))
                                     (else '()))))
               (for-each
                (lambda (test)
                  (substitute* "dlib/test/makefile"
                    (((string-append "SRC \\+= " test "\\.cpp")) "")))
                disabled-tests)
               #t)))
         (replace 'check
           (lambda _
             ;; No test target, so we build and run the unit tests here.
             (let ((test-dir (string-append "../dlib-" ,version "/dlib/test")))
               (with-directory-excursion test-dir
                 (invoke "make" "-j" (number->string (parallel-job-count)))
                 (invoke "./dtest" "--runall"))
               #t))))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ;; For tests.
       ("libnsl" ,libnsl)))
    (inputs
     `(("giflib" ,giflib)
       ("lapack" ,lapack)
       ("libjpeg" ,libjpeg-turbo)
       ("libpng" ,libpng)
       ("libx11" ,libx11)
       ("openblas" ,openblas)
       ("zlib" ,zlib)))
    (synopsis
     "Toolkit for making machine learning and data analysis applications in C++")
    (description
     "Dlib is a modern C++ toolkit containing machine learning algorithms and
tools.  It is used in both industry and academia in a wide range of domains
including robotics, embedded devices, mobile phones, and large high performance
computing environments.")
    (home-page "http://dlib.net")
    (license license:boost1.0)))

(define-public python-scikit-learn
  (package
    (name "python-scikit-learn")
    (version "0.24.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/scikit-learn/scikit-learn")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0dd854hi9h81pa3y6gwa6r4qjwrwq5fndi312h6dkqzfh7jbvgvd"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'build 'build-ext
           (lambda _ (invoke "python" "setup.py" "build_ext" "--inplace") #t))
         (replace 'check
           (lambda _
             ;; Restrict OpenBLAS threads to prevent segfaults while testing!
             (setenv "OPENBLAS_NUM_THREADS" "1")

             ;; Some tests require write access to $HOME.
             (setenv "HOME" "/tmp")

             (invoke "pytest" "sklearn" "-m" "not network")))
         (add-before 'reset-gzip-timestamps 'make-files-writable
           (lambda* (#:key outputs #:allow-other-keys)
             ;; Make sure .gz files are writable so that the
             ;; 'reset-gzip-timestamps' phase can do its work.
             (let ((out (assoc-ref outputs "out")))
               (for-each make-file-writable
                         (find-files out "\\.gz$"))
               #t))))))
    (inputs
     `(("openblas" ,openblas)))
    (native-inputs
     `(("python-pytest" ,python-pytest)
       ("python-pandas" ,python-pandas) ;for tests
       ("python-cython" ,python-cython)))
    (propagated-inputs
     `(("python-numpy" ,python-numpy)
       ("python-threadpoolctl" ,python-threadpoolctl)
       ("python-scipy" ,python-scipy)
       ("python-joblib" ,python-joblib)))
    (home-page "https://scikit-learn.org/")
    (synopsis "Machine Learning in Python")
    (description
     "Scikit-learn provides simple and efficient tools for data mining and
data analysis.")
    (properties `((python2-variant . ,(delay python2-scikit-learn))))
    (license license:bsd-3)))

;; scikit-learn 0.22 and later only supports Python 3, so we stick with
;; an older version here.
(define-public python2-scikit-learn
  (let ((base (package-with-python2 (strip-python2-variant python-scikit-learn))))
    (package
      (inherit base)
      (version "0.20.4")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/scikit-learn/scikit-learn")
                      (commit version)))
                (file-name (git-file-name "python-scikit-learn" version))
                (sha256
                 (base32
                  "08zbzi8yx5wdlxfx9jap61vg1malc9ajf576w7a0liv6jvvrxlpj"))))
      (inputs
       `(("openblas" ,openblas)))
      (native-inputs
       `(("python2-pytest" ,python2-pytest)
         ("python2-pandas" ,python2-pandas) ;for tests
         ("python2-cython" ,python2-cython)))
      (propagated-inputs
       `(("python2-numpy" ,python2-numpy)
         ("python2-scipy" ,python2-scipy)
         ("python2-joblib" ,python2-joblib))))))

(define-public python-threadpoolctl
  (package
    (name "python-threadpoolctl")
    (version "2.1.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "threadpoolctl" version))
        (sha256
         (base32
          "0szsxcm2fbxrn83iynn42bnvrdh7mfsmkhfn8pdn7swblfb7rifx"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda* (#:key tests? inputs outputs #:allow-other-keys)
             (when tests?
               (add-installed-pythonpath inputs outputs)
               (invoke "pytest"))
             #t)))))
    (native-inputs
     `(("python-pytest" ,python-pytest)))
    (home-page "https://github.com/joblib/threadpoolctl")
    (synopsis "Python helpers for common threading libraries")
    (description "Thread-pool Controls provides Python helpers to limit the
number of threads used in the threadpool-backed of common native libraries used
for scientific computing and data science (e.g. BLAS and OpenMP).")
    (license license:bsd-3)))

(define-public python-pynndescent
  (package
    (name "python-pynndescent")
    (version "0.5.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pynndescent" version))
       (sha256
        (base32 "0w87c2v0li2rdbx6qfc2lb6y6bxpdy3jwfgzfs1kcr4d1chj5zfr"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-nose" ,python-nose)))
    (propagated-inputs
     `(("python-joblib" ,python-joblib)
       ("python-llvmlite" ,python-llvmlite)
       ("python-numba" ,python-numba)
       ("python-scikit-learn" ,python-scikit-learn)
       ("python-scipy" ,python-scipy)))
    (home-page "https://github.com/lmcinnes/pynndescent")
    (synopsis "Nearest neighbor descent for approximate nearest neighbors")
    (description
     "PyNNDescent provides a Python implementation of Nearest Neighbor Descent
for k-neighbor-graph construction and approximate nearest neighbor search.")
    (license license:bsd-2)))

(define-public python-opentsne
  (package
    (name "python-opentsne")
    (version "0.5.2")
    (source
     (origin
       ;; No tests in the PyPI tarball.
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pavlin-policar/openTSNE")
             (commit (string-append "v" version))))
       (file-name (string-append name "-" version "-checkout"))
       (sha256
        (base32 "1hl42wmafydk4fxdx05l180k3canmqw8h9r20fsqq2aq440b09gh"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         ;; Benchmarks require the 'macosko2015' data files.
         (add-after 'unpack 'delete-benchmark
           (lambda _
             (delete-file-recursively "benchmarks")
             #t))
         ;; Numba needs a writable dir to cache functions.
         (add-before 'check 'set-numba-cache-dir
           (lambda _
             (setenv "NUMBA_CACHE_DIR" "/tmp")
             #t)))))
    (native-inputs
     `(("python-cython" ,python-cython)))
    (inputs
     `(("fftw" ,fftw)))
    (propagated-inputs
     `(("python-numpy" ,python-numpy)
       ("python-pynndescent" ,python-pynndescent)
       ("python-scikit-learn" ,python-scikit-learn)
       ("python-scipy" ,python-scipy)))
    (home-page "https://github.com/pavlin-policar/openTSNE")
    (synopsis "Extensible, parallel implementations of t-SNE")
    (description
     "This is a modular Python implementation of t-Distributed Stochastic
Neighbor Embedding (t-SNE), a popular dimensionality-reduction algorithm for
visualizing high-dimensional data sets.")
    (license license:bsd-3)))

(define-public python-scikit-rebate
  (package
    (name "python-scikit-rebate")
    (version "0.6")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "skrebate" version))
              (sha256
               (base32
                "1h7qs9gjxpzqabzhb8rmpv3jpmi5iq41kqdibg48299h94iikiw7"))))
    (build-system python-build-system)
    ;; Pandas is only needed to run the tests.
    (native-inputs
     `(("python-pandas" ,python-pandas)))
    (propagated-inputs
     `(("python-numpy" ,python-numpy)
       ("python-scipy" ,python-scipy)
       ("python-scikit-learn" ,python-scikit-learn)
       ("python-joblib" ,python-joblib)))
    (home-page "https://epistasislab.github.io/scikit-rebate/")
    (synopsis "Relief-based feature selection algorithms for Python")
    (description "Scikit-rebate is a scikit-learn-compatible Python
implementation of ReBATE, a suite of Relief-based feature selection algorithms
for Machine Learning.  These algorithms excel at identifying features that are
predictive of the outcome in supervised learning problems, and are especially
good at identifying feature interactions that are normally overlooked by
standard feature selection algorithms.")
    (license license:expat)))

(define-public python-cmaes
  (package
    (name "python-cmaes")
    (version "0.8.2")
    (source
     (origin
       (method git-fetch) ;no tests in PyPI
       (uri (git-reference
             (url "https://github.com/CyberAgent/cmaes")
             (commit (string-append "v" version))))
       (sha256
        (base32 "1jyckaifir528dz6m95nvky8hvqmz5gz6dlp65baahhbca0danzb"))
       (file-name (git-file-name name version))))
    (build-system python-build-system)
    (native-inputs
     `(("python-setuptools" ,python-setuptools) ;build fails without this
       ("python-wheel" ,python-wheel)))
    (propagated-inputs
     `(("python-numpy" ,python-numpy)))
    (home-page "https://github.com/CyberAgent/cmaes")
    (synopsis "CMA-ES implementation for Python")
    (description "This package provides provides an implementation of the
Covariance Matrix Adaptation Evolution Strategy (CMA-ES) for Python.")
    (license license:expat)))

(define-public python-autograd
  (let* ((commit "442205dfefe407beffb33550846434baa90c4de7")
         (revision "0")
         (version (git-version "0.0.0" revision commit)))
    (package
      (name "python-autograd")
      (home-page "https://github.com/HIPS/autograd")
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url home-page)
                      (commit commit)))
                (sha256
                 (base32
                  "189sv2xb0mwnjawa9z7mrgdglc1miaq93pnck26r28fi1jdwg0z4"))
                (file-name (git-file-name name version))))
      (version version)
      (build-system python-build-system)
      (native-inputs
       `(("python-nose" ,python-nose)
         ("python-pytest" ,python-pytest)))
      (propagated-inputs
       `(("python-future" ,python-future)
         ("python-numpy" ,python-numpy)))
      (arguments
       `(#:phases (modify-phases %standard-phases
                    (replace 'check
                      (lambda _
                        (invoke "py.test" "-v"))))))
      (synopsis "Efficiently computes derivatives of NumPy code")
      (description "Autograd can automatically differentiate native Python and
NumPy code.  It can handle a large subset of Python's features, including loops,
ifs, recursion and closures, and it can even take derivatives of derivatives
of derivatives.  It supports reverse-mode differentiation
(a.k.a. backpropagation), which means it can efficiently take gradients of
scalar-valued functions with respect to array-valued arguments, as well as
forward-mode differentiation, and the two can be composed arbitrarily.  The
main intended application of Autograd is gradient-based optimization.")
      (license license:expat))))

(define-public python2-autograd
  (package-with-python2 python-autograd))

(define-public lightgbm
  (package
    (name "lightgbm")
    (version "2.0.12")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/Microsoft/LightGBM")
                     (commit (string-append "v" version))))
              (sha256
               (base32
                "0jlvyn7k81dzrh9ij3zw576wbgiwmmr26rzpdxjn1dbpc3njpvzi"))
              (file-name (git-file-name name version))))
    (native-inputs
     `(("python-pytest" ,python-pytest)
       ("python-nose" ,python-nose)))
    (inputs
     `(("openmpi" ,openmpi)))
    (propagated-inputs
     `(("python-numpy" ,python-numpy)
       ("python-scipy" ,python-scipy)))
    (arguments
     `(#:configure-flags
       '("-DUSE_MPI=ON")
       #:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda _
             (with-directory-excursion "../source"
               (invoke "pytest" "tests/c_api_test/test_.py")))))))
    (build-system cmake-build-system)
    (home-page "https://github.com/Microsoft/LightGBM")
    (synopsis "Gradient boosting framework based on decision tree algorithms")
    (description "LightGBM is a gradient boosting framework that uses tree
based learning algorithms.  It is designed to be distributed and efficient with
the following advantages:

@itemize
@item Faster training speed and higher efficiency
@item Lower memory usage
@item Better accuracy
@item Parallel and GPU learning supported (not enabled in this package)
@item Capable of handling large-scale data
@end itemize\n")
    (license license:expat)))

(define-public vowpal-wabbit
  ;; Language bindings not included.
  (package
    (name "vowpal-wabbit")
    (version "8.5.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/JohnLangford/vowpal_wabbit")
                     (commit version)))
              (sha256
               (base32
                "04bwzk6ifgnz3fmzid8b7avxf9n5pnx9xcjm61nkjng1vv0bpj8x"))
              (file-name (git-file-name name version))))
    (inputs
     `(("boost" ,boost)
       ("zlib" ,zlib)))
    (arguments
     `(#:configure-flags
       (list (string-append "--with-boost="
                            (assoc-ref %build-inputs "boost")))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'make-files-writable
           (lambda _
             (for-each make-file-writable (find-files "." ".*")) #t))
         (add-after 'install 'install-more-headers
           (lambda* (#:key outputs #:allow-other-keys)
             (for-each
               (lambda (file)
                 (install-file file (string-append
                                      (assoc-ref outputs "out")
                                      "/include/vowpalwabbit")))
               (find-files "vowpalwabbit" "\\.h$"))
             #t)))))
    (build-system gnu-build-system)
    (home-page "https://github.com/JohnLangford/vowpal_wabbit")
    (synopsis "Fast machine learning library for online learning")
    (description "Vowpal Wabbit is a machine learning system with techniques
such as online, hashing, allreduce, reductions, learning2search, active, and
interactive learning.")
    (license license:bsd-3)))

(define-public python2-fastlmm
  (package
    (name "python2-fastlmm")
    (version "0.2.21")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "fastlmm" version ".zip"))
       (sha256
        (base32
         "1q8c34rpmwkfy3r4d5172pzdkpfryj561897z9r3x22gq7813x1m"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f ; some test files are missing
       #:python ,python-2)) ; only Python 2.7 is supported
    (propagated-inputs
     `(("python2-numpy" ,python2-numpy)
       ("python2-scipy" ,python2-scipy)
       ("python2-matplotlib" ,python2-matplotlib)
       ("python2-pandas" ,python2-pandas)
       ("python2-scikit-learn" ,python2-scikit-learn)
       ("python2-pysnptools" ,python2-pysnptools)))
    (native-inputs
     `(("unzip" ,unzip)
       ("python2-cython" ,python2-cython)
       ("python2-mock" ,python2-mock)
       ("python2-nose" ,python2-nose)))
    (home-page "http://research.microsoft.com/en-us/um/redmond/projects/mscompbio/fastlmm/")
    (synopsis "Perform genome-wide association studies on large data sets")
    (description
     "FaST-LMM, which stands for Factored Spectrally Transformed Linear Mixed
Models, is a program for performing both single-SNP and SNP-set genome-wide
association studies (GWAS) on extremely large data sets.")
    (license license:asl2.0)))

(define-public python-hyperopt
  (package
    (name "python-hyperopt")
    (version "0.2.5")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "hyperopt" version))
       (sha256
        (base32 "1k4ma8ci0bxghw7g4ms944zak1pi83yv2d6bxd7fcslm1zalfq5w"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda* (#:key inputs outputs tests? #:allow-other-keys)
             (when tests?
               (add-installed-pythonpath inputs outputs)
               (invoke "python" "-m" "pytest" "--ignore"
                       ;; Needs python-pyspark.
                       "hyperopt/tests/test_spark.py"
                       ;; Needs both python-scikit-learn and python-lightgbm.
                       "--ignore" "hyperopt/tests/test_atpe_basic.py"
                       ;; The tests below need python-lightgbm.
                       "-k" (string-append "not test_branin"
                                           " and not test_distractor"
                                           " and not test_q1lognormal"
                                           " and not test_quadratic1"
                                           " and not test_twoarms"))))))))
    (propagated-inputs
     `(("python-cloudpickle" ,python-cloudpickle)
       ("python-future" ,python-future)
       ("python-networkx" ,python-networkx)
       ("python-numpy" ,python-numpy)
       ("python-scipy" ,python-scipy)
       ("python-six" ,python-six)
       ("python-tqdm" ,python-tqdm)))
    (native-inputs
     `(("python-black" ,python-black)
       ("python-ipython" ,python-ipython)
       ("python-ipyparallel" ,python-ipyparallel)
       ("python-nose" ,python-nose)
       ("python-pymongo" ,python-pymongo)
       ("python-pytest" ,python-pytest)))
    (home-page "https://hyperopt.github.io/hyperopt/")
    (synopsis "Library for hyperparameter optimization")
    (description "Hyperopt is a Python library for serial and parallel
optimization over awkward search spaces, which may include real-valued,
discrete, and conditional dimensions.")
    (license license:bsd-3)))

;; There have been no proper releases yet.
(define-public kaldi
  (let ((commit "d4791c0f3fc1a09c042dac365e120899ee2ad21e")
        (revision "2"))
    (package
      (name "kaldi")
      (version (git-version "0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/kaldi-asr/kaldi")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "07k80my6f19mhrkwbzhjsnpf9871wmrwkl0ym468i830w67qyjrz"))))
      (build-system gnu-build-system)
      (arguments
       `(#:test-target "test"
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'chdir
             (lambda _ (chdir "src") #t))
           (replace 'configure
             (lambda* (#:key build system inputs outputs #:allow-other-keys)
               (when (not (or (string-prefix? "x86_64" system)
                              (string-prefix? "i686" system)))
                 (substitute* "makefiles/linux_openblas.mk"
                   (("-msse -msse2") "")))
               (substitute* "makefiles/default_rules.mk"
                 (("/bin/bash") (which "bash")))
               (substitute* "Makefile"
                 (("ext_depend: check_portaudio")
                  "ext_depend:"))
               (substitute* '("online/Makefile"
                              "onlinebin/Makefile"
                              "gst-plugin/Makefile")
                 (("../../tools/portaudio/install")
                  (assoc-ref inputs "portaudio")))

               ;; This `configure' script doesn't support variables passed as
               ;; arguments, nor does it support "prefix".
               (let ((out (assoc-ref outputs "out"))
                     (openblas (assoc-ref inputs "openblas"))
                     (openfst (assoc-ref inputs "openfst")))
                 (substitute* "configure"
                   (("check_for_slow_expf;") "")
                   ;; This affects the RPATH and also serves as the installation
                   ;; directory.
                   (("KALDILIBDIR=`pwd`/lib")
                    (string-append "KALDILIBDIR=" out "/lib")))
                 (mkdir-p out) ; must exist
                 (setenv "CONFIG_SHELL" (which "bash"))
                 (setenv "OPENFST_VER" ,(package-version openfst))
                 (invoke "./configure"
                         "--use-cuda=no"
                         "--shared"
                         (string-append "--openblas-root=" openblas)
                         (string-append "--fst-root=" openfst)))))
           (add-after 'build 'build-ext-and-gstreamer-plugin
             (lambda _
               (invoke "make" "-C" "online" "depend")
               (invoke "make" "-C" "online")
               (invoke "make" "-C" "onlinebin" "depend")
               (invoke "make" "-C" "onlinebin")
               (invoke "make" "-C" "gst-plugin" "depend")
               (invoke "make" "-C" "gst-plugin")
               #t))
           ;; TODO: also install the executables.
           (replace 'install
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (inc (string-append out "/include"))
                      (lib (string-append out "/lib")))
                 (mkdir-p lib)
                 ;; The build phase installed symlinks to the actual
                 ;; libraries.  Install the actual targets.
                 (for-each (lambda (file)
                             (let ((target (readlink file)))
                               (delete-file file)
                               (install-file target lib)))
                           (find-files lib "\\.so"))
                 ;; Install headers
                 (for-each (lambda (file)
                             (let ((target-dir (string-append inc "/" (dirname file))))
                               (install-file file target-dir)))
                           (find-files "." "\\.h"))
                 (install-file "gst-plugin/libgstonlinegmmdecodefaster.so"
                               (string-append lib "/gstreamer-1.0"))
                 #t))))))
      (inputs
       `(("alsa-lib" ,alsa-lib)
         ("gfortran" ,gfortran "lib")
         ("glib" ,glib)
         ("gstreamer" ,gstreamer)
         ("jack" ,jack-1)
         ("openblas" ,openblas)
         ("openfst" ,openfst)
         ("portaudio" ,portaudio)
         ("python" ,python)))
      (native-inputs
       `(("glib" ,glib "bin")             ; glib-genmarshal
         ("grep" ,grep)
         ("sed" ,sed)
         ("pkg-config" ,pkg-config)
         ("which" ,which)))
      (home-page "https://kaldi-asr.org/")
      (synopsis "Speech recognition toolkit")
      (description "Kaldi is an extensible toolkit for speech recognition
written in C++.")
      (license license:asl2.0))))

(define-public gst-kaldi-nnet2-online
  (let ((commit "cb227ef43b66a9835c14eb0ad39e08ee03c210ad")
        (revision "2"))
    (package
      (name "gst-kaldi-nnet2-online")
      (version (git-version "0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/alumae/gst-kaldi-nnet2-online")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1i6ffwiavxx07ri0lxix6s8q0r31x7i4xxvhys5jxkixf5q34w8g"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f                    ; there are none
         #:make-flags
         (list (string-append "SHELL="
                              (assoc-ref %build-inputs "bash") "/bin/bash")
               (string-append "KALDI_ROOT="
                              (assoc-ref %build-inputs "kaldi-src"))
               (string-append "KALDILIBDIR="
                              (assoc-ref %build-inputs "kaldi") "/lib")
               "KALDI_FLAVOR=dynamic")
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'chdir
             (lambda _ (chdir "src") #t))
           (replace 'configure
             (lambda* (#:key inputs #:allow-other-keys)
               (let ((glib (assoc-ref inputs "glib")))
                 (setenv "CXXFLAGS" "-fPIC")
                 (setenv "CPLUS_INCLUDE_PATH"
                         (string-append glib "/include/glib-2.0:"
                                        glib "/lib/glib-2.0/include:"
                                        (assoc-ref inputs "gstreamer")
                                        "/include/gstreamer-1.0")))
               (substitute* "Makefile"
                 (("include \\$\\(KALDI_ROOT\\)/src/kaldi.mk") "")
                 (("\\$\\(error Cannot find") "#"))
               #t))
           (add-before 'build 'build-depend
             (lambda* (#:key make-flags #:allow-other-keys)
               (apply invoke "make" "depend" make-flags)))
           (replace 'install
             (lambda* (#:key outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (lib (string-append out "/lib/gstreamer-1.0")))
                 (install-file "libgstkaldinnet2onlinedecoder.so" lib)
                 #t))))))
      (inputs
       `(("glib" ,glib)
         ("gstreamer" ,gstreamer)
         ("jansson" ,jansson)
         ("openfst" ,openfst)
         ("kaldi" ,kaldi)))
      (native-inputs
       `(("bash" ,bash)
         ("glib:bin" ,glib "bin")       ; glib-genmarshal
         ("kaldi-src" ,(package-source kaldi))
         ("pkg-config" ,pkg-config)))
      (home-page "https://kaldi-asr.org/")
      (synopsis "Gstreamer plugin for decoding speech")
      (description "This package provides a GStreamer plugin that wraps
Kaldi's @code{SingleUtteranceNnet2Decoder}.  It requires iVector-adapted DNN
acoustic models.  The iVectors are adapted to the current audio stream
automatically.")
      (license license:asl2.0))))

(define-public kaldi-gstreamer-server
  ;; This is the tip of the py3 branch
  (let ((commit "f68cab490be7eb0da2af1475fbc16655f50a60cb")
        (revision "2"))
    (package
      (name "kaldi-gstreamer-server")
      (version (git-version "0" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/alumae/kaldi-gstreamer-server")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "17lh1368vkg8ngrcbn2phvigzlmalrqg6djx2gg61qq1a0nj87dm"))))
      (build-system gnu-build-system)
      (arguments
       `(#:tests? #f ; there are no tests that can be run automatically
         #:modules ((guix build utils)
                    (guix build gnu-build-system)
                    (srfi srfi-26))
         #:phases
         (modify-phases %standard-phases
           (delete 'configure)
           (replace 'build
             (lambda* (#:key outputs #:allow-other-keys)
               ;; Disable hash randomization to ensure the generated .pycs
               ;; are reproducible.
               (setenv "PYTHONHASHSEED" "0")
               (with-directory-excursion "kaldigstserver"
                 ;; See https://github.com/alumae/kaldi-gstreamer-server/issues/232
                 (substitute* "master_server.py"
                   (("\\.replace\\('\\\\.*") ")"))

                 ;; This is a Python 2 file
                 (delete-file "decoder_test.py")
                 (delete-file "test-buffer.py")

                 (for-each (lambda (file)
                             (apply invoke
                                    `("python"
                                      "-m" "compileall"
                                      "-f" ; force rebuild
                                      ,file)))
                           (find-files "." "\\.py$")))
               #t))
           (replace 'install
             (lambda* (#:key inputs outputs #:allow-other-keys)
               (let* ((out (assoc-ref outputs "out"))
                      (bin (string-append out "/bin"))
                      (share (string-append out "/share/kaldi-gstreamer-server/")))
                 ;; Install Python files
                 (with-directory-excursion "kaldigstserver"
                   (for-each (cut install-file <> share)
                             (find-files "." ".*")))

                 ;; Install sample configuration files
                 (for-each (cut install-file <> share)
                           (find-files "." "\\.yaml"))

                 ;; Install executables
                 (mkdir-p bin)
                 (let* ((server (string-append bin "/kaldi-gst-server"))
                        (client (string-append bin "/kaldi-gst-client"))
                        (worker (string-append bin "/kaldi-gst-worker"))
                        (PYTHONPATH (getenv "PYTHONPATH"))
                        (GST_PLUGIN_PATH (string-append
                                          (assoc-ref inputs "gst-kaldi-nnet2-online")
                                          "/lib/gstreamer-1.0:${GST_PLUGIN_PATH}"))
                        (wrap (lambda (wrapper what)
                                (with-output-to-file wrapper
                                  (lambda _
                                    (format #t
                                            "#!~a
export PYTHONPATH=~a
export GST_PLUGIN_PATH=~a
exec ~a ~a/~a \"$@\"~%"
                                            (which "bash") PYTHONPATH GST_PLUGIN_PATH
                                            (which "python") share what)))
                                (chmod wrapper #o555))))
                   (for-each wrap
                             (list server client worker)
                             (list "master_server.py"
                                   "client.py"
                                   "worker.py")))
                 #t))))))
      (inputs
       `(("gst-kaldi-nnet2-online" ,gst-kaldi-nnet2-online)
         ("python" ,python-wrapper)
         ("python-pygobject" ,python-pygobject)
         ("python-pyyaml" ,python-pyyaml)
         ("python-tornado" ,python-tornado-6)))
      (home-page "https://github.com/alumae/kaldi-gstreamer-server")
      (synopsis "Real-time full-duplex speech recognition server")
      (description "This is a real-time full-duplex speech recognition server,
based on the Kaldi toolkit and the GStreamer framework and implemented in
Python.")
      (license license:bsd-2))))

;; Note that Tensorflow includes a "third_party" directory, which seems to not
;; only contain modified subsets of upstream library source code, but also
;; adapter headers provided by Google (such as the fft.h header, which is not
;; part of the upstream project code).  The Tensorflow code includes headers
;; from the "third_party" directory.  It does not look like we can replace
;; these headers with unmodified upstream files, so we keep them.
(define-public tensorflow
  (package
    (name "tensorflow")
    (version "1.9.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tensorflow/tensorflow")
             (commit (string-append "v" version))))
       (file-name (string-append "tensorflow-" version "-checkout"))
       (sha256
        (base32
         "0a9kwha395g3wgxfwln5j8vn9nkspmd75xldrlqdq540w996g8xa"))))
    (build-system cmake-build-system)
    (arguments
     `(#:tests? #f                      ; no "check" target
       #:build-type "Release"
       #:configure-flags
       (let ((protobuf (assoc-ref %build-inputs "protobuf"))
             (protobuf:native (assoc-ref %build-inputs "protobuf:native"))
             (jsoncpp (assoc-ref %build-inputs "jsoncpp"))
             (snappy (assoc-ref %build-inputs "snappy"))
             (sqlite (assoc-ref %build-inputs "sqlite")))
         (list
          ;; Use protobuf from Guix
          (string-append "-Dprotobuf_STATIC_LIBRARIES="
                         protobuf "/lib/libprotobuf.so")
          (string-append "-DPROTOBUF_PROTOC_EXECUTABLE="
                         protobuf:native "/bin/protoc")

          ;; Use snappy from Guix
          (string-append "-Dsnappy_STATIC_LIBRARIES="
                         snappy "/lib/libsnappy.so")
          ;; Yes, this is not actually the include directory but a prefix...
          (string-append "-Dsnappy_INCLUDE_DIR=" snappy)

          ;; Use jsoncpp from Guix
          (string-append "-Djsoncpp_STATIC_LIBRARIES="
                         jsoncpp "/lib/libjsoncpp.so")
          ;; Yes, this is not actually the include directory but a prefix...
          (string-append "-Djsoncpp_INCLUDE_DIR=" jsoncpp)

          ;; Use sqlite from Guix
          (string-append "-Dsqlite_STATIC_LIBRARIES="
                         sqlite "/lib/libsqlite.a")

          ;; Use system libraries wherever possible.  Currently, this
          ;; only affects zlib.
          "-Dsystemlib_ALL=ON"
          "-Dtensorflow_ENABLE_POSITION_INDEPENDENT_CODE=ON"
          "-Dtensorflow_BUILD_SHARED_LIB=ON"
          "-Dtensorflow_OPTIMIZE_FOR_NATIVE_ARCH=OFF"
          "-Dtensorflow_ENABLE_SSL_SUPPORT=OFF"
          "-Dtensorflow_BUILD_CONTRIB_KERNELS=OFF"))
       #:make-flags
       (list "CC=gcc")
       #:modules ((ice-9 ftw)
                  (guix build utils)
                  (guix build cmake-build-system)
                  ((guix build python-build-system)
                   #:select (python-version)))
       #:imported-modules (,@%cmake-build-system-modules
                            (guix build python-build-system))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'set-source-file-times-to-1980
           ;; At the end of the tf_python_build_pip_package target, a ZIP
           ;; archive should be generated via bdist_wheel, but it fails with
           ;; "ZIP does not support timestamps before 1980".  Luckily,
           ;; SOURCE_DATE_EPOCH is respected, which we set to some time in
           ;; 1980.
           (lambda _ (setenv "SOURCE_DATE_EPOCH" "315532800") #t))
         ;; See https://github.com/tensorflow/tensorflow/issues/20517#issuecomment-406373913
         (add-after 'unpack 'python3.7-compatibility
           (lambda _
             (substitute* '("tensorflow/python/eager/pywrap_tfe_src.cc"
                            "tensorflow/python/lib/core/ndarray_tensor.cc"
                            "tensorflow/python/lib/core/py_func.cc")
               (("PyUnicode_AsUTF8") "(char *)PyUnicode_AsUTF8"))
             (substitute* "tensorflow/c/eager/c_api.h"
               (("unsigned char async")
                "unsigned char is_async"))

             ;; Remove dependency on tensorboard, a complicated but probably
             ;; optional package.
             (substitute* "tensorflow/tools/pip_package/setup.py"
               ((".*'tensorboard >.*") ""))

             ;; Fix the build with python-3.8, taken from rejected upstream patch:
             ;; https://github.com/tensorflow/tensorflow/issues/34197
             (substitute* (find-files "tensorflow/python" ".*\\.cc$")
               (("(nullptr,)(\\ +/. tp_print)" _ _ tp_print)
                (string-append "NULL,   " tp_print)))
             #t))
         (add-after 'python3.7-compatibility 'chdir
           (lambda _ (chdir "tensorflow/contrib/cmake") #t))
         (add-after 'chdir 'disable-downloads
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* (find-files "external" "\\.cmake$")
               (("GIT_REPOSITORY.*") "")
               (("GIT_TAG.*") "")
               (("PREFIX ")
                "DOWNLOAD_COMMAND \"\"\nPREFIX "))

             ;; Use packages from Guix
             (let ((grpc (assoc-ref inputs "grpc")))
               (substitute* "CMakeLists.txt"
                 ;; Sqlite
                 (("include\\(sqlite\\)") "")
                 (("\\$\\{sqlite_STATIC_LIBRARIES\\}")
                  (string-append (assoc-ref inputs "sqlite")
                                 "/lib/libsqlite3.so"))
                 (("sqlite_copy_headers_to_destination") "")

                 ;; PNG
                 (("include\\(png\\)") "")
                 (("\\$\\{png_STATIC_LIBRARIES\\}")
                  (string-append (assoc-ref inputs "libpng")
                                 "/lib/libpng16.so"))
                 (("png_copy_headers_to_destination") "")

                 ;; JPEG
                 (("include\\(jpeg\\)") "")
                 (("\\$\\{jpeg_STATIC_LIBRARIES\\}")
                  (string-append (assoc-ref inputs "libjpeg")
                                 "/lib/libjpeg.so"))
                 (("jpeg_copy_headers_to_destination") "")

                 ;; GIF
                 (("include\\(gif\\)") "")
                 (("\\$\\{gif_STATIC_LIBRARIES\\}")
                  (string-append (assoc-ref inputs "giflib")
                                 "/lib/libgif.so"))
                 (("gif_copy_headers_to_destination") "")

                 ;; lmdb
                 (("include\\(lmdb\\)") "")
                 (("\\$\\{lmdb_STATIC_LIBRARIES\\}")
                  (string-append (assoc-ref inputs "lmdb")
                                 "/lib/liblmdb.so"))
                 (("lmdb_copy_headers_to_destination") "")

                 ;; Protobuf
                 (("include\\(protobuf\\)") "")
                 (("protobuf_copy_headers_to_destination") "")
                 (("^ +protobuf") "")

                 ;; gRPC
                 (("include\\(grpc\\)")
                  "find_package(grpc REQUIRED NAMES gRPC)")
                 (("list\\(APPEND tensorflow_EXTERNAL_DEPENDENCIES grpc\\)") "")

                 ;; Eigen
                 (("include\\(eigen\\)")
                  (string-append "find_package(eigen REQUIRED NAMES Eigen3)
set(eigen_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/external/eigen_archive "
                                 (assoc-ref inputs "eigen") "/include/eigen3)"))
                 (("^ +eigen") "")

                 ;; snappy
                 (("include\\(snappy\\)")
                  "add_definitions(-DTF_USE_SNAPPY)")
                 (("list\\(APPEND tensorflow_EXTERNAL_DEPENDENCIES snappy\\)") "")

                 ;; jsoncpp
                 (("include\\(jsoncpp\\)") "")
                 (("^ +jsoncpp") ""))

               (substitute* "tf_core_framework.cmake"
                 ((" grpc") "")
                 (("\\$\\{GRPC_BUILD\\}/grpc_cpp_plugin")
                  (which "grpc_cpp_plugin"))
                 ;; Link with gRPC libraries
                 (("add_library\\(tf_protos_cc.*" m)
                  (string-append m
                                 (format #f "\ntarget_link_libraries(tf_protos_cc PRIVATE \
~a/lib/libgrpc++_unsecure.a \
~a/lib/libgrpc_unsecure.a \
~a/lib/libaddress_sorting.a \
~a/lib/libgpr.a \
~a//lib/libcares.so
)\n"
                                         grpc grpc grpc grpc
                                         (assoc-ref inputs "c-ares"))))))
             (substitute* "tf_tools.cmake"
               (("add_dependencies\\(\\$\\{proto_text.*") ""))
             ;; Remove dependency on bundled grpc
             (substitute* "tf_core_distributed_runtime.cmake"
               (("tf_core_cpu grpc") "tf_core_cpu"))

             ;; This directory is a dependency of many targets.
             (mkdir-p "protobuf")
             #t))
         (add-after 'configure 'unpack-third-party-sources
           (lambda* (#:key inputs #:allow-other-keys)
             ;; This is needed to configure bundled packages properly.
             (setenv "CONFIG_SHELL" (which "bash"))
             (for-each
              (lambda (name)
                (let* ((what  (assoc-ref inputs (string-append name "-src")))
                       (name* (string-map (lambda (c)
                                            (if (char=? c #\-)
                                                #\_ c)) name))
                       (where (string-append "../build/" name* "/src/" name*)))
                  (cond
                   ((string-suffix? ".zip" what)
                    (mkdir-p where)
                    (with-directory-excursion where
                      (invoke "unzip" what)))
                   ((string-suffix? ".tar.gz" what)
                    (mkdir-p where)
                    (invoke "tar" "xf" what
                            "-C" where "--strip-components=1"))
                   (else
                    (let ((parent (dirname where)))
                      (mkdir-p parent)
                      (with-directory-excursion parent
                        (when (file-exists? name*)
                          (delete-file-recursively name*))
                        (copy-recursively what name*)
                        (map make-file-writable
                             (find-files name* ".*"))))))))
              (list "boringssl"
                    "cub"
                    "double-conversion"
                    "farmhash"
                    "fft2d"
                    "highwayhash"
                    "nsync"
                    "re2"))

             (rename-file "../build/cub/src/cub/cub-1.8.0/"
                          "../build/cub/src/cub/cub/")
             #t))
         (add-after 'unpack 'fix-python-build
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (mkdir-p "protobuf-src")
             (invoke "tar" "xf" (assoc-ref inputs "protobuf:src")
                     "-C" "protobuf-src" "--strip-components=1")
             (mkdir-p "eigen-src")
             (invoke "tar" "xf" (assoc-ref inputs "eigen:src")
                     "-C" "eigen-src" "--strip-components=1")

             (substitute* "tensorflow/contrib/cmake/tf_python.cmake"
               ;; Ensure that all Python dependencies can be found at build time.
               (("PYTHONPATH=\\$\\{CMAKE_CURRENT_BINARY_DIR\\}/tf_python" m)
                (string-append m ":" (getenv "PYTHONPATH")))
               ;; Take protobuf source files from our source package.
               (("\\$\\{CMAKE_CURRENT_BINARY_DIR\\}/protobuf/src/protobuf/src/google")
                (string-append (getcwd) "/protobuf-src/src/google")))

             (substitute* '("tensorflow/contrib/cmake/tf_shared_lib.cmake"
                            "tensorflow/contrib/cmake/tf_python.cmake")
               ;; Take Eigen source files from our source package.
               (("\\$\\{CMAKE_CURRENT_BINARY_DIR\\}/eigen/src/eigen/")
                (string-append (getcwd) "/eigen-src/"))
               ;; Take Eigen headers from our own package.
               (("\\$\\{CMAKE_CURRENT_BINARY_DIR\\}/external/eigen_archive")
                (string-append (assoc-ref inputs "eigen") "/include/eigen3")))

             ;; Correct the RUNPATH of ops libraries generated for Python.
             ;; TODO: this doesn't work :(
             ;; /gnu/store/...-tensorflow-1.9.0/lib/python3.7/site-packages/tensorflow/contrib/seq2seq/python/ops/lib_beam_search_ops.so:
             ;; warning: RUNPATH contains bogus entries: ("/tmp/guix-build-tensorflow-1.9.0.drv-0/source/tensorflow/contrib/build")
             ;; /gnu/store/...-tensorflow-1.9.0/lib/python3.7/site-packages/tensorflow/contrib/seq2seq/python/ops/lib_beam_search_ops.so:
             ;; error: depends on 'libpywrap_tensorflow_internal.so', which
             ;; cannot be found in RUNPATH ...
             (substitute* "tensorflow/contrib/cmake/tf_cc_ops.cmake"
               (("set_target_properties.*")
                (string-append "set_target_properties(${_AT_TARGET} PROPERTIES \
COMPILE_FLAGS ${target_compile_flags} \
INSTALL_RPATH_USE_LINK_PATH TRUE \
INSTALL_RPATH " (assoc-ref outputs "out") "/lib)\n")))
             #t))
         (add-after 'build 'build-pip-package
           (lambda* (#:key outputs #:allow-other-keys)
             (setenv "LDFLAGS"
                     (string-append "-Wl,-rpath="
                                    (assoc-ref outputs "out") "/lib"))
             (invoke "make" "tf_python_build_pip_package")
             #t))
         (add-after 'build-pip-package 'install-python
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((out (assoc-ref outputs "out"))
                   (wheel (car (find-files "../build/tf_python/dist/" "\\.whl$")))
                   (python-version (python-version
                                     (assoc-ref inputs "python"))))
               (invoke "python" "-m" "pip" "install" wheel
                       (string-append "--prefix=" out))

               ;; XXX: broken RUNPATH, see fix-python-build phase.
               (delete-file
                (string-append
                 out "/lib/python" python-version
                 "/site-packages/tensorflow/contrib/"
                 "seq2seq/python/ops/lib_beam_search_ops.so"))
               #t))))))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("protobuf:native" ,protobuf-3.6) ; protoc
       ("protobuf:src" ,(package-source protobuf-3.6))
       ("eigen:src" ,(package-source eigen-for-tensorflow))
       ;; install_pip_packages.sh wants setuptools 39.1.0 specifically.
       ("python-setuptools" ,python-setuptools-for-tensorflow)

       ;; The commit hashes and URLs for third-party source code are taken
       ;; from "tensorflow/workspace.bzl".
       ("boringssl-src"
        ,(let ((commit "ee7aa02")
               (revision "1"))
           (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://boringssl.googlesource.com/boringssl")
                   (commit commit)))
             (file-name (string-append "boringssl-0-" revision
                                       (string-take commit 7)
                                       "-checkout"))
             (sha256
              (base32
               "1jf693q0nw0adsic6cgmbdx6g7wr4rj4vxa8j1hpn792fqhd8wgw")))))
       ("cub-src"
        ,(let ((version "1.8.0"))
           (origin
             (method url-fetch)
             (uri (string-append "https://mirror.bazel.build/github.com/NVlabs/"
                                 "cub/archive/" version ".zip"))
             (file-name (string-append "cub-" version ".zip"))
             (sha256
              (base32
               "1hsqikqridb90dkxkjr2918dcry6pfh46ccnwrzawl56aamhdykb")))))
       ("double-conversion-src"
        ,(let ((commit "5664746")
               (revision "1"))
           (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/google/double-conversion")
                   (commit commit)))
             (file-name
              (git-file-name "double-conversion"
                             (string-append "0-" revision "."
                                            (string-take commit 7))))
             (sha256
              (base32
               "1h5lppqqxcvdg5jq42i5msgwx20ryij3apvmndflngrgdpc04gn1")))))
       ("farmhash-src"
        ,(let ((commit "816a4ae622e964763ca0862d9dbd19324a1eaf45"))
           (origin
             (method url-fetch)
             (uri (string-append
                   "https://mirror.bazel.build/github.com/google/farmhash/archive/"
                   commit ".tar.gz"))
             (file-name (string-append "farmhash-0-" (string-take commit 7)
                                       ".tar.gz"))
             (sha256
              (base32
               "185b2xdxl4d4cnsnv6abg8s22gxvx8673jq2yaq85bz4cdy58q35")))))
       ;; The license notice on the home page at
       ;; http://www.kurims.kyoto-u.ac.jp/~ooura/fft.html says:
       ;;   Copyright Takuya OOURA, 1996-2001
       ;;
       ;;   You may use, copy, modify and distribute this code for any purpose
       ;;   (include commercial use) and without fee. Please refer to this
       ;;   package when you modify this code.
       ;;
       ;; We take the identical tarball from the Bazel mirror, because the URL
       ;; at the home page is not versioned and might change.
       ("fft2d-src"
        ,(origin
           (method url-fetch)
           (uri "https://mirror.bazel.build/www.kurims.kyoto-u.ac.jp/~ooura/fft.tgz")
           (file-name "fft2d.tar.gz")
           (sha256
            (base32
             "15jjkfvhqvl2c0753d2di8hz0pyzn598g74wqy79awdrf1y67fsj"))))
       ("highwayhash-src"
        ,(let ((commit "be5edafc2e1a455768e260ccd68ae7317b6690ee")
               (revision "1"))
           (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/google/highwayhash")
                   (commit commit)))
             (file-name (string-append "highwayhash-0-" revision
                                       (string-take commit 7)
                                       "-checkout"))
             (sha256
              (base32
               "154jwf98cyy54hldr94pgjn85zynly3abpnc1avmb8a18lzwjyb6")))))
       ("nsync-src"
        ,(let ((version "0559ce013feac8db639ee1bf776aca0325d28777")
               (revision "1"))
           (origin
             (method url-fetch)
             (uri (string-append "https://mirror.bazel.build/"
                                 "github.com/google/nsync/archive/"
                                 version ".tar.gz"))
             (file-name (string-append "nsync-0." revision
                                       "-" (string-take version 7)
                                       ".tar.gz"))
             (sha256
              (base32
               "0qdkyqym34x739mmzv97ah5r7ph462v5xkxqxvidmcfqbi64b132")))))
       ("re2-src"
        ,(let ((commit "e7efc48")
               (revision "1"))
           (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/google/re2")
                   (commit commit)))
             (file-name (string-append "re2-0-" revision
                                       (string-take commit 7)
                                       "-checkout"))
             (sha256
              (base32
               "161g9841rjfsy5pn52fcis0s9hdr7rxvb06pad38j5rppfihvign")))))
       ("googletest" ,googletest)
       ("swig" ,swig)
       ("unzip" ,unzip)))
    (propagated-inputs
     `(("python-absl-py" ,python-absl-py)
       ("python-astor" ,python-astor)
       ("python-gast" ,python-gast)
       ("python-grpcio" ,python-grpcio)
       ("python-numpy" ,python-numpy)
       ("python-protobuf" ,python-protobuf-3.6)
       ("python-six" ,python-six)
       ("python-termcolo" ,python-termcolor)
       ("python-wheel" ,python-wheel)))
    (inputs
     `(("c-ares" ,c-ares)
       ("eigen" ,eigen-for-tensorflow)
       ("gemmlowp" ,gemmlowp-for-tensorflow)
       ("lmdb" ,lmdb)
       ("libjpeg" ,libjpeg-turbo)
       ("libpng" ,libpng)
       ("giflib" ,giflib)
       ("grpc" ,grpc-1.16.1 "static")
       ("grpc:bin" ,grpc-1.16.1)
       ("jsoncpp" ,jsoncpp-for-tensorflow)
       ("snappy" ,snappy)
       ("sqlite" ,sqlite)
       ("protobuf" ,protobuf-3.6)
       ("python" ,python-wrapper)
       ("zlib" ,zlib)))
    (home-page "https://tensorflow.org")
    (synopsis "Machine learning framework")
    (description
     "TensorFlow is a flexible platform for building and training machine
learning models.  It provides a library for high performance numerical
computation and includes high level Python APIs, including both a sequential
API for beginners that allows users to build models quickly by plugging
together building blocks and a subclassing API with an imperative style for
advanced research.")
    (license license:asl2.0)))

(define-public python-iml
  (package
    (name "python-iml")
    (version "0.6.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "iml" version))
       (sha256
        (base32
         "1k8szlpm19rcwcxdny9qdm3gmaqq8akb4xlvrzyz8c2d679aak6l"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("ipython" ,python-ipython)
       ("numpy" ,python-numpy)
       ("pandas" ,python-pandas)
       ("scipy" ,python-scipy)))
    (native-inputs
     `(("nose" ,python-nose)))
    (home-page "https://github.com/interpretable-ml/iml")
    (synopsis "Interpretable Machine Learning (iML) package")
    (description "Interpretable ML (iML) is a set of data type objects,
visualizations, and interfaces that can be used by any method designed to
explain the predictions of machine learning models (or really the output of
any function).  It currently contains the interface and IO code from the Shap
project, and it will potentially also do the same for the Lime project.")
    (license license:expat)))

(define-public python-keras-applications
  (package
    (name "python-keras-applications")
    (version "1.0.8")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "Keras_Applications" version))
       (sha256
        (base32
         "1rcz31ca4axa6kzhjx4lwqxbg4wvlljkj8qj9a7p9sfd5fhzjyam"))))
    (build-system python-build-system)
    ;; The tests require Keras, but this package is needed to build Keras.
    (arguments '(#:tests? #f))
    (propagated-inputs
     `(("python-h5py" ,python-h5py)
       ("python-numpy" ,python-numpy)))
    (native-inputs
     `(("python-pytest" ,python-pytest)
       ("python-pytest-cov" ,python-pytest-cov)
       ("python-pytest-pep8" ,python-pytest-pep8)
       ("python-pytest-xdist" ,python-pytest-xdist)))
    (home-page "https://github.com/keras-team/keras-applications")
    (synopsis "Reference implementations of popular deep learning models")
    (description
     "This package provides reference implementations of popular deep learning
models for use with the Keras deep learning framework.")
    (license license:expat)))

(define-public python-keras-preprocessing
  (package
    (name "python-keras-preprocessing")
    (version "1.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "Keras_Preprocessing" version))
       (sha256
        (base32
         "1r98nm4k1svsqjyaqkfk23i31bl1kcfcyp7094yyj3c43phfp3as"))))
    (build-system python-build-system)
    (propagated-inputs
     `(("python-numpy" ,python-numpy)
       ("python-six" ,python-six)))
    (native-inputs
     `(("python-pandas" ,python-pandas)
       ("python-pillow" ,python-pillow)
       ("python-pytest" ,python-pytest)
       ("python-pytest-cov" ,python-pytest-cov)
       ("python-pytest-xdist" ,python-pytest-xdist)
       ("tensorflow" ,tensorflow)))
    (home-page "https://github.com/keras-team/keras-preprocessing/")
    (synopsis "Data preprocessing and augmentation for deep learning models")
    (description
     "Keras Preprocessing is the data preprocessing and data augmentation
module of the Keras deep learning library.  It provides utilities for working
with image data, text data, and sequence data.")
    (license license:expat)))

(define-public python-keras
  (package
    (name "python-keras")
    (version "2.2.4")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "Keras" version))
       (patches (search-patches "python-keras-integration-test.patch"))
       (sha256
        (base32
         "1j8bsqzh49vjdxy6l1k4iwax5vpjzniynyd041xjavdzvfii1dlh"))))
    (build-system python-build-system)
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'remove-tests-for-unavailable-features
           (lambda _
             (delete-file "keras/backend/theano_backend.py")
             (delete-file "keras/backend/cntk_backend.py")
             (delete-file "tests/keras/backend/backend_test.py")

             ;; FIXME: This doesn't work because Tensorflow is missing the
             ;; coder ops library.
             (delete-file "tests/keras/test_callbacks.py")
             #t))
         (replace 'check
           (lambda _
             ;; These tests attempt to download data files from the internet.
             (delete-file "tests/integration_tests/test_datasets.py")
             (delete-file "tests/integration_tests/imagenet_utils_test.py")
             ;; Backport https://github.com/keras-team/keras/pull/12479.
             (substitute* "tests/keras/engine/test_topology.py"
               (("np.ones\\(\\(3, 2\\)\\)")
                "1."))
             (invoke "python" "-m" "pytest"
                     ;; The following test fail only in the build container;
                     ;; skip it.
                     "-k" "not test_selu"))))))
    (propagated-inputs
     `(("python-h5py" ,python-h5py)
       ("python-keras-applications" ,python-keras-applications)
       ("python-keras-preprocessing" ,python-keras-preprocessing)
       ("python-numpy" ,python-numpy)
       ("python-pydot" ,python-pydot)
       ("python-pyyaml" ,python-pyyaml)
       ("python-scipy" ,python-scipy)
       ("python-six" ,python-six)
       ("tensorflow" ,tensorflow)
       ("graphviz" ,graphviz)))
    (native-inputs
     `(("python-pandas" ,python-pandas)
       ("python-pytest" ,python-pytest)
       ("python-pytest-cov" ,python-pytest-cov)
       ("python-pytest-pep8" ,python-pytest-pep8)
       ("python-pytest-timeout" ,python-pytest-timeout)
       ("python-pytest-xdist" ,python-pytest-xdist)
       ("python-sphinx" ,python-sphinx)
       ("python-requests" ,python-requests)))
    (home-page "https://github.com/keras-team/keras")
    (synopsis "High-level deep learning framework")
    (description "Keras is a high-level neural networks API, written in Python
and capable of running on top of TensorFlow.  It was developed with a focus on
enabling fast experimentation.  Use Keras if you need a deep learning library
that:

@itemize
@item Allows for easy and fast prototyping (through user friendliness,
  modularity, and extensibility).
@item Supports both convolutional networks and recurrent networks, as well as
  combinations of the two.
@item Runs seamlessly on CPU and GPU.
@end itemize\n")
    (license license:expat)))

(define-public gloo
  (let ((version "0.0.0") ; no proper version tag
        (commit "ca528e32fea9ca8f2b16053cff17160290fc84ce")
        (revision "0"))
    (package
      (name "gloo")
      (version (git-version version revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/facebookincubator/gloo")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1q9f80zy75f6njrzrqkmhc0g3qxs4gskr7ns2jdqanxa2ww7a99w"))))
      (build-system cmake-build-system)
      (native-inputs
       `(("googletest" ,googletest)))
      (arguments
       `(#:configure-flags '("-DBUILD_TEST=1")
         #:phases
         (modify-phases %standard-phases
           (replace 'check
             (lambda _
               (invoke "make" "gloo_test")
               #t)))))
      (synopsis "Collective communications library")
      (description
       "Gloo is a collective communications library.  It comes with a
number of collective algorithms useful for machine learning applications.
These include a barrier, broadcast, and allreduce.")
      (home-page "https://github.com/facebookincubator/gloo")
      (license license:bsd-3))))

(define-public python-umap-learn
  (package
    (name "python-umap-learn")
    (version "0.3.10")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "umap-learn" version))
       (sha256
        (base32
         "02ada2yy6km6zgk2836kg1c97yrcpalvan34p8c57446finnpki1"))))
    (build-system python-build-system)
    (native-inputs
     `(("python-joblib" ,python-joblib)
       ("python-nose" ,python-nose)))
    (propagated-inputs
     `(("python-numba" ,python-numba)
       ("python-numpy" ,python-numpy)
       ("python-scikit-learn" ,python-scikit-learn)
       ("python-scipy" ,python-scipy)))
    (home-page "https://github.com/lmcinnes/umap")
    (synopsis
     "Uniform Manifold Approximation and Projection")
    (description
     "Uniform Manifold Approximation and Projection is a dimension reduction
technique that can be used for visualisation similarly to t-SNE, but also for
general non-linear dimension reduction.")
    (license license:bsd-3)))

(define-public xnnpack
  ;; There's currently no tag on this repo.
  (let ((version "0.0")
        (commit "bbe88243aba847f6a3dd86defec0fea4a0e415a1")
        (revision "1"))
    (package
      (name "xnnpack")
      (version (git-version version revision commit))
      (home-page "https://github.com/google/XNNPACK")
      (source (origin
                (method git-fetch)
                (uri (git-reference (url home-page) (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "19j605x1l2h95mjhcj90zwjh1153pdgmqggl35ya5w0wll628iiz"))
                (patches (search-patches "xnnpack-system-libraries.patch"))))
      (build-system cmake-build-system)
      (arguments
       '(#:configure-flags '("-DXNNPACK_USE_SYSTEM_LIBS=YES"
                             "-DBUILD_SHARED_LIBS=ON"
                             "-DXNNPACK_LIBRARY_TYPE=shared"
                             "-DXNNPACK_BUILD_TESTS=FALSE" ;FIXME: see below
                             "-DXNNPACK_BUILD_BENCHMARKS=FALSE")

         ;; FIXME: Building tests leads to a CMake error:
         ;;
         ;;   ADD_LIBRARY cannot create target "all_microkernels" because
         ;;   another target with the same name already exists.
         #:tests? #f))
      (inputs
       `(("cpuinfo" ,cpuinfo)
         ("pthreadpool" ,pthreadpool)
         ("googletest" ,googletest)
         ("googlebenchmark" ,googlebenchmark)
         ("fxdiv" ,fxdiv)
         ("fp16" ,fp16)
         ("psimd" ,psimd)))
      (synopsis "Optimized floating-point neural network inference operators")
      (description
       "XNNPACK is a highly optimized library of floating-point neural network
inference operators for ARM, WebAssembly, and x86 platforms.  XNNPACK is not
intended for direct use by deep learning practitioners and researchers;
instead it provides low-level performance primitives for accelerating
high-level machine learning frameworks, such as TensorFlow Lite,
TensorFlow.js, PyTorch, and MediaPipe.")
      (license license:bsd-3))))

