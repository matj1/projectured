;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2009 by the authors.
;;;
;;; See LICENCE for details.

(in-package :projectured)

;;;;;;
;;; Document

(def document common-lisp/base ()
  ((collapsed :type boolean)))

(def document common-lisp/insertion (common-lisp/base)
  ((value :type string)
   (default-value :type string)
   (compound :type boolean)
   (factory :type function)))

(def document common-lisp/constant (common-lisp/base)
  ((value :type t)))

(def document common-lisp/variable-reference (common-lisp/base)
  ((variable :type common-lisp/base)))

(def document common-lisp/function-reference (common-lisp/base)
  ((function :type common-lisp/base)))

(def document common-lisp/if (common-lisp/base)
  ((condition :type common-lisp/base)
   (then :type common-lisp/base)
   (else :type common-lisp/base)))

(def document common-lisp/progn (common-lisp/base)
  ((body :type sequence)))

(def document common-lisp/the (common-lisp/base)
  ((declared-type :type t)
   (value :type common-lisp/base)))

(def document common-lisp/lexical-variable-binding (common-lisp/base)
  ((name :type t)
   (value :type common-lisp/base)))

(def document common-lisp/let (common-lisp/base)
  ((bindings :type sequence)
   (body :type sequence)))

(def document common-lisp/application (common-lisp/base)
  ((operator :type symbol)
   (arguments :type sequence)
   (factory :type function)))

(def document common-lisp/special-variable-definition (common-lisp/base)
  ((name :type s-expression/symbol)
   (value :type common-lisp/base)))

(def document common-lisp/function-definition (common-lisp/base)
  ((name :type s-expression/symbol)
   (bindings :type sequence)
   (allow-other-keys :type boolean)
   (documentation :type string)
   (body :type sequence)))

(def document common-lisp/macro-definition (common-lisp/base)
  ((name :type s-expression/symbol)
   (bindings :type sequence)
   (allow-other-keys :type boolean)
   (documentation :type string)
   (body :type sequence)))

(def document common-lisp/class-definition (common-lisp/base)
  ((name :type s-expression/symbol)
   (supers :type sequence)
   (slots :type sequence)))

(def document common-lisp/lambda-function (common-lisp/base)
  ((bindings :type sequence)
   (allow-other-keys :type boolean)
   (body :type sequence)))

(def document common-lisp/function-argument (common-lisp/base)
  ((name :type symbol)))

(def document common-lisp/required-function-argument (common-lisp/function-argument)
  ())

(def document common-lisp/optional-function-argument (common-lisp/function-argument)
  ())

(def document common-lisp/keyword-function-argument (common-lisp/function-argument)
  ())

(def document common-lisp/rest-function-argument (common-lisp/function-argument)
  ())

(def document common-lisp/auxiliary-function-argument (common-lisp/function-argument)
  ())

(def document common-lisp/comment (common-lisp/base)
  ((content :type string)))

(def document common-lisp/toplevel (common-lisp/base)
  ((body :type sequence)))

;;;;;;
;;; Construction

