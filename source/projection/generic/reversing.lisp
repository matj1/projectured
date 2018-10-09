;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) by the authors.
;;;
;;; See LICENCE for details.

(in-package :projectured)

;;;;;;
;;; Projection

(def projection reversing ()
  ())

;;;;;;
;;; Construction

(def function make-projection/reversing ()
  (make-projection 'reversing))

;;;;;;
;;; Construction

(def macro reversing ()
  `(make-projection/reversing))

;;;;;;
;;; Printer

(def printer reversing ()
  (bind ((element-iomaps (iter (for index :from 0)
                               (for element :in-sequence -input-)
                               (collect (recurse-printer -recursion- element `((elt (the sequence document) ,index)
                                                                               ,@(typed-reference (document-type -input-) -input-reference-))))))
         (output (etypecase -input-
                   (collection/sequence
                       (bind ((output-selection (reference-case (selection-of -input-)
                                                  (((the ?element-type (elt (the sequence document) ?element-index))
                                                    . ?rest)
                                                   (append `((the ,?element-type (elt (the sequence document) ,(- (length (elements-of -input-)) ?element-index 1)))) ?rest)))))
                         (make-collection/sequence (reverse (mapcar 'output-of element-iomaps)) :selection output-selection)))
                   (sequence (reverse (mapcar 'output-of element-iomaps))))))
    (make-iomap -projection- -recursion- -input- -input-reference- output)))

;;;;;;
;;; Reader

(def reader reversing ()
  (awhen (labels ((recurse (operation)
                    (typecase operation
                      (operation/quit operation)
                      (operation/functional operation)
                      (operation/replace-selection
                       (awhen (when (typep -printer-input- 'collection/sequence)
                                (reference-case (selection-of operation)
                                  (((the ?element-type (elt (the sequence document) ?element-index)) . ?rest)
                                   (append `((the ,?element-type (elt (the sequence document) ,(- (length (elements-of -printer-input-)) ?element-index 1)))) ?rest))))
                         (make-operation/replace-selection it)))
                      (operation/sequence/replace-range
                       (awhen (when (typep -printer-input- 'collection/sequence)
                                (reference-case (selection-of operation)
                                  (((the ?element-type (elt (the sequence document) ?element-index)) . ?rest)
                                   (append `((the ,?element-type (elt (the sequence document) ,(- (length (elements-of -printer-input-)) ?element-index 1)))) ?rest))))
                         (make-operation/sequence/replace-range it (replacement-of operation))))
                      (operation/compound
                       (bind ((operations (mapcar #'recurse (elements-of operation))))
                         (unless (some 'null operations)
                           (make-operation/compound operations)))))))
           (recurse (operation-of -input-)))
    (make-command -gesture- it
                  :domain (domain-of -input-)
                  :description (description-of -input-))))
