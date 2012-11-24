;;; "ralt-site" goes here. Hacks and glory await!
(in-package :ralt-site)

;;;;;;;;;;;;;;;;;;;;
;;;; hosting folders
(mount (asdf:system-relative-pathname :ralt-site "js/") "js")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; definitions for the html pages
(defpage (:/?)  ; matches http://localhost:8080/ even if the / isn't sent by the client
  (<:html (<:head (<:title "SITE IS UP!"))
          (<:body (<:h1 :class "some-class" "Booyah!")
                  (<:p "yay the site is up!"))))

(defun alist-json (alist) (let ((object (jsown:empty-object))) (loop for (key . value) in alist do (setf (jsown:val object key) value)) object))

(defjson (:json)
  "I haz")

(defpage (:test)
  (setf (hunchentoot:content-type*) "application/json")
  (if (hunchentoot:post-parameters*)
    (jsown:to-json "I haz")
    (jsown:to-json "I haz not")))

;; works for http://localhost:8080/hello/Markus
(defpage (:hello name)
  (<:html (<:head (<:title "hello " name))
          (<:body (<:p "hey there " name ", hello!"))))

(defun standard-page (title &rest content)
  (<:html (<:head
            (<:meta :charset "utf-8")
            (<:title "ralt-site :: " title))
          (<:body content)))

;; works for http://localhost:8080/books/a history of time/authors/E.Naggum/
(defpage (:books book-name :authors author-name)
  (standard-page (s+ "author for " book-name)
                 (<:p "you're looking at author " author-name " for " book-name)
                 (<:ul (loop for i from 0 below 10 collect (<:li "item number " i)))))

(defpage (:posts)
  (standard-page "posts"
                 (loop for post in (get-posts) collect (<:p post))))

(defpage (:posts id)
  (let ((post (car (get-post id))))
    (standard-page (s+ "post: " (getf post :title))
                   (getf post :content))))

(defjson (:json id)
  (get-post id))

(defparameter *posts* '((:id 1 :title "title1" :content "<p>some</p><p>paragraph</p>")
                  (:id 2 :title "title2" :content "<h1>text</h1>")))

(defun get-post (id)
  (remove-if-not #'(lambda (item)
                     (= (parse-integer id) (getf item :id)))
                 *posts*))

(defun get-posts ()
  '("1" "2" "3" "4"))
