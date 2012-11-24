;;;; ralt-site.asd

(asdf:defsystem #:ralt-site
  :serial t
  :description "My first Common Lisp project"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :depends-on (#:sexml
               #:hunchentoot)
  :components ((:file "package")
               (:file "framework")
               (:file "ralt-site")))

