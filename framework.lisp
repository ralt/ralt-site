(in-package :ralt-site)

(<:augment-with-doctype "html" "" :auto-emit-p t)

;;;;;;;;;;;;;;;;;;;;;
;;;; helper functions
(defun s+ (&rest args)
  (format nil "~{~A~}" args))

;;;;;;;;;;;;;;;;;;;
;;;; defining pages
(eval-when (:compile-toplevel :load-toplevel :execute)
  (defun components-to-regex (components)
    "creates regex from the components of a url"
    (format nil "^/+~{~a/~^+~}*$"
        (mapcar (lambda (x) (if (keywordp x)
                   (string-downcase (symbol-name x))
                 "([^/]+)"))
            components))))

(defmacro defpage ((&rest components) &body body)
  "defines a webpage, consisting of <components>"
  (let ((variables (remove-if #'keywordp components)))
    `(push (hunchentoot:create-regex-dispatcher
        ,(components-to-regex components)
        (lambda ()
          (multiple-value-bind (s e starts ends)
          (cl-ppcre:scan ,(components-to-regex components)
                 (hunchentoot:request-uri*))
        (declare (ignore s e))
        (apply (lambda (,@variables)
             ,@body)
               (loop for s across starts
              for e across ends
              collect (subseq (hunchentoot:request-uri*) s e))))))
       hunchentoot:*dispatch-table*)))

(defmacro defjson ((&rest components) &body body)
  `(defpage (,@components)
    (setf (hunchentoot:content-type*) "application/json")
    (jsown:to-json ,@body)))

(defmacro with-parameters ((&rest parameters) &body body)
  `(let ,(loop for varname in parameters
            collect `(,varname (parameter ,(string-downcase (string varname)))))
     ,@body))

;;;;;;;;;;;;;;;;;;;;
;;;; hosting folders
(defun mount (filesystem-folder server-url)
  "Mounts folder <filesystem-folder> on <server-url> as a mountpoint.  The former is a local folder, the latter is a base url without / in the front and the back (this is added automagically).
eg: (host-folder \"/tmp/downloaded-library/\" \"lib\")"
  (push (hunchentoot:create-folder-dispatcher-and-handler
         (format nil "/~a/" server-url) filesystem-folder)
        hunchentoot:*dispatch-table*))


;;;;;;;;;;;;;;;;;;;;;;;;
;;;; starting the server
(defparameter *acceptor* nil
  "hunchentoot-acceptor for this service")

(defun boot (&optional (port 8080))
  "hosts jochen-en-marie.in/love on localhost"
  (if *acceptor*
    (progn
      (setf *acceptor* (make-instance 'hunchentoot:easy-acceptor :port port :access-log-destination nil))
      (hunchentoot:start *acceptor*))
    (error "Server is already started")))

(defun toggle-logging ()
  "toggles the logging of the server on or off"
  (setf (hunchentoot:acceptor-access-log-destination *acceptor*)
        (if (hunchentoot:acceptor-access-log-destination *acceptor*)
            nil
            *error-output*)))
