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

(defpage (:posts/new)
  "Form response"
  (when (hunchentoot:post-parameters*)
    (add-post (alist-to-plist (hunchentoot:post-parameters*)))
    "I haz"))

(defun alist-to-plist (alist)
  "Transforms ((k . v) (k1 . v1)) into (:k v :k1 v1)"
  (list
    (mapcan #'(lambda (item)
                (let ((key (intern (string-upcase (car item)) "KEYWORD"))
                      (value (cdr item)))
                  (list key value)))
            alist)))

(defun add-post (post)
  (setf *posts* (append *posts* post)))

(defun standard-page (title &rest content)
  "Defines template"
  (<:html (<:head
            (<:meta :charset "utf-8")
            (<:title "ralt-site :: " title))
          (<:body content)))

(defpage (:posts)
  "Lists of posts"
  (standard-page "posts"
                 (loop for post in (get-posts) collect (<:p (getf post :title)))))

(defpage (:posts id)
  "Shows single post"
  (let ((post (car (get-post id))))
    (standard-page (s+ "post: " (getf post :title))
                   (getf post :content))))

;;; Default list
(defparameter *posts* '((:id 1 :title "title1" :content "<p>some</p><p>paragraph</p>")
                  (:id 2 :title "title2" :content "<h1>text</h1>")))

(defun get-post (id)
  "Gets one post"
  (remove-if-not #'(lambda (item)
                     (= (parse-integer id) (getf item :id)))
                 *posts*))

(defun get-posts ()
  "Shows all posts"
  *posts*)
