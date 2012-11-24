;;;; package.lisp

(defpackage #:ralt-site
  (:use #:cl)
  (:export :boot :toggle-logging))


#+sbcl (declaim (sb-ext:muffle-conditions style-warning))
(eval-when (:compile-toplevel :load-toplevel :execute)
  (sexml:with-compiletime-active-layers (sexml:standard-sexml sexml:xml-doctype)
    (sexml:support-dtd (asdf:system-relative-pathname :sexml "html5.dtd") :<)))
#+sbcl (declaim (sb-ext:unmuffle-conditions style-warning))
