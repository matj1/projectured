;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2009 by the authors.
;;;
;;; See LICENCE for details.

(in-package :projectured)

;;;;;;
;;; Projection

(def projection copying ()
  ())

;;;;;;
;;; Construction

(def (function e) make-projection/copying ()
  (make-projection 'copying))

;;;;;;
;;; Construction

(def (macro e) copying ()
  '(make-projection/copying))

;;;;;;
;;; IO map

(def iomap iomap/copying (iomap)
  ((slot-value-iomaps :type sequence)))

;;;;;;
;;; Printer

(def printer copying (projection recursion input input-reference)
  (etypecase input
    (null (make-iomap/object projection recursion input input-reference input))
    (symbol (make-iomap/object projection recursion input input-reference input))
    (number (make-iomap/object projection recursion input input-reference input))
    (string (make-iomap/object projection recursion input input-reference input))
    (pathname (make-iomap/object projection recursion input input-reference input))
    (style/color (make-iomap/object projection recursion input input-reference input))
    (style/font (make-iomap/object projection recursion input input-reference input))
    (cons
     (bind ((car-iomap (recurse-printer recursion (car input) `((car (the sequence document))
                                                                ,@(typed-reference (form-type input) input-reference))))
            (cdr-iomap (recurse-printer recursion (cdr input) `((cdr (the sequence document))
                                                                ,@(typed-reference (form-type input) input-reference))))
            (output (cons (output-of car-iomap) (output-of cdr-iomap))))
       (make-iomap/compound projection recursion input input-reference output
                            (list (make-iomap/object projection recursion input input-reference output) car-iomap cdr-iomap))))
    (standard-object
     (bind ((class (class-of input))
            (slot-value-iomaps (iter (for slot :in (class-slots class))
                                     (when (slot-boundp-using-class class input slot)
                                       (bind ((slot-reader (find-slot-reader class slot))
                                              (slot-value (slot-value-using-class class input slot)))
                                         (collect (recurse-printer recursion slot-value
                                                                   (if slot-reader
                                                                       `((,slot-reader (the ,(form-type input) document))
                                                                         ,@(typed-reference (form-type input) input-reference))
                                                                       `((slot-value (the ,(form-type input) document) ',(slot-definition-name slot))
                                                                         ,@(typed-reference (form-type input) input-reference)))))))))
            (output (prog1-bind clone (allocate-instance class)
                      (iter (for slot :in (class-slots class))
                            (for slot-value-iomap :in slot-value-iomaps)
                            (setf (slot-value-using-class class clone slot) (output-of slot-value-iomap))))))
       (make-iomap 'iomap/copying
                   :projection projection :recursion recursion
                   :input input :output output
                   :slot-value-iomaps slot-value-iomaps)))))

;;;;;;
;;; Reader

(def reader copying (projection recursion input printer-iomap)
  (declare (ignore projection))
  (bind ((printer-input (input-of printer-iomap))
         (class (class-of printer-input)))
    (make-command (gesture-of input)
                  (labels ((recurse (operation)
                             (typecase operation
                               (operation/quit operation)
                               (operation/replace-selection
                                (etypecase printer-input
                                  (standard-object
                                   (awhen (pattern-case (reverse (selection-of operation))
                                            (((the ?type (?reader (the ?input-type document))) . ?rest)
                                             (bind ((slot-index (position ?reader (class-slots class) :key (curry 'find-slot-reader class)))
                                                    (slot-value-iomap (elt (slot-value-iomaps-of printer-iomap) slot-index))
                                                    (input-slot-value-operation (make-operation/replace-selection (input-of slot-value-iomap) (butlast (selection-of operation)))))
                                               (append (selection-of (operation-of (recurse-reader recursion (make-command (gesture-of input) input-slot-value-operation) slot-value-iomap)))
                                                       (last (selection-of operation)))))
                                            (?a
                                             (selection-of operation)))
                                     (make-operation/replace-selection printer-input it)))
                                  (t
                                   (not-yet-implemented))))
                               (operation/sequence/replace-element-range
                                (etypecase printer-input
                                  (standard-object
                                   (awhen (pattern-case (reverse (target-of operation))
                                            (((the ?type (?reader (the ?input-type document))) . ?rest)
                                             (bind ((slot-index (position ?reader (class-slots class) :key (curry 'find-slot-reader class)))
                                                    (slot-value-iomap (elt (slot-value-iomaps-of printer-iomap) slot-index))
                                                    (input-slot-value-operation (make-operation/sequence/replace-element-range (input-of slot-value-iomap) (butlast (target-of operation)) (replacement-of operation)))
                                                    (output-slot-value-operation (operation-of (recurse-reader recursion (make-command (gesture-of input) input-slot-value-operation) slot-value-iomap))))
                                               (when (typep output-slot-value-operation 'operation/sequence/replace-element-range)
                                                 (append (target-of output-slot-value-operation)
                                                         (last (target-of operation)))))))
                                     (make-operation/sequence/replace-element-range printer-input it (replacement-of operation))))
                                  (t
                                   (not-yet-implemented))))
                               (operation/compound
                                (bind ((operations (mapcar #'recurse (elements-of operation))))
                                  (unless (some 'null operations)
                                    (make-operation/compound operations)))))))
                    (recurse (operation-of input))))))
