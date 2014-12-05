;;; -*- mode: Lisp; Syntax: Common-Lisp; -*-
;;;
;;; Copyright (c) 2009 by the authors.
;;;
;;; See LICENCE for details.

(in-package :projectured)

;;;;;;
;;; Document

(def function make-initial-document/welcome-page ()
  (book/book (:title "Welcome to ProjecturEd" :selection '((the string (subseq (the string document) 0 0)) (the string (title-of (the book/book document)))) :authors (list "Levente Mészáros"))
    (book/chapter (:title "Introduction")
      (book/paragraph ()
        (text/text ()
          (text/string "ProjecturEd is a generic purpose projectional editor. It provides editing for many kind of documents, it even supports mixed documents combining different domains. Iit also allows editing through multiple different views, sorting, filtering, etc." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*))))
    (book/chapter (:title "Cheet Sheet" :selection '((the string (subseq (the string document) 0 0)) (the string (title-of (the book/chapter document)))))
      (book/paragraph (:selection '((the text/text (text/subseq (the text/text document) 0 0)) (the text/text (content-of (the book/paragraph document)))))
        (text/text (:selection '((the text/text (text/subseq (the text/text document) 0 0))))
          (text/string "Use the CURSOR keys to navigate around as you would do in a text editor. Use the mouse wheel to scroll vertically and SHIFT + mouse wheel to scroll horizontally. Type in text wherever you feel it is appropriate. Press CONTROL + H to get context sensitive help. Press INSERT to insert new parts into the document in a generic way. Finally, press ESC to quit." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*))))
    (book/chapter (:title "Home Page")
      (book/paragraph ()
        (text/text ()
          (text/string "Visit " :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
          (text/string "http://projectured.org" :font *font/ubuntu/regular/18* :font-color *color/solarized/blue*)
          (text/string " or " :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
          (text/string "http://github.com/projectured/projectured" :font *font/ubuntu/regular/18* :font-color *color/solarized/blue*)
          (text/string " for more information." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*))))))

(def function make-initial-document/json-example ()
  (book/book (:title "A JSON Example" :selection '((the string (subseq (the string document) 0 0)) (the string (title-of (the book/book document)))))
    (book/chapter (:title "Cheet Sheet")
      (book/paragraph ()
        (text/text ()
          (text/string "Press \" to insert a new JSON string. Press [ to insert a new JSON array. Press { to insert a new JSON object." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*))))
    (book/chapter (:title "Example")
      (book/paragraph ()
        (text/text ()
          (text/string "Here is a simple contact list in JSON format." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
      (json/array ()
        (json/object ()
          ("name" (json/string () "Levente Mészáros"))
          ("sex" (json/string () "male"))
          ("born" (json/number () 1975)))
        (json/object ()
          ("name" (json/string () "Attila Lendvai"))
          ("sex" (json/string () "male"))
          ("born" (json/number () 1978)))))))

(def function make-initial-document/xml-example ()
  (book/book (:title "An XML Example" :selection '((the string (subseq (the string document) 0 0)) (the string (title-of (the book/book document)))))
    (book/chapter (:title "Cheet Sheet")
      (book/paragraph ()
        (text/text ()
          (text/string "Press < to insert a new XML element. Press \" to insert a new XML text." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*))))
    (book/chapter (:title "Example")
      (book/paragraph ()
        (text/text ()
          (text/string "Here is a simple HTML web page in XML format." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
      (xml/element ("html" ())
        (xml/element ("head" ())
          (xml/element ("title" ())
            (xml/text () "Hello World")))
        (xml/element ("body" ())
          (xml/element ("h1" ((xml/attribute () "id" "e0")))
            (xml/text () "Hello World"))
          (xml/element ("p" ((xml/attribute () "id" "e1")))
            (xml/text () "A simple web page.")))))))

(def function make-initial-document/common-lisp-example ()
  (book/book (:title "A Common Lisp Example")
    (book/chapter (:title "Cheet Sheet")
      (book/paragraph ()
        (text/text ()
          (text/string "Press ( to insert a new Common Lisp function application." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*))))
    (book/chapter (:title "Example")
      (book/paragraph ()
        (text/text ()
          (text/string "Here is a Common Lisp FACTORIAL function." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
      (bind ((factorial-argument (make-common-lisp/required-function-argument (make-lisp-form/symbol* 'n)))
             (factorial-function (make-common-lisp/function-definition (make-lisp-form/symbol "FACTORIAL" "PROJECTURED")
                                                                       (list factorial-argument)
                                                                       nil
                                                                       :allow-other-keys #f
                                                                       :documentation "Computes the factorial of N")))
        (setf (body-of factorial-function)
              (list (make-common-lisp/if (make-common-lisp/application (make-lisp-form/symbol* '<)
                                                                       (list (make-common-lisp/variable-reference factorial-argument)
                                                                             (make-common-lisp/constant 2)))
                                         (make-common-lisp/constant 1)
                                         (make-common-lisp/application (make-lisp-form/symbol* '*)
                                                                       (list (make-common-lisp/variable-reference factorial-argument)
                                                                             (make-common-lisp/application (make-common-lisp/function-reference factorial-function)
                                                                                                           (list (make-common-lisp/application
                                                                                                                  (make-lisp-form/symbol* '-)
                                                                                                                  (list (make-common-lisp/variable-reference factorial-argument)
                                                                                                                        (make-common-lisp/constant 1))))))))))
        factorial-function))))

(def function make-initial-document/empty-example ()
  (document/nothing))

(def function make-initial-document/web-example ()
  (bind ((chart-page-path (make-adjustable-string "/page"))
         (chart-css-path (make-adjustable-string "/style"))
         (chart-data-path (make-adjustable-string "/data"))
         (chart-script-path (make-adjustable-string "/script"))
         (trace-amounts (make-common-lisp/comment
                         (text/text ()
                           (text/string "This part contains trace amounts of " :font projectured::*font/ubuntu/regular/18* :font-color *color/solarized/gray*)
                           (image/file () (resource-pathname "image/lisp-flag.jpg")))))
         (chart-script (make-javascript/statement/top-level
                        (list (make-javascript/expression/method-invocation
                               (make-javascript/expression/variable-reference "google")
                               "load"
                               (list (make-javascript/literal/string "visualization")
                                     (make-javascript/literal/string "1")
                                     (json/object ()
                                       ("packages" (json/array () (json/string () "corechart"))))))
                              (make-javascript/expression/method-invocation
                               (make-javascript/expression/variable-reference "google")
                               "setOnLoadCallback"
                               (list (make-javascript/expression/variable-reference "drawPieChart")))
                              (make-javascript/definition/function
                               "drawPieChart"
                               nil
                               (make-javascript/statement/block
                                (list (make-javascript/definition/variable
                                       "json"
                                       (make-javascript/expression/property-access
                                        (make-javascript/expression/method-invocation
                                         (make-javascript/expression/variable-reference "$")
                                         "ajax"
                                         (list (json/object ()
                                                 ("async" (json/boolean () #f))
                                                 ("url" (json/string () chart-data-path))
                                                 ("dataType" (json/string () "json")))))
                                        "responseText"))
                                      (make-javascript/definition/variable
                                       "data"
                                       (make-javascript/expression/constuctor-invocation
                                        (make-javascript/expression/property-access
                                         (make-javascript/expression/property-access
                                          (make-javascript/expression/variable-reference "google")
                                          "visualization")
                                         "DataTable")
                                        (list (make-javascript/expression/variable-reference "json"))))
                                      (make-javascript/definition/variable
                                       "chart"
                                       (make-javascript/expression/constuctor-invocation
                                        (make-javascript/expression/property-access
                                         (make-javascript/expression/property-access
                                          (make-javascript/expression/variable-reference "google")
                                          "visualization")
                                         "PieChart")
                                        (list (make-javascript/expression/method-invocation
                                               (make-javascript/expression/variable-reference "document")
                                               "getElementById"
                                               (list (make-javascript/literal/string "pie"))))))
                                      (make-javascript/expression/method-invocation
                                       (make-javascript/expression/variable-reference "chart")
                                       "draw"
                                       (list (make-javascript/expression/variable-reference "data")
                                             (json/object ()
                                               ("title" (json/string () "Daily Activities"))
                                               ("is3D" (json/boolean () #t)))))))))))
         (dispatch-table (table/table ()
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string "HTTP request" :font *font/ubuntu/monospace/bold/18* :font-color *color/solarized/gray*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "HTTP response" :font *font/ubuntu/monospace/bold/18* :font-color *color/solarized/gray*))))
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string chart-page-path :font *font/default* :font-color *color/solarized/blue*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "the HTML page that contains the pie chart" :font *font/default* :font-color *color/solarized/gray*))))
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string chart-css-path :font *font/default* :font-color *color/solarized/blue*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "the CSS stylesheet that contains the page style" :font *font/default* :font-color *color/solarized/gray*))))
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string chart-script-path :font *font/default* :font-color *color/solarized/blue*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "the JavaScript that dynamically creates the pie chart" :font *font/default* :font-color *color/solarized/gray*))))
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string chart-data-path :font *font/default* :font-color *color/solarized/blue*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "the JSON data that is displayed by the pie chart" :font *font/default* :font-color *color/solarized/gray*))))
                           (table/row ()
                             (table/cell ()
                               (text/text ()
                                 (text/string "<otherwise>" :font *font/default* :font-color *color/solarized/blue*)))
                             (table/cell ()
                               (text/text ()
                                 (text/string "the HTML error page" :font *font/default* :font-color *color/solarized/gray*))))))
         (chart-css (css/rule ("h1")
                      (css/attribute () "color" "#DC322F")
                      (css/attribute () "text-align" "center")))
         (chart-page (xml/element ("html" ())
                       (xml/element ("head" ())
                         (xml/element ("title" nil)
                           (xml/text () "Pie Chart Demo"))
                         (xml/element ("link" ((xml/attribute () "type" "text/css") (xml/attribute () "rel" "stylesheet") (xml/attribute () "href" chart-css-path))))
                         (xml/element ("script" ((xml/attribute () "type" "text/javascript") (xml/attribute () "src" "https://www.google.com/jsapi"))))
                         (xml/element ("script" ((xml/attribute () "type" "text/javascript") (xml/attribute () "src" "https://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"))))
                         (xml/element ("script" ((xml/attribute () "type" "text/javascript") (xml/attribute () "src" chart-script-path)))))
                       (xml/element ("body" ())
                         (xml/element ("h1" ())
                           (xml/text () "Pie Chart Demo"))
                         (xml/element ("div" ((xml/attribute () "id" "pie") (xml/attribute () "style" "width: 800px; height: 600px;")))))))
         (chart-data (json/object ()
                       ("cols" (json/array ()
                                 (json/object ()
                                   ("label" (json/string () "Task"))
                                   ("type" (json/string () "string")))
                                 (json/object ()
                                   ("label" (json/string () "Hours per Day"))
                                   ("type" (json/string () "number")))))
                       ("rows" (json/array ()
                                 (json/object ()
                                   ("c" (json/array ()
                                          (json/object ()
                                            ("v" (json/string () "Work")))
                                          (json/object ()
                                            ("v" (json/number () 11))))))
                                 (json/object ()
                                   ("c" (json/array ()
                                          (json/object ()
                                            ("v" (json/string () "Eat")))
                                          (json/object ()
                                            ("v" (json/number () 2))))))
                                 (json/object ()
                                   ("c" (json/array ()
                                          (json/object ()
                                            ("v" (json/string () "Commute")))
                                          (json/object ()
                                            ("v" (json/number () 2))))))
                                 (json/object ()
                                   ("c" (json/array ()
                                          (json/object ()
                                            ("v" (json/string () "Watch TV")))
                                          (json/object ()
                                            ("v" (json/number () 2))))))
                                 (json/object ()
                                   ("c" (json/array ()
                                          (json/object ()
                                            ("v" (json/string () "Sleep")))
                                          (json/object ()
                                            ("v" (json/number () 7))))))))))
         (request-variable (make-common-lisp/required-function-argument (make-lisp-form/symbol* 'request)))
         (path-variable (make-common-lisp/lexical-variable-binding (make-lisp-form/symbol* 'path) (make-common-lisp/application (make-lisp-form/symbol "RAW-URI-OF" "HU.DWIM.WEB-SERVER")
                                                                                                                                (list (make-common-lisp/variable-reference request-variable)))))
         (error-page (xml/element ("html" ())
                       (xml/element ("head" ())
                         (xml/element ("title" ())
                           (xml/text () "Error 404 (Not Found)")))
                       (xml/element ("body" ())
                         (xml/element ("p" ())
                           (xml/text () "We are sorry, the '")
                           #+nil (xml/element ("i" ()) (make-common-lisp/progn (list trace-amounts (make-common-lisp/application (make-lisp-form/symbol* 'write-string) (list (make-common-lisp/variable-reference path-variable))))))
                           (xml/text () "' page is not found.")))))
         (server-variable (make-common-lisp/special-variable-definition (make-lisp-form/symbol "*DEMO-SERVER*" "PROJECTURED.TEST")
                                                                        (make-common-lisp/application (make-lisp-form/symbol* 'make-instance)
                                                                                                      (list #+nil ;; TODO:
                                                                                                            (make-common-lisp/constant (find-symbol "SERVER" "HU.DWIM.WEB-SERVER"))
                                                                                                            (make-common-lisp/constant :host) (make-common-lisp/variable-reference (make-common-lisp/special-variable-definition (make-lisp-form/symbol "+ANY-HOST+" "IOLIB.SOCKETS") nil))
                                                                                                            (make-common-lisp/constant :port) (make-common-lisp/constant 8080)
                                                                                                            (make-common-lisp/constant :handler)
                                                                                                            (make-common-lisp/lambda-function nil (list (make-common-lisp/application (make-lisp-form/symbol "SEND-RESPONSE" "HU.DWIM.WEB-SERVER")
                                                                                                                                                                                      (list (make-common-lisp/application (make-lisp-form/symbol "MAKE-FUNCTIONAL-RESPONSE*" "HU.DWIM.WEB-SERVER")
                                                                                                                                                                                                                          (list (make-common-lisp/lambda-function nil (list (make-common-lisp/application (make-lisp-form/symbol* 'process-http-request) (list (make-common-lisp/variable-reference (make-common-lisp/special-variable-definition (make-lisp-form/symbol "*REQUEST*" "HU.DWIM.WEB-SERVER") nil))))))))))))))))
         (process-http-function (make-common-lisp/function-definition (make-lisp-form/symbol* 'process-http-request)
                                                                      (list request-variable)
                                                                      (list (make-common-lisp/comment
                                                                             (text/text ()
                                                                               (text/string "dispatch on the path of the incoming HTTP request according to the following table" :font *font/ubuntu/monospace/regular/18* :font-color *color/solarized/gray*)
                                                                               (text/newline)))
                                                                            dispatch-table
                                                                            (make-common-lisp/let (list path-variable (make-common-lisp/lexical-variable-binding (make-lisp-form/symbol* '*standard-output*) (make-common-lisp/application (make-lisp-form/symbol "CLIENT-STREAM-OF" "HU.DWIM.WEB-SERVER")
                                                                                                                                                                                                                                           (list (make-common-lisp/variable-reference request-variable)))))
                                                                                                  (list (make-common-lisp/if (make-common-lisp/application (make-lisp-form/symbol* 'string=)
                                                                                                                                                           (list (make-common-lisp/constant chart-page-path)
                                                                                                                                                                 (make-common-lisp/variable-reference path-variable)))
                                                                                                                             chart-page
                                                                                                                             (make-common-lisp/if (make-common-lisp/application (make-lisp-form/symbol* 'string=)
                                                                                                                                                                                (list (make-common-lisp/constant chart-css-path)
                                                                                                                                                                                      (make-common-lisp/variable-reference path-variable)))
                                                                                                                                                  chart-css
                                                                                                                                                  (make-common-lisp/if (make-common-lisp/application (make-lisp-form/symbol* 'string=)
                                                                                                                                                                                                     (list (make-common-lisp/constant chart-script-path)
                                                                                                                                                                                                           (make-common-lisp/variable-reference path-variable)))
                                                                                                                                                                       chart-script
                                                                                                                                                                       (make-common-lisp/if (make-common-lisp/application (make-lisp-form/symbol* 'string=)
                                                                                                                                                                                                                          (list (make-common-lisp/constant chart-data-path)
                                                                                                                                                                                                                                (make-common-lisp/variable-reference path-variable)))
                                                                                                                                                                                            chart-data
                                                                                                                                                                                            error-page)))))))
                                                                      :allow-other-keys #f
                                                                      :documentation nil)))
    (book/book (:title "A Web Service Demo" :authors (list "Levente Mészáros"))
      #+nil
      (book/chapter (:title "Problem Description")
        (book/paragraph ()
          (text/text ()
            (text/string "This example demonstrates mixing multiple different problem domains in the same document. The document contains" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string " Common Lisp, HTML, CSS, JavaScript, JSON, table, image and styled text" :font projectured::*font/ubuntu/italic/18* :font-color *color/solarized/violet*)
            (text/string " nested into each other. It describes a web service implemented as a single Common Lisp function that processes HTTP requests. When the function receives a request to the '" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string chart-page-path :font *font/ubuntu/italic/18* :font-color *color/solarized/violet*)
            (text/string "' path it sends an HTML page in response. This page contains a pie chart that utilizes the Google Charts JavaScript API. When the browser displays the pie chart it sends another request to the '" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string chart-data-path :font *font/ubuntu/italic/18* :font-color *color/solarized/violet*)
            (text/string "' path using JavaScript. For this request the web service returns another document in JSON format that provides the data for the pie chart. For all other unknown requests the web service sends an HTML error page. The following screenshot shows how the pie chart should look like." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/newline)
            (image/file () (resource-pathname "image/pie.png"))
            (text/newline)
            (text/string "This example uses a compound projection that displays all used domains in their natural notation. Proper indentation and syntax highlight are automatically provided without inserting escape sequences that would make reading harder. Note that the edited document" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string " is not text" :font projectured::*font/ubuntu/italic/18* :font-color *color/solarized/violet*)
            (text/string " even though it looks like. It's a complex domain specific data structure that precisely captures the intentions. The projections keep track of what is what to make navigation and editing possible." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*))))
      (book/chapter (:title "Chart Page")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the chart page" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        chart-page)
      #+nil
      (book/chapter (:title "Stylesheet")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the stylesheet" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        chart-css)
      #+nil
      (book/chapter (:title "JavaScript Program")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the client side program" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        chart-script)
      (book/chapter (:title "Chart Data")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the chart data" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        chart-data)
      (book/chapter (:title "Error Page")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the error page" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        error-page)
      #+nil
      (book/chapter (:title "Dispatch Table")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the server side dispatch table" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        dispatch-table)
      #+nil
      (book/chapter (:title "Web Server")
        (book/paragraph ()
          (text/text ()
            (text/string "Evaluating the following Common Lisp code creates the web server and stores it in a global variable." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        (make-evaluator/evaluator server-variable :on-demand #t)
        (book/paragraph ()
          (text/text ()
            (text/string "Evaluating the following Common Lisp code starts up the web server." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        (make-evaluator/evaluator (make-common-lisp/application (make-lisp-form/symbol "STARTUP-SERVER" "HU.DWIM.WEB-SERVER") (list (make-common-lisp/variable-reference server-variable))) :on-demand #t)
        (book/paragraph ()
          (text/text ()
            (text/string "Evaluating the following Common Lisp code shuts down the web server." :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        (make-evaluator/evaluator (make-common-lisp/application (make-lisp-form/symbol "SHUTDOWN-SERVER" "HU.DWIM.WEB-SERVER") (list (make-common-lisp/variable-reference server-variable))) :on-demand #t))
      #+nil
      (book/chapter (:title "Putting Together the Server Program")
        (book/paragraph ()
          (text/text ()
            (text/string "This is the server side program" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)))
        (make-evaluator/evaluator process-http-function :on-demand #t))
      (book/chapter (:title "Resources")
        (book/paragraph ()
          (text/text ()
            (text/string "You can read more about" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string " ProjecturEd" :font *font/ubuntu/italic/18* :font-color *color/solarized/violet*)
            (text/string " at" :font *font/ubuntu/regular/18* :font-color *color/solarized/content/darker*)
            (text/string " http://projectured.org" :font *font/ubuntu/regular/18* :font-color *color/solarized/violet*)))))))

(def function make-initial-document ()
  (workbench/workbench ()
    (workbench/navigator ()
      (make-file-system/pathname (resource-pathname "example/")))
    (workbench/editor ()
      (workbench/document (:title "Web" :filename (resource-pathname "example/web-example.pred"))
        (make-initial-document/web-example))
      (workbench/document (:title "Welcome" :filename (resource-pathname "example/welcome-page.pred"))
        (make-initial-document/welcome-page))
      (workbench/document (:title "XML" :filename (resource-pathname "example/xml-example.pred"))
        (make-initial-document/xml-example))
      (workbench/document (:title "JSON" :filename (resource-pathname "example/json-example.pred"))
        (make-initial-document/json-example))
      (workbench/document (:title "Common Lisp" :filename (resource-pathname "example/json-example.pred"))
        (make-initial-document/common-lisp-example))
      (workbench/document (:title "Web" :filename (resource-pathname "example/web-example.pred"))
        (make-initial-document/web-example))
      (workbench/document (:title "Empty" :filename (resource-pathname "example/empty-example.pred"))
        (make-initial-document/empty-example)))))