(def function make-common-lisp/insertion (value factory &key default-value compound collapsed selection)
  (make-instance 'common-lisp/insertion :value value :factory factory :default-value default-value :compound compound :collapsed collapsed :selection selection))

(def function make-common-lisp/comment (content &key collapsed)
  (make-instance 'common-lisp/comment :content content :collapsed collapsed))

(def function make-common-lisp/constant (value &key collapsed selection)
  (make-instance 'common-lisp/constant :value value :collapsed collapsed :selection selection))

(def function make-common-lisp/variable-reference (variable &key collapsed selection)
  (make-instance 'common-lisp/variable-reference :variable variable :collapsed collapsed :selection selection))

(def function make-common-lisp/function-reference (function &key collapsed selection)
  (make-instance 'common-lisp/function-reference :function function :collapsed collapsed :selection selection))

(def function make-common-lisp/if (condition then else &key collapsed selection)
  (make-instance 'common-lisp/if :condition condition :then then :else else :collapsed collapsed :selection selection))

(def function make-common-lisp/progn (body &key collapsed selection)
  (make-instance 'common-lisp/progn :body body :collapsed collapsed :selection selection))

(def function make-common-lisp/lexical-variable-binding (name value &key collapsed selection)
  (make-instance 'common-lisp/lexical-variable-binding :name name :value value :collapsed collapsed :selection selection))

(def function make-common-lisp/let (bindings body &key collapsed selection)
  (make-instance 'common-lisp/let :bindings bindings :body body :collapsed collapsed :selection selection))

(def function make-common-lisp/required-function-argument (name &key collapsed selection)
  (make-instance 'common-lisp/required-function-argument :name name :collapsed collapsed :selection selection))

(def function make-common-lisp/special-variable-definition (name value &key collapsed selection)
  (make-instance 'common-lisp/special-variable-definition
                 :name name
                 :value value
                 :collapsed collapsed
                 :selection selection))

(def function make-common-lisp/function-definition (name bindings body &key allow-other-keys documentation collapsed selection)
  (make-instance 'common-lisp/function-definition
                 :name name
                 :bindings bindings
                 :allow-other-keys allow-other-keys
                 :documentation documentation
                 :body body
                 :collapsed collapsed
                 :selection selection))

(def function make-common-lisp/macro-definition (name bindings body &key allow-other-keys documentation collapsed selection)
  (make-instance 'common-lisp/macro-definition
                 :name name
                 :bindings bindings
                 :allow-other-keys allow-other-keys
                 :documentation documentation
                 :body body
                 :collapsed collapsed
                 :selection selection))

(def function make-common-lisp/class-definition (name supers slots &key collapsed selection)
  (make-instance 'common-lisp/class-definition
                 :name name
                 :supers supers
                 :slots slots
                 :collapsed collapsed
                 :selection selection))

(def function make-common-lisp/lambda-function (bindings body &key allow-other-keys collapsed selection)
  (make-instance 'common-lisp/lambda-function
                 :bindings bindings
                 :allow-other-keys allow-other-keys
                 :body body
                 :collapsed collapsed
                 :selection selection))

(def function make-common-lisp/application (operator arguments &key factory collapsed selection)
  (make-instance 'common-lisp/application :operator operator :arguments arguments :factory factory :collapsed collapsed :selection selection))

(def function make-common-lisp/toplevel (body &key collapsed)
  (make-instance 'common-lisp/toplevel :body body :collapsed collapsed))

;;;;;
;;; API

(def function make-common-lisp/constant* (value)
  (make-common-lisp/constant
   (etypecase value
     (null (make-s-expression/symbol* nil))
     (number (s-expression/number () value))
     (string (s-expression/string () value))
     (symbol (s-expression/quote () (make-s-expression/symbol* value)))
     (list (make-s-expression/list (mapcar 'make-common-lisp/constant* value))))))

;;;;;;
;;; TODO: completion opportunity specifies:
;;;  - whether if it is applicable or not to a given string
;;;  - the remaining string to complete
;;;  - the replacement for the completion if applied
;;;  - how good the completion opportunity is

;;;;;;
;;; TODO: completion factory takes a list of completion opportunities along with a string and returns the best completion

(def class* common-lisp/function-definition/completion ()
  ((function-definition :type common-lisp/function-definition))
  (:metaclass funcallable-standard-class))

(def method initialize-instance :after ((instance common-lisp/function-definition/completion) &key &allow-other-keys)
  (set-funcallable-instance-function
   instance
   (lambda (factory printer-input reader-input name)
     (bind ((function-definition (function-definition-of factory)))
       (completion-prefix-merge
         (common-lisp/complete-document factory printer-input reader-input name)
         (completion-prefix-switch name
           ((name-of (name-of function-definition))
            (bind ((name-length (length (name-of (name-of function-definition)))))
              (make-common-lisp/application (make-common-lisp/function-reference function-definition
                                                                                 :selection `((the common-lisp/function-definition (function-of (the common-lisp/function-reference document)))
                                                                                              (the s-expression/symbol (name-of (the common-lisp/function-definition document)))
                                                                                              (the string (name-of (the s-expression/symbol document)))
                                                                                              (the string (subseq (the string document) ,name-length ,name-length))))
                                            nil
                                            :factory (factory-of printer-input)
                                            :selection '((the common-lisp/function-reference (operator-of (the common-lisp/application document))))))))
         (completion-prefix-switch* name
                                    (iter (for binding :in-sequence (bindings-of function-definition))
                                          (for name = (string-downcase (name-of (name-of binding))))
                                          (collect (cons name
                                                         (bind ((name-length (length name)))
                                                           (make-common-lisp/variable-reference binding :selection `((the common-lisp/required-function-argument (variable-of (the common-lisp/variable-reference document)))
                                                                                                                     (the s-expression/symbol (name-of (the common-lisp/required-function-argument document)))
                                                                                                                     (the string (name-of (the s-expression/symbol document)))
                                                                                                                     (the string (subseq (the string document) ,name-length ,name-length))))))))))))))

(def function common-lisp/complete-document/fuction-definition (factory printer-input reader-input name)
  (bind ((name-length (length name)))
    (make-common-lisp/required-function-argument (make-s-expression/symbol name "COMMON-LISP-USER"
                                                                        :selection `((the string (name-of (the s-expression/symbol document)))
                                                                                     (the string (subseq (the string document) ,name-length ,name-length))))
                                                 :selection `((the s-expression/symbol (name-of (the common-lisp/function-argument document)))))))

(def function common-lisp/complete-document (factory printer-input reader-input name)
  (bind (((:values document completion)
          (completion-prefix-switch name
            ("defun" (make-common-lisp/function-definition (make-s-expression/symbol "" "COMMON-LISP-USER")
                                                           (list-ll (make-common-lisp/insertion "" 'common-lisp/complete-document/fuction-definition))
                                                           nil
                                                           :documentation ""
                                                           :selection '((the s-expression/symbol (name-of (the common-lisp/function-definition document)))
                                                                        (the string (name-of (the s-expression/symbol document)))
                                                                        (the string (subseq (the string document) 0 0)))))
            ("if" (make-common-lisp/if (make-common-lisp/insertion "" (factory-of printer-input) :default-value "enter condition"
                                                                   :selection  '((the string (value-of (the common-lisp/insertion document)))
                                                                                 (the string (subseq (the string document) 0 0))))
                                       (make-common-lisp/insertion "" (factory-of printer-input) :default-value "enter then branch")
                                       (make-common-lisp/insertion "" (factory-of printer-input) :default-value "enter else branch")
                                       :selection '((the common-lisp/insertion (condition-of (the common-lisp/if document))))))
            ("progn" (make-common-lisp/progn nil))
            ("let" (make-common-lisp/let nil nil))
            ("lambda" (make-common-lisp/lambda-function nil nil)))))
    (if (or document completion)
        (values document completion)
        (or (awhen (find-symbol (string-upcase name) :common-lisp-user)
              (bind ((position (length (symbol-name it)))
                     (argument-insertion? (and reader-input
                                               (gesture= (gesture-of reader-input)
                                                         (make-type-in-gesture #\Space)))))
                (make-common-lisp/application (make-s-expression/symbol* it)
                                              (when argument-insertion?
                                                (list-ll (make-common-lisp/insertion "" (factory-of printer-input)
                                                                                     :selection  '((the string (value-of (the common-lisp/insertion document)))
                                                                                                   (the string (subseq (the string document) 0 0))))))
                                              :selection (if argument-insertion?
                                                             `((the sequence (arguments-of (the common-lisp/application document)))
                                                               (the common-lisp/insertion (elt (the sequence document) 0)))
                                                             `((the s-expression/symbol (operator-of (the common-lisp/application document)))
                                                               (the string (name-of (the s-expression/symbol document)))
                                                               (the string (subseq (the string document) ,position ,position))))
                                              :factory (factory-of printer-input))))
            #+nil
            (values nil
                    (bind ((symbols (prog1-bind symbols nil
                                      (do-symbols (symbol :common-lisp-user)
                                        (push (string-downcase (symbol-name symbol)) symbols))))
                           (matching-prefixes (remove-if-not (curry 'starts-with-subseq name) symbols))
                           (common-prefix (reduce 'longest-common-prefix matching-prefixes :initial-value (first matching-prefixes))))
                      (subseq common-prefix (min (length common-prefix) (length name)))))))))

(def maker lisp ()
  (make-common-lisp/insertion "" 'common-lisp/complete-document
                              :default-value "enter form"
                              :selection '((the string (value-of (the common-lisp/insertion document)))
                                           (the string (subseq (the string document) 0 0)))))

(def loader lisp (filename)
  (with-input-from-file (input filename :element-type 'character)
    (labels ((recurse-binding (form)
               (etypecase form
                 (symbol (make-common-lisp/required-function-argument (make-s-expression/symbol* form)))
                 (cons (make-common-lisp/required-function-argument (make-s-expression/symbol* (first form))))))
             (recurse-form (form)
               (pattern-case form
                 ;; TODO: this is kludgy at best
                 ((common-lisp:in-package ?package)
                  (setf *package* (find-package ?package))
                  (make-common-lisp/application (make-s-expression/symbol* 'common-lisp:in-package) (list-ll (make-s-expression/symbol* ?package))))
                 ((defun ?name ?bindings ?documentation . ?body)
                  (make-common-lisp/function-definition (make-s-expression/symbol* ?name)
                                                        (ll (mapcar #'recurse-binding ?bindings))
                                                        (ll (mapcar #'recurse-form ?body))
                                                        :documentation ?documentation))
                 ((def function ?name ?bindings . ?body)
                  (make-common-lisp/function-definition (make-s-expression/symbol* ?name)
                                                        (ll (mapcar #'recurse-binding ?bindings))
                                                        (ll (mapcar #'recurse-form ?body))))
                 ((def forward-mapper ?name ?bindings . ?body)
                  (make-common-lisp/function-definition (make-s-expression/symbol* ?name)
                                                        (ll (mapcar #'recurse-binding ?bindings))
                                                        (ll (mapcar #'recurse-form ?body))))
                 ((def backward-mapper ?name ?bindings . ?body)
                  (make-common-lisp/function-definition (make-s-expression/symbol* ?name)
                                                        (ll (mapcar #'recurse-binding ?bindings))
                                                        (ll (mapcar #'recurse-form ?body))))
                 ((def printer ?name ?bindings . ?body)
                  (make-common-lisp/function-definition (make-s-expression/symbol* ?name)
                                                        (ll (mapcar #'recurse-binding ?bindings))
                                                        (ll (mapcar #'recurse-form ?body))))
                 ((def reader ?name ?bindings . ?body)
                  (make-common-lisp/function-definition (make-s-expression/symbol* ?name)
                                                        (ll (mapcar #'recurse-binding ?bindings))
                                                        (ll (mapcar #'recurse-form ?body))))
                 ((def macro ?name ?bindings . ?body)
                  (make-common-lisp/macro-definition (make-s-expression/symbol* ?name)
                                                     (ll (mapcar #'recurse-binding ?bindings))
                                                     (ll (mapcar #'recurse-form ?body))))
                 ((def document ?name ?supers ?slots . ?options)
                  (make-common-lisp/class-definition (make-s-expression/symbol* ?name) nil nil))
                 ((def projection ?name ?supers ?slots . ?options)
                  (make-common-lisp/class-definition (make-s-expression/symbol* ?name) nil nil))
                 ((def iomap ?name ?supers ?slots . ?options)
                  (make-common-lisp/class-definition (make-s-expression/symbol* ?name) nil nil))
                 ((pattern-case . ?cases)
                  (make-common-lisp/constant* 'todo))
                 ((gesture-case . ?cases)
                  (make-common-lisp/constant* 'todo))
                 ((bind ?bindings . ?body)
                  (make-common-lisp/constant* 'todo))
                 ((if ?condition ?then ?else)
                  (make-common-lisp/if (recurse-form ?condition) (recurse-form ?then) (recurse-form ?else)))
                 ((let ?bindings ?body)
                  (make-common-lisp/let nil nil))
                 ((let* ?bindings ?body)
                  (make-common-lisp/let nil nil))
                 ((?function . ?arguments)
                  (make-common-lisp/application (make-s-expression/symbol* ?function) (ll (mapcar #'recurse-form ?arguments))))
                 (?atom
                  (etypecase ?atom
                    (symbol (make-common-lisp/variable-reference (make-common-lisp/lexical-variable-binding (make-s-expression/symbol* ?atom) nil)))
                    ((or number string) (make-common-lisp/constant* ?atom))
                    (sb-impl::comma
                     ;; TODO: backquote
                     (recurse-form (sb-impl::comma-expr ?atom))))))))
      (bind ((*package* (find-package :common-lisp)))
        (make-common-lisp/toplevel (ll (iter (for form = (read input nil nil))
                                             (while form)
                                             (collect (recurse-form form)))))))))

(def saver lisp (filename document)
  (with-output-to-file (output filename :if-does-not-exist :create :if-exists :overwrite :element-type '(unsigned-byte 8))
    (write-sequence (babel:string-to-octets (print-document document nil)) output)))