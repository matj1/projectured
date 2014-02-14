;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2009 by the authors.
;;;
;;; See LICENCE for details.

(in-package :projectured)

;;;;;;
;;; Projection

(def projection t/sequence->tree/node ()
  ())

(def projection t/object->tree/node ()
  ((slot-provider :type function)))

;;;;;;
;;; Construction

(def (function e) make-projection/t/sequence->tree/node ()
  (make-projection 't/sequence->tree/node))

(def (function e) make-projection/t/object->tree/node (&key slot-provider)
  (make-projection 't/object->tree/node :slot-provider (or slot-provider (compose 'class-slots 'class-of))))

;;;;;;
;;; Construction

(def (macro e) t/sequence->tree/node ()
  '(make-projection/t/sequence->tree/node))

(def (macro e) t/object->tree/node (&key slot-provider)
  `(make-projection/t/object->tree/node :slot-provider ,slot-provider))

;;;;;;
;;; Printer

(def printer t/sequence->tree/node (projection recursion input input-reference)
  (bind ((element-iomaps (iter (for index :from 0)
                               (for element :in-sequence input)
                               (collect (recurse-printer recursion element
                                                         `((elt (the ,(form-type input) document) ,index)
                                                           ,@(typed-reference (form-type input) input-reference))))))
         (output-selection (when (typep input 'selection/base)
                             (pattern-case (reverse (selection-of input))
                               (((the ?element-type (elt (the sequence document) ?index)) . ?rest)
                                (bind ((element-iomap (elt element-iomaps ?index))
                                       (element-iomap-output (output-of element-iomap)))
                                  (append (selection-of element-iomap-output)
                                          `((the ,(form-type element-iomap-output) (elt (the sequence document) 1))
                                            (the sequence (children-of (the tree/node document)))
                                            (the tree/node (elt (the sequence document) ,(1+ ?index)))
                                            (the sequence (children-of (the tree/node document)))))))
                               (((the tree/node (printer-output (the ?type document) ?projection ?recursion)) . ?rest)
                                (when (and (eq projection ?projection) (eq recursion ?recursion))
                                  (reverse ?rest))))))
         (output (if (emptyp input)
                     (tree/leaf (:selection output-selection)
                       (text/text (:selection (butlast output-selection))
                         (text/string "")))
                     (make-tree/node (list* (tree/leaf (:selection (butlast output-selection 2))
                                              (text/text (:selection (butlast output-selection 3))
                                                (text/string (if (consp input) "LIST" "SEQUENCE") :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/red*)))
                                            (iter (for index :from 0)
                                                  (for element-iomap :in element-iomaps)
                                                  (for element-iomap-output = (output-of element-iomap))
                                                  (collect (tree/node (:indentation 1 :separator (text/text () (text/string " " :font *font/ubuntu/monospace/regular/18*))
                                                                       :selection (butlast output-selection 2))
                                                             (tree/leaf (:selection (butlast output-selection 4))
                                                               (text/text (:selection (butlast output-selection 5))
                                                                 (text/string (write-to-string index) :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/magenta*)))
                                                             element-iomap-output))))
                                     :separator (text/text () (text/string " " :font *font/ubuntu/monospace/regular/18*))
                                     :selection output-selection))))
    (make-iomap/object projection recursion input input-reference output)))

(def printer t/object->tree/node (projection recursion input input-reference)
  (bind ((class (class-of input))
         (slots (funcall (slot-provider-of projection) input))
         (slot-readers (mapcar (curry 'find-slot-reader class) slots))
         (slot-iomaps (iter (for slot :in slots)
                            (for slot-reader :in slot-readers)
                            (collect (when (slot-boundp-using-class class input slot)
                                       (recurse-printer recursion (slot-value-using-class class input slot)
                                                        `((,slot-reader (the ,(form-type input) document))
                                                          ,@(typed-reference (form-type input) input-reference)))))))
         (output-selection (when (typep input 'selection/base)
                             (pattern-case (reverse (selection-of input))
                               (((the string (?slot-reader (the ?input-type document)))
                                 (the string (subseq (the string document) ?start-index ?end-index)))
                                (bind ((index (position ?slot-reader slot-readers)))
                                  (when index
                                    (bind ((slot-iomap (elt slot-iomaps index))
                                           (slot-iomap-output (output-of slot-iomap)))
                                      (append `((the text/text (text/subseq (the text/text document) ,(1+ ?start-index) ,(1+ ?end-index)))
                                                (the text/text (content-of (the tree/leaf document)))
                                                (the tree/leaf (elt (the sequence document) ,(* 2 (1+ index))))
                                                (the sequence (children-of (the tree/node document))))
                                              (selection-of slot-iomap-output))))))
                               (((the ?slot-value-type (?slot-reader (the ?input-type document))) . ?rest)
                                (bind ((index (position ?slot-reader slot-readers))
                                       (slot-iomap (elt slot-iomaps index))
                                       (slot-iomap-output (output-of slot-iomap)))
                                  (append (selection-of slot-iomap-output)
                                          `((the ,(if (typep slot-iomap-output 'tree/base)
                                                      (form-type slot-iomap-output)
                                                      'tree/leaf)
                                                 (elt (the sequence document) ,(* 2 (1+ index))))
                                            (the sequence (children-of (the tree/node document)))))))
                               (((the tree/node (printer-output (the ?type document) ?projection ?recursion)) . ?rest)
                                (when (and (eq projection ?projection) (eq recursion ?recursion))
                                  (reverse ?rest))))))
         (output (make-tree/node (list* (tree/leaf (:selection (butlast output-selection 2))
                                          (text/text (:selection (butlast output-selection 3))
                                            (text/string (symbol-name (class-name (class-of input))) :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/red*)))
                                        (iter (for slot :in slots)
                                              (for slot-iomap :in slot-iomaps)
                                              (collect (tree/leaf (:selection (butlast output-selection 2) :indentation 1)
                                                         (text/text (:selection (butlast output-selection 3))
                                                           (make-text/string (symbol-name (slot-definition-name slot)) :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/blue*))))
                                              (when (slot-boundp-using-class class input slot)
                                                (bind ((slot-iomap-output (output-of slot-iomap)))
                                                  (if (typep slot-iomap-output 'tree/base)
                                                      (progn
                                                        (when (typep slot-iomap-output 'tree/node)
                                                          (setf (indentation-of slot-iomap-output) 2))
                                                        (collect slot-iomap-output))
                                                      (progn
                                                        (setf (selection-of slot-iomap-output) (butlast output-selection 3))
                                                        (collect (tree/leaf (:selection (butlast output-selection 2) :opening-delimiter (text/text () (text/string " " :font *font/ubuntu/monospace/regular/18*)))
                                                                   slot-iomap-output))))))))
                                 :selection output-selection)))
    (make-iomap/object projection recursion input input-reference output)))

;;;;;;
;;; Reader

(def reader t/sequence->tree/node (projection recursion input printer-iomap)
  (bind ((printer-input (input-of printer-iomap)))
    (merge-commands (awhen (labels ((recurse (operation)
                                      (typecase operation
                                        (operation/quit operation)
                                        (operation/replace-selection
                                         (awhen (pattern-case (reverse (selection-of operation))
                                                  (?a
                                                   (append (selection-of operation) `((the tree/node (printer-output (the ,(form-type printer-input)  document) ,projection ,recursion))))))
                                           (make-operation/replace-selection printer-input it)))
                                        (operation/sequence/replace-element-range)
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

(def reader t/object->tree/node (projection recursion input printer-iomap)
  (bind ((printer-input (input-of printer-iomap)))
    (merge-commands (awhen (labels ((recurse (operation)
                                      (typecase operation
                                        (operation/quit operation)
                                        (operation/replace-selection
                                         (awhen (pattern-case (reverse (selection-of operation))
                                                  (((the sequence (children-of (the tree/node document)))
                                                    (the tree/leaf (elt (the sequence document) ?child-index))
                                                    (the text/text (content-of (the tree/leaf document)))
                                                    (the text/text (text/subseq (the text/text document) ?start-index ?end-index)))
                                                   (if (and (evenp ?child-index) (> ?child-index 0))
                                                       (bind ((slot-index (- (/ ?child-index 2) 1))
                                                              (slots (funcall (slot-provider-of projection) printer-input))
                                                              (slot-reader (find-slot-reader (class-of printer-input) (elt slots slot-index))))
                                                         `((the string (subseq (the string document) ,(1- ?start-index) ,(1- ?end-index)))
                                                           (the string (,slot-reader (the ,(form-type printer-input) document)))))
                                                       (append (selection-of operation) `((the tree/node (printer-output (the ,(form-type printer-input)  document) ,projection ,recursion))))))
                                                  (?a
                                                   (append (selection-of operation) `((the tree/node (printer-output (the ,(form-type printer-input)  document) ,projection ,recursion))))))
                                           (make-operation/replace-selection printer-input it)))
                                        (operation/sequence/replace-element-range
                                         (awhen (pattern-case (reverse (target-of operation))
                                                  (((the sequence (children-of (the tree/node document)))
                                                    (the tree/leaf (elt (the sequence document) ?child-index))
                                                    (the text/text (content-of (the tree/leaf document)))
                                                    (the text/text (text/subseq (the text/text document) ?start-index ?end-index)))
                                                   (when (and (evenp ?child-index) (> ?child-index 0))
                                                     (bind ((slots (funcall (slot-provider-of projection) printer-input))
                                                            (slot-index (- (/ ?child-index 2) 1))
                                                            (class (class-of printer-input))
                                                            (slot (elt slots slot-index))
                                                            (slot-reader (find-slot-reader class slot))
                                                            (length (+ 2 (length (slot-value-using-class class printer-input slot)))))
                                                       (when (and (< 0 ?start-index length) (< 0 ?end-index length))
                                                         `((the string (subseq (the string document) ,(1- ?start-index) ,(1- ?end-index)))
                                                           (the string (,slot-reader (the ,(form-type printer-input) document)))))))))
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