;;;; ralt-site.asd

(asdf:defsystem #:ralt-site
  :serial t
  :description "Describe ralt-site here"
  :author "Your Name <your.name@example.com>"
  :license "Specify license here"
  :depends-on (#:sexml
               #:jsown
               #:hunchentoot)
  :components ((:file "package")
               (:file "framework")
               (:file "ralt-site")))

