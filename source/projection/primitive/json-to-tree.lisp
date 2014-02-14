;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2009 by the authors.
;;;
;;; See LICENCE for details.

(in-package :projectured)

;;;;;;
;;; Projection

(def projection json/nothing->tree/leaf ()
  ())

(def projection json/null->tree/leaf ()
  ())

(def projection json/boolean->tree/leaf ()
  ())

(def projection json/number->tree/leaf ()
  ())

(def projection json/string->tree/leaf ()
  ())

(def projection json/array->tree/node ()
  ())

(def projection json/object-entry->tree/node ()
  ())

(def projection json/object->tree/node ()
  ())

;;;;;;
;;; Construction

(def (function e) make-projection/json/nothing->tree/leaf ()
  (make-projection 'json/nothing->tree/leaf))

(def (function e) make-projection/json/null->tree/leaf ()
  (make-projection 'json/null->tree/leaf))

(def (function e) make-projection/json/boolean->tree/leaf ()
  (make-projection 'json/boolean->tree/leaf))

(def (function e) make-projection/json/number->tree/leaf ()
  (make-projection 'json/number->tree/leaf))

(def (function e) make-projection/json/string->tree/leaf ()
  (make-projection 'json/string->tree/leaf))

(def (function e) make-projection/json/array->tree/node ()
  (make-projection 'json/array->tree/node))

(def (function e) make-projection/json/object-entry->tree/node ()
  (make-projection 'json/object-entry->tree/node))

(def (function e) make-projection/json/object->tree/node ()
  (make-projection 'json/object->tree/node))

;;;;;;
;;; Construction

(def (macro e) json/nothing->tree/leaf ()
  '(make-projection/json/nothing->tree/leaf))

(def (macro e) json/null->tree/leaf ()
  '(make-projection/json/null->tree/leaf))

(def (macro e) json/boolean->tree/leaf ()
  '(make-projection/json/boolean->tree/leaf))

(def (macro e) json/number->tree/leaf ()
  '(make-projection/json/number->tree/leaf))

(def (macro e) json/string->tree/leaf ()
  '(make-projection/json/string->tree/leaf))

(def (macro e) json/array->tree/node ()
  '(make-projection/json/array->tree/node))

(def (macro e) json/object-entry->tree/node ()
  '(make-projection/json/object-entry->tree/node))

(def (macro e) json/object->tree/node ()
  '(make-projection/json/object->tree/node))

;;;;;;
;;; Printer

(def printer json/nothing->tree/leaf (projection recursion input input-reference)
  (bind ((output-selection (pattern-case (selection-of input)
                             (((the string (subseq (the string document) 0 0))
                               (the string (value-of (the json/nothing document))))
                              `((the text/text (text/subseq (the text/text document) 0 0))
                                (the text/text (content-of (the tree/leaf document)))))))
         (string-content (value-of input))
         (text-content (text/text (:selection (butlast output-selection)) (text/string string-content :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/blue*)))
         (output (tree/leaf (:selection output-selection) text-content)))
    (make-iomap/object projection recursion input input-reference output)))

(def printer json/null->tree/leaf (projection recursion input input-reference)
  (bind ((output-selection (pattern-case (selection-of input)
                             (((the json/null document))
                              '((the tree/leaf document)))
                             (((the string (subseq (the string document) ?index ?index))
                               (the string (value-of (the json/null document))))
                              `((the text/text (text/subseq (the text/text document) ,?index ,?index))
                                (the text/text (content-of (the tree/leaf document)))))))
         (string-content (value-of input))
         (text-content (text/text (:selection (butlast output-selection)) (text/string string-content :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/blue*)))
         (output (tree/leaf (:selection output-selection) text-content)))
    (make-iomap/object projection recursion input input-reference output)))

(def printer json/boolean->tree/leaf (projection recursion input input-reference)
  (bind ((output-selection (pattern-case (selection-of input)
                             (((the json/boolean document))
                              '((the tree/leaf document)))
                             (((the string (subseq (the string document) ?index ?index))
                               (the string ((?or false-value-of true-value-of) (the json/boolean document))))
                              `((the text/text (text/subseq (the text/text document) ,?index ,?index))
                                (the text/text (content-of (the tree/leaf document)))))))
         (string-content (if (value-p input)
                             (true-value-of input)
                             (false-value-of input)))
         (text-content (text/text (:selection (butlast output-selection)) (text/string string-content :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/blue*)))
         (output (tree/leaf (:selection output-selection) text-content)))
    (make-iomap/object projection recursion input input-reference output)))

(def printer json/number->tree/leaf (projection recursion input input-reference)
  (bind ((output-selection (pattern-case (selection-of input)
                             (((the json/number document))
                              '((the tree/leaf document)))
                             (((the string (subseq (the string document) ?index ?index))
                               (the string (write-to-string (the number document)))
                               (the number (value-of (the json/number document))))
                              `((the text/text (text/subseq (the text/text document) ,?index ,?index))
                                (the text/text (content-of (the tree/leaf document)))))))
         (string-content (write-to-string (value-of input)))
         (text-content (text/text (:selection (butlast output-selection)) (text/string string-content :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/magenta*)))
         (output (tree/leaf (:selection output-selection) text-content)))
    (make-iomap/object projection recursion input input-reference output)))

(def printer json/string->tree/leaf (projection recursion input input-reference)
  (bind ((output-selection (pattern-case (reverse (selection-of input))
                             (((the tree/leaf (printer-output (the json/string document) ?projection ?recursion)) . ?rest)
                              (when (and (eq projection ?projection) (eq recursion ?recursion))
                                (reverse ?rest)))
                             (((the json/string document))
                              '((the tree/leaf document)))
                             (((the string (value-of (the json/string document)))
                               (the string (subseq (the string document) ?index ?index)))
                              `((the text/text (text/subseq (the text/text document) ,?index ,?index))
                                (the text/text (content-of (the tree/leaf document)))))))
         (text-content (text/text (:selection (butlast output-selection)) (text/string (value-of input) :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/green*)))
         (output (tree/leaf (:opening-delimiter (text/text () (text/string "\"" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                             :closing-delimiter (text/text () (text/string "\"" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                             :selection output-selection)
                   text-content)))
    (make-iomap/object projection recursion input input-reference output)))

(def printer json/array->tree/node (projection recursion input input-reference)
  (bind ((deep-array (find-if-not (of-type '(or json/nothing json/null json/boolean json/number json/string)) (elements-of input)))
         (element-iomaps (iter (for element-index :from 0)
                               (for element :in-sequence (elements-of input))
                               (for element-iomap = (recurse-printer recursion element
                                                                     `((elt (the sequence document) ,element-index)
                                                                       (the sequence (elements-of (the json/array document)))
                                                                       ,@(typed-reference (form-type input) input-reference))))
                               (when (and deep-array (not (first-iteration-p)))
                                 ;; KLUDGE:
                                 (setf (indentation-of (output-of element-iomap)) 1))
                               (collect element-iomap)))
         (output-selection (pattern-case (reverse (selection-of input))
                             (((the tree/node (printer-output (the json/array document) ?projection ?recursion)) . ?rest)
                              (when (and (eq projection ?projection) (eq recursion ?recursion))
                                (reverse ?rest)))
                             (((the json/array document))
                              '((the tree/node document)))
                             (((the sequence (elements-of (the json/array document)))
                               . ?rest)
                              (pattern-case (reverse (selection-of (elements-of input)))
                                (((the ?element-type (elt (the sequence document) ?element-index))
                                  . ?rest)
                                 (bind ((element-iomap (elt element-iomaps ?element-index))
                                        (element-output (output-of element-iomap)))
                                   (append (selection-of element-output)
                                           `((the ,(form-type element-output) (elt (the sequence document) ,?element-index))
                                             (the sequence (children-of (the tree/node document)))))))))))
         (output (make-tree/node (mapcar 'output-of element-iomaps)
                                 :opening-delimiter (text/text () (text/string "[" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                 :closing-delimiter (text/text () (text/string "]" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                 :separator (text/text () (text/string (if deep-array "," ", ") :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                 :selection output-selection)))
    (make-iomap/compound projection recursion input input-reference output element-iomaps)))

(def printer json/object-entry->tree/node (projection recursion input input-reference)
  (bind ((value-iomap (recurse-printer recursion (value-of input)
                                       `((value-of (the json/object-entry document))
                                         ,@(typed-reference (form-type input) input-reference))))
         (output-selection (pattern-case (reverse (selection-of input))
                             (((the tree/node (printer-output (the json/object-entry document) ?projection ?recursion)) . ?rest)
                              (when (and (eq projection ?projection) (eq recursion ?recursion))
                                (reverse ?rest)))
                             (((the json/object-entry document))
                              '((the tree/node document)))
                             (((the string (key-of (the json/object-entry document)))
                               (the string (subseq (the string document) ?character-index ?character-index)))
                              `((the text/text (text/subseq (the text/text document) ,?character-index ,?character-index))
                                (the text/text (content-of (the tree/leaf document)))
                                (the tree/leaf (elt (the sequence document) 0))
                                (the sequence (children-of (the tree/node document)))))
                             (((the ?value-type (value-of (the json/object-entry document)))
                               . ?rest)
                              (append (selection-of (output-of value-iomap))
                                      `((the ,(form-type (output-of value-iomap)) (elt (the sequence document) 1))
                                        (the sequence (children-of (the tree/node document))))))))
         (output (tree/node (:separator (text/text () (text/string " : " :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                             :opening-delimiter (text/text () (text/string "" :font *font/default* :font-color *color/default*))
                             :closing-delimiter (text/text () (text/string "" :font *font/default* :font-color *color/default*))
                             :selection output-selection)
                   (tree/leaf (:opening-delimiter (text/text () (text/string "\"" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                               :closing-delimiter (text/text () (text/string "\"" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                               :selection (butlast output-selection 2))
                     (text/text (:selection (butlast output-selection 3))
                       (text/string (key-of input) :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/red*)))
                   (output-of value-iomap))))
    (make-iomap/compound projection recursion input input-reference output (list value-iomap))))

(def printer json/object->tree/node (projection recursion input input-reference)
  (bind ((entry-iomaps (iter (for index :from 0)
                             (for entry :in-sequence (entries-of input))
                             (for entry-iomap = (recurse-printer recursion entry
                                                                 `((elt (the sequence (entries-of document)) ,index)
                                                                   ,@(typed-reference (form-type input) input-reference))))
                             (unless (first-iteration-p)
                               ;; KLUDGE:
                               (setf (indentation-of (output-of entry-iomap)) 1))
                             (collect entry-iomap)))
         (output-selection (pattern-case (reverse (selection-of input))
                             (((the tree/node (printer-output (the json/object document) ?projection ?recursion)) . ?rest)
                              (when (and (eq projection ?projection) (eq recursion ?recursion))
                                (reverse ?rest)))
                             (((the json/object document))
                              '((the tree/node document)))
                             (((the sequence (entries-of (the json/object document))) . ?rest)
                              (pattern-case (reverse (selection-of (entries-of input)))
                                (((the ?entry-type (elt (the sequence document) ?entry-index)) . ?rest)
                                 (bind ((entry-iomap (elt entry-iomaps ?entry-index))
                                        (entry-output (output-of entry-iomap)))
                                   (append (selection-of entry-output)
                                           `((the ,(form-type entry-output) (elt (the sequence document) ,?entry-index))
                                             (the sequence (children-of (the tree/node document)))))))))))
         (output (make-tree/node (mapcar 'output-of entry-iomaps)
                                 :opening-delimiter (text/text () (text/string "{" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                 :closing-delimiter (text/text () (text/string "}" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                 :separator (text/text () (text/string "," :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*))
                                 :selection output-selection)))
    (make-iomap/compound projection recursion input input-reference output entry-iomaps)))

;;;;;;
;;; Reader

;; TODO: rename and move
(def function make-operation/replace (document reference replacement &optional (list-replacement (list replacement)))
  (pattern-case reference
    ((content-of (the document ?a))
     (make-operation/replace-content document replacement))
    ((elt (the sequence ?a) ?b)
     (make-operation/sequence/replace-element-range document reference list-replacement))
    (?a
     (make-operation/replace-target document reference replacement))))

;; TODO: rename and move
(def function make-operation/replace-foo (document replacement-reference selection-reference replacement &optional (list-replacement (list replacement)))
  (make-operation/compound (list (make-operation/replace document replacement-reference replacement list-replacement)
                                 (make-operation/replace-selection document selection-reference))))

(def function json/read-opeartion (printer-iomap gesture)
  (bind ((printer-input (input-of printer-iomap)))
    (gesture-case gesture
      ((gesture/keyboard/key-press #\n)
       :domain "JSON" :help "Replaces the selected element with null"
       :operation
       (make-operation/replace-target printer-input nil (json/null))
       #+nil
       (make-operation/replace-foo document
                                   (tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)
                                   `(the sequence-position (pos (the string (value (the json/null ,(tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)))) 0))
                                   (json/null)))
      ((gesture/keyboard/key-press #\f)
       :domain "JSON" :help "Replaces the selected element with false"
       :operation
       (make-operation/replace-target printer-input nil (json/boolean #f))
       #+nil
       (make-operation/replace-foo document
                                   (tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)
                                   `(the sequence-position (pos (the string (boolean-to-string (the boolean (value-p (the json/boolean ,(tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)))))) 0))
                                   (json/boolean #f)))
      ((gesture/keyboard/key-press #\t)
       :domain "JSON" :help "Replaces the selected element with true"
       :operation
       (make-operation/replace-target printer-input nil (json/boolean #t))
       #+nil
       (make-operation/replace-foo document
                                   (tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)
                                   `(the sequence-position (pos (the string (boolean-to-string (the boolean (value-p (the json/boolean ,(tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)))))) 0))
                                   (json/boolean #t)))
      #+nil
      ((gesture/keyboard/key-press #\")
       :domain "JSON" :help "Replaces the selected element with an empty string"
       :operation (make-operation/replace-foo document
                                              (tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)
                                              `(the sequence-position (pos (the string (value-of (the json/string ,(tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)))) 0))
                                              (json/string "")))
      #+nil
      ((gesture/keyboard/key-press #\[)
       :domain "JSON" :help "Replaces the selected element with an empty array"
       :operation (make-operation/replace-foo document
                                              (tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)
                                              nil
                                              (json/array)))
      #+nil
      ((gesture/keyboard/key-press #\{)
       :domain "JSON" :help "Replaces the selected element with an empty object"
       :operation (make-operation/replace-foo document
                                              (tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)
                                              nil
                                              (json/object)))
      #+nil
      ((gesture/keyboard/key-press #\,)
       :domain "JSON" :help "Inserts a new element into an array or object"
       :operation (bind ((target (tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document))
                         (before? #f))
                    (pattern-case (selection-of document)
                      ((the sequence-position (pos (the string ?a) ?b))
                       (map-forward document-iomap (tree-replace `(the sequence-position (pos (the string ,?a) ,(* 2 ?b))) '(the document document) `(the document ,(input-reference-of document-iomap)))
                                    (lambda (iomap reference)
                                      (declare (ignore iomap reference))
                                      (setf before? #t)))))
                    (pattern-case target
                      ((elt (the sequence ?a) ?b)
                       (bind ((index (if before? ?b (1+ ?b))))
                         (make-operation/compound (list (make-operation/sequence/replace-element-range document `(the sequence (subseq (the sequence ,?a) ,index ,index)) (list (json/nothing)))
                                                        (make-operation/replace-selection document `(the sequence-position (pos (the string (value (the json/nothing (elt (the sequence ,?a) ,index)))) 0)))))))
                      ((value-of (the json/object-entry (elt (the sequence ?a) ?b)))
                       (make-operation/compound (list (make-operation/sequence/replace-element-range document `(the sequence (subseq (the sequence ,?a) ,?b ,?b)) (list (json/object-entry "" (json/nothing))))))))))
      #+nil
      ((gesture/keyboard/key-press :sdl-key-delete)
       :domain "JSON" :help "Deletes the selected element"
       :operation (make-operation/replace-foo document
                                              (tree-replace (input-reference-of printer-iomap) (input-reference-of document-iomap) 'document)
                                              `((the sequence-position (pos (the string document) 0))
                                                (the string (value (the json/nothing document))))
                                              (json/nothing) nil)))))

(def reader json/nothing->tree/leaf (projection recursion input printer-iomap)
  (declare (ignore projection recursion))
  (bind ((printer-input (input-of printer-iomap)))
    (awhen (labels ((recurse (operation)
                      (typecase operation
                        (operation/quit operation)
                        (operation/replace-selection
                         (make-operation/replace-selection printer-input
                                                           (pattern-case (selection-of operation)
                                                             (((the text/text (text/subseq (the text/text document) 0 0))
                                                               (the text/text (content-of (the tree/leaf document))))
                                                              `((the string (subseq (the string document) 0 0))
                                                                (the string (value-of (the json/nothing document)))))))))))
             (recurse (operation-of input)))
      (make-command (gesture-of input) it :domain (domain-of input) :description (description-of input)))))

(def reader json/null->tree/leaf (projection recursion input printer-iomap)
  (declare (ignore projection recursion))
  (bind ((printer-input (input-of printer-iomap)))
    (merge-commands (awhen (labels ((recurse (operation)
                                      (typecase operation
                                        (operation/quit operation)
                                        (operation/replace-selection
                                         (make-operation/replace-selection printer-input
                                                                           (pattern-case (selection-of operation)
                                                                             (((the tree/leaf document))
                                                                              '((the json/null document)))
                                                                             (((the text/text (text/subseq (the text/text document) ?index ?index))
                                                                               (the text/text (content-of (the tree/leaf document))))
                                                                              `((the string (subseq (the string document) ,?index ,?index))
                                                                                (the string (value-of (the json/null document))))))))
                                        (operation/describe
                                         (make-instance 'operation/describe
                                                        :target (pattern-case (target-of operation)
                                                                  (((the text/text (text/subseq (the text/text document) ?start-index ?end-index))
                                                                    (the text/text (content-of (the tree/leaf document))))
                                                                   `((the string (subseq (the string document) ,?start-index ,?end-index))
                                                                     (the string (value-of (the json/null document))))))))
                                        (operation/show-context-sensitive-help
                                         (make-instance 'operation/show-context-sensitive-help
                                                        :commands (iter (for command :in (commands-of operation))
                                                                        (awhen (recurse (operation-of command))
                                                                          (collect (make-instance 'command
                                                                                                  :gesture (gesture-of command)
                                                                                                  :domain (domain-of command)
                                                                                                  :description (description-of command)
                                                                                                  :operation it)))))))))
                             (recurse (operation-of input)))
                      (make-command (gesture-of input) it :domain (domain-of input) :description (description-of input)))
                    (json/read-opeartion printer-iomap (gesture-of input))
                    (make-command/nothing (gesture-of input)))))

(def reader json/boolean->tree/leaf (projection recursion input printer-iomap)
  (declare (ignore projection recursion))
  (bind ((printer-input (input-of printer-iomap)))
    (merge-commands (awhen (labels ((recurse (operation)
                                      (typecase operation
                                        (operation/quit operation)
                                        (operation/replace-selection
                                         (make-operation/replace-selection printer-input
                                                                           (pattern-case (selection-of operation)
                                                                             (((the tree/leaf document))
                                                                              '((the json/boolean document)))
                                                                             (((the text/text (text/subseq (the text/text document) ?index ?index))
                                                                               (the text/text (content-of (the tree/leaf document))))
                                                                              `((the string (subseq (the string document) ,?index ,?index))
                                                                                (the string (,(if (value-p printer-input) 'true-value-of 'false-value-of) (the json/boolean document))))))))
                                        (operation/describe
                                         (make-instance 'operation/describe
                                                        :target (pattern-case (target-of operation)
                                                                  (((the text/text (text/subseq (the text/text document) ?start-index ?end-index))
                                                                    (the text/text (content-of (the tree/leaf document))))
                                                                   `((the string (subseq (the string document) ,?start-index ,?end-index))
                                                                     (the string (,(if (value-p printer-input) 'true-value-of 'false-value-of) (the json/boolean document))))))))
                                        (operation/show-context-sensitive-help
                                         (make-instance 'operation/show-context-sensitive-help
                                                        :commands (iter (for command :in (commands-of operation))
                                                                        (awhen (recurse (operation-of command))
                                                                          (collect (make-instance 'command
                                                                                                  :gesture (gesture-of command)
                                                                                                  :domain (domain-of command)
                                                                                                  :description (description-of command)
                                                                                                  :operation it)))))))))
                             (recurse (operation-of input)))
                      (make-command (gesture-of input) it :domain (domain-of input) :description (description-of input)))
                    (json/read-opeartion printer-iomap (gesture-of input))
                    (make-command/nothing (gesture-of input)))))

(def reader json/number->tree/leaf (projection recursion input printer-iomap)
  (declare (ignore projection recursion))
  (bind ((printer-input (input-of printer-iomap)))
    (merge-commands (awhen (labels ((recurse (operation)
                                      (typecase operation
                                        (operation/quit operation)
                                        (operation/replace-selection
                                         (make-operation/replace-selection printer-input (pattern-case (selection-of operation)
                                                                                           (((the tree/leaf document))
                                                                                            '((the json/number document)))
                                                                                           (((the text/text (text/subseq (the text/text document) ?index ?index))
                                                                                             (the text/text (content-of (the tree/leaf document))))
                                                                                            `((the string (subseq (the string document) ,?index ,?index))
                                                                                              (the string (write-to-string (the number document)))
                                                                                              (the number (value-of (the json/number document))))))))
                                        (operation/sequence/replace-element-range)
                                        (operation/describe
                                         (make-instance 'operation/describe
                                                        :target (pattern-case (target-of operation)
                                                                  (((the text/text (text/subseq (the text/text document) ?start-index ?end-index))
                                                                    (the text/text (content-of (the tree/leaf document))))
                                                                   `((the string (subseq (the string document) ,?start-index ,?end-index))
                                                                     (the string (write-to-string (the number document)))
                                                                     (the number (value-of (the json/number document))))))))
                                        (operation/show-context-sensitive-help
                                         (make-instance 'operation/show-context-sensitive-help
                                                        :commands (iter (for command :in (commands-of operation))
                                                                        (awhen (recurse (operation-of command))
                                                                          (collect (make-instance 'command
                                                                                                  :gesture (gesture-of command)
                                                                                                  :domain (domain-of command)
                                                                                                  :description (description-of command)
                                                                                                  :operation it))))))
                                        (operation/compound
                                         (bind ((operations (mapcar #'recurse (elements-of operation))))
                                           (unless (some 'null operations)
                                             (make-operation/compound operations)))))))
                             (recurse (operation-of input)))
                      (make-command (gesture-of input) it :domain (domain-of input) :description (description-of input)))
                    (make-command/nothing (gesture-of input)))))

(def reader json/string->tree/leaf (projection recursion input printer-iomap)
  (bind ((printer-input (input-of printer-iomap)))
    (merge-commands (awhen (labels ((recurse (operation)
                                      (typecase operation
                                        (operation/quit operation)
                                        (operation/replace-selection
                                         (make-operation/replace-selection printer-input
                                                                           (pattern-case (selection-of operation)
                                                                             (((the tree/leaf document))
                                                                              '((the json/string document)))
                                                                             (((the text/text (text/subseq (the text/text document) ?index ?index))
                                                                               (the text/text (content-of (the tree/leaf document))))
                                                                              `((the string (subseq (the string document) ,?index ,?index))
                                                                                (the string (value-of (the json/string document)))))
                                                                             (?a
                                                                              (append (selection-of operation) `((the tree/leaf (printer-output (the json/string document) ,projection ,recursion))))))))
                                        (operation/sequence/replace-element-range
                                         (awhen (pattern-case (target-of operation)
                                                  (((the text/text (text/subseq (the text/text document) ?start-index ?end-index))
                                                    (the text/text (content-of (the tree/leaf document))))
                                                   `((the string (subseq (the string document) ,?start-index ,?end-index))
                                                     (the string (value-of (the json/string document))))))
                                           (make-operation/sequence/replace-element-range printer-input it (replacement-of operation))))
                                        (operation/describe
                                         (make-instance 'operation/describe
                                                        :target (pattern-case (target-of operation)
                                                                  (((the text/text (text/subseq (the text/text document) ?start-index ?end-index))
                                                                    (the text/text (content-of (the tree/leaf document))))
                                                                   `((the string (subseq (the string document) ,?start-index ,?end-index))
                                                                     (the string (value-of (the json/string document))))))))
                                        (operation/show-context-sensitive-help
                                         (make-instance 'operation/show-context-sensitive-help
                                                        :commands (iter (for command :in (commands-of operation))
                                                                        (awhen (recurse (operation-of command))
                                                                          (collect (make-instance 'command
                                                                                                  :gesture (gesture-of command)
                                                                                                  :domain (domain-of command)
                                                                                                  :description (description-of command)
                                                                                                  :operation it))))))
                                        (operation/compound
                                         (bind ((operations (mapcar #'recurse (elements-of operation))))
                                           (unless (some 'null operations)
                                             (make-operation/compound operations)))))))
                             (recurse (operation-of input)))
                      (make-command (gesture-of input) it :domain (domain-of input) :description (description-of input)))
                    (make-command/nothing (gesture-of input)))))

(def reader json/array->tree/node (projection recursion input printer-iomap)
  (bind ((printer-input (input-of printer-iomap)))
    (merge-commands (gesture-case (gesture-of input)
                      ((gesture/keyboard/key-press :sdl-key-insert)
                       :domain "JSON" :help "Starts an object insertion into the elements of the JSON array"
                       :operation (bind ((elements-length (length (elements-of printer-input))))
                                    (make-operation/compound (list (make-operation/sequence/replace-element-range printer-input `((the sequence (subseq (the sequence document) ,elements-length ,elements-length))
                                                                                                                                  (the sequence (elements-of (the json/array document)))) (list (document/insertion)))
                                                                   (make-operation/replace-selection printer-input `((the string (subseq (the string document) 0 0))
                                                                                                                     (the string (value-of (the document/insertion document)))
                                                                                                                     (the document/insertion (elt (the sequence document) ,elements-length))
                                                                                                                     (the sequence (elements-of (the json/array document))))))))))
                    (pattern-case (reverse (selection-of printer-input))
                      (((the sequence (elements-of (the json/array document))) . ?rest)
                       (pattern-case (reverse (selection-of (elements-of printer-input)))
                         (((the ?element-type (elt (the sequence document) ?element-index)) . ?rest)
                          (bind ((output-operation (operation-of (recurse-reader recursion (make-command/nothing (gesture-of input)) (elt (child-iomaps-of printer-iomap) ?element-index)))))
                            (labels ((recurse (operation)
                                       (typecase operation
                                         (operation/replace-selection
                                          (make-operation/replace-selection printer-input
                                                                            (append (selection-of operation)
                                                                                    `((the ,?element-type (elt (the sequence document) ,?element-index))
                                                                                      (the sequence (elements-of (the json/array document)))))))
                                         (operation/replace-target
                                          (make-operation/replace-target printer-input
                                                                         (append (target-of operation)
                                                                                 `((the ,?element-type (elt (the sequence document) ,?element-index))
                                                                                   (the sequence (elements-of (the json/array document)))))
                                                                         (replacement-of operation)))
                                         (operation/sequence/replace-element-range
                                          (make-operation/sequence/replace-element-range printer-input
                                                                                         (append (target-of operation)
                                                                                                 `((the ,?element-type (elt (the sequence document) ,?element-index))
                                                                                                   (the sequence (elements-of (the json/array document)))))
                                                                                         (replacement-of operation)))
                                         (operation/compound
                                          (bind ((operations (mapcar #'recurse (elements-of operation))))
                                            (unless (some 'null operations)
                                              (make-operation/compound operations)))))))
                              (awhen (recurse output-operation)
                                (make-command (gesture-of input) it
                                              :domain (domain-of input)
                                              :description (description-of input)))))))))
                    (awhen (labels ((recurse (operation)
                                      (typecase operation
                                        (operation/quit operation)
                                        (operation/replace-selection
                                         (make-operation/replace-selection printer-input
                                                                           (pattern-case (reverse (selection-of operation))
                                                                             (((the tree/node document))
                                                                              '((the json/array document)))
                                                                             (((the sequence (children-of (the tree/node document)))
                                                                               (the ?child-type (elt (the sequence document) ?child-index))
                                                                               . ?rest)
                                                                              (bind ((child (elt (elements-of printer-input) ?child-index))
                                                                                     (input-operation (make-operation/replace-selection child (reverse ?rest)))
                                                                                     (output-operation (operation-of (recurse-reader recursion (make-command (gesture-of input) input-operation :domain (domain-of input) :description (description-of input)) (elt (child-iomaps-of printer-iomap) ?child-index)))))
                                                                                (append (selection-of output-operation)
                                                                                        `((the ,(form-type child) (elt (the sequence document) ,?child-index))
                                                                                          (the sequence (elements-of (the json/array document)))))))
                                                                             (?a
                                                                              (append (selection-of operation) `((the tree/node (printer-output (the json/array document) ,projection ,recursion))))))))
                                        (operation/sequence/replace-element-range
                                         (awhen (pattern-case (reverse (target-of operation))
                                                  (((the sequence (children-of (the tree/node document)))
                                                    (the ?child-type (elt (the sequence document) ?child-index))
                                                    . ?rest)
                                                   (bind ((child (elt (elements-of printer-input) ?child-index))
                                                          (input-operation (make-operation/sequence/replace-element-range child (reverse ?rest) (replacement-of operation)))
                                                          (output-operation (operation-of (recurse-reader recursion (make-command (gesture-of input) input-operation :domain (domain-of input) :description (description-of input)) (elt (child-iomaps-of printer-iomap) ?child-index)))))
                                                     (when (typep output-operation 'operation/sequence/replace-element-range)
                                                       (append (target-of output-operation)
                                                               `((the ,(form-type child) (elt (the sequence document) ,?child-index))
                                                                 (the sequence (elements-of (the json/array document))))))))
                                                  (?a
                                                   (append (target-of operation) `((the tree/node (printer-output (the json/array document) ,projection ,recursion))))))
                                           (make-operation/sequence/replace-element-range printer-input it (replacement-of operation))))
                                        (operation/show-context-sensitive-help
                                         (make-instance 'operation/show-context-sensitive-help
                                                        :commands (iter (for command :in (commands-of operation))
                                                                        (awhen (recurse (operation-of command))
                                                                          (collect (make-instance 'command
                                                                                                  :gesture (gesture-of command)
                                                                                                  :domain (domain-of command)
                                                                                                  :description (description-of command)
                                                                                                  :operation it))))))
                                        (operation/compound
                                         (bind ((operations (mapcar #'recurse (elements-of operation))))
                                           (unless (some 'null operations)
                                             (make-operation/compound operations)))))))
                             (recurse (operation-of input)))
                      (make-command (gesture-of input) it :domain (domain-of input) :description (description-of input)))
                    (make-command/nothing (gesture-of input)))))

(def reader json/object-entry->tree/node (projection recursion input printer-iomap)
  (bind ((printer-input (input-of printer-iomap)))
    (merge-commands (awhen (labels ((recurse (operation)
                                      (typecase operation
                                        (operation/quit operation)
                                        (operation/replace-selection
                                         (make-operation/replace-selection printer-input
                                                                           (pattern-case (reverse (selection-of operation))
                                                                             (((the tree/node document))
                                                                              '((the json/object-entry document)))
                                                                             (((the sequence (children-of (the tree/node document)))
                                                                               (the tree/leaf (elt (the sequence document) 0))
                                                                               (the text/text (content-of (the tree/leaf document)))
                                                                               (the text/text (text/subseq (the text/text document) ?character-index ?character-index)))
                                                                              `((the string (subseq (the string document) ,?character-index ,?character-index))
                                                                                (the string (key-of (the json/object-entry document)))))
                                                                             (((the sequence (children-of (the tree/node document)))
                                                                               (the ?child-type (elt (the sequence document) 1))
                                                                               . ?rest)
                                                                              (bind ((value (value-of printer-input))
                                                                                     (input-operation (make-operation/replace-selection value (reverse ?rest)))
                                                                                     (output-operation (operation-of (recurse-reader recursion (make-command (gesture-of input) input-operation :domain (domain-of input) :description (description-of input)) (elt (child-iomaps-of printer-iomap) 0)))))
                                                                                (append (selection-of output-operation)
                                                                                        `((the ,(form-type value) (value-of (the json/object-entry document)))))))
                                                                             (?a
                                                                              (append (selection-of operation) `((the tree/node (printer-output (the json/object-entry document) ,projection ,recursion))))))))
                                        (operation/sequence/replace-element-range
                                         (awhen (pattern-case (reverse (target-of operation))
                                                  (((the sequence (children-of (the tree/node document)))
                                                    (the tree/leaf (elt (the sequence document) 0))
                                                    (the text/text (content-of (the tree/leaf document)))
                                                    (the text/text (text/subseq (the text/text document) ?start-character-index ?end-character-index)))
                                                   `((the string (subseq (the string document) ,?start-character-index ,?end-character-index))
                                                     (the string (key-of (the json/object-entry document)))))
                                                  (((the sequence (children-of (the tree/node document)))
                                                    (the ?child-type (elt (the sequence document) ?child-index))
                                                    . ?rest)
                                                   (bind ((value (value-of printer-input))
                                                          (input-operation (make-operation/sequence/replace-element-range value (reverse ?rest) (replacement-of operation)))
                                                          (output-operation (operation-of (recurse-reader recursion (make-command (gesture-of input) input-operation :domain (domain-of input) :description (description-of input)) (elt (child-iomaps-of printer-iomap) 0)))))
                                                     (when (typep output-operation 'operation/sequence/replace-element-range)
                                                       (append (target-of output-operation)
                                                               `((the ,(form-type value) (value-of (the json/object-entry document)))))))))
                                           (make-operation/sequence/replace-element-range printer-input it (replacement-of operation))))
                                        (operation/show-context-sensitive-help
                                         (make-instance 'operation/show-context-sensitive-help
                                                        :commands (iter (for command :in (commands-of operation))
                                                                        (awhen (recurse (operation-of command))
                                                                          (collect (make-instance 'command
                                                                                                  :gesture (gesture-of command)
                                                                                                  :domain (domain-of command)
                                                                                                  :description (description-of command)
                                                                                                  :operation it))))))
                                        (operation/compound
                                         (bind ((operations (mapcar #'recurse (elements-of operation))))
                                           (unless (some 'null operations)
                                             (make-operation/compound operations)))))))
                             (recurse (operation-of input)))
                      (make-command (gesture-of input) it
                                    :domain (domain-of input)
                                    :description (description-of input)))
                    (make-command/nothing (gesture-of input)))))

(def reader json/object->tree/node (projection recursion input printer-iomap)
  (bind ((printer-input (input-of printer-iomap)))
    (merge-commands (awhen (labels ((recurse (operation)
                                      (typecase operation
                                        (operation/quit operation)
                                        (operation/replace-selection
                                         (make-operation/replace-selection printer-input
                                                                           (pattern-case (reverse (selection-of operation))
                                                                             (((the tree/node document))
                                                                              '((the json/object document)))
                                                                             (((the sequence (children-of (the tree/node document)))
                                                                               (the ?child-type (elt (the sequence document) ?child-index))
                                                                               . ?rest)
                                                                              (bind ((entry (elt (entries-of printer-input) ?child-index))
                                                                                     (input-operation (make-operation/replace-selection entry (reverse ?rest)))
                                                                                     (output-operation (operation-of (recurse-reader recursion (make-command (gesture-of input) input-operation :domain (domain-of input) :description (description-of input)) (elt (child-iomaps-of printer-iomap) ?child-index)))))
                                                                                (append (selection-of output-operation)
                                                                                        `((the json/object-entry (elt (the sequence document) ,?child-index))
                                                                                          (the sequence (entries-of (the json/object document)))))))
                                                                             (?a
                                                                              (append (selection-of operation) `((the tree/node (printer-output (the json/object document) ,projection ,recursion))))))))
                                        (operation/sequence/replace-element-range
                                         (awhen (pattern-case (reverse (target-of operation))
                                                  (((the sequence (children-of (the tree/node document)))
                                                    (the ?child-type (elt (the sequence document) ?child-index))
                                                    . ?rest)
                                                   (bind ((entry (elt (entries-of printer-input) ?child-index))
                                                          (input-operation (make-operation/sequence/replace-element-range entry (reverse ?rest) (replacement-of operation)))
                                                          (output-operation (operation-of (recurse-reader recursion (make-command (gesture-of input) input-operation :domain (domain-of input) :description (description-of input)) (elt (child-iomaps-of printer-iomap) ?child-index)))))
                                                     (when (typep output-operation 'operation/sequence/replace-element-range)
                                                       (append (target-of output-operation)
                                                               `((the json/object-entry (elt (the sequence document) ,?child-index))
                                                                 (the sequence (entries-of (the json/object document))))))))
                                                  (?a
                                                   (append (target-of operation) `((the tree/node (printer-output (the json/object document) ,projection ,recursion))))))
                                           (make-operation/sequence/replace-element-range printer-input it (replacement-of operation))))
                                        (operation/show-context-sensitive-help
                                         (make-instance 'operation/show-context-sensitive-help
                                                        :commands (iter (for command :in (commands-of operation))
                                                                        (awhen (recurse (operation-of command))
                                                                          (collect (make-instance 'command
                                                                                                  :gesture (gesture-of command)
                                                                                                  :domain (domain-of command)
                                                                                                  :description (description-of command)
                                                                                                  :operation it))))))
                                        (operation/compound
                                         (bind ((operations (mapcar #'recurse (elements-of operation))))
                                           (unless (some 'null operations)
                                             (make-operation/compound operations)))))))
                             (recurse (operation-of input)))
                      (make-command (gesture-of input) it
                                    :domain (domain-of input)
                                    :description (description-of input)))
                    (make-command/nothing (gesture-of input)))))
