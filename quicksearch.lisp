

;;;; ================================================================================
;;;;
;;;;                      Title: Quicksearch  -  From tutorial
;;;;                    Created: 2025-10-26
;;;;   Original Tutorial Author: Vincent Dardel (https://dev.to/vindarel)
;;;;         Quicksearch Author: Robert Taylor             
;;;;                    License: GPLv3 or Later
;;;;
;;;; --------------------------------------------------------------------------------
;;;;  (c) Copyright 2025-Current by Robert Taylor
;;;; ================================================================================


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; SECTION 00 - Notes
;;; --
;;; General notes for review.  
;;;

#|

This is an attempt to test a quicksearch technique demonstrated in the following tutorial:

Tutorial Link: https://web-apps-in-lisp.github.io/isomorphic-web-frameworks/clog/index.html
Author of the tutorial: https://github.com/sponsors/vindarel/

Almost no changes were made to the code, so all the code, comments are by Vincent Dardel.
I wanted to go through the tutorial, implement the code and see how a quick search based
on keystroke input works, package it up and prepare it for adding features.

If any, the following updates were made to the tutorials

1) A system was created for the demo.

2) For the layout we create a single div to contain the whole application. 
   Within that div we create two divs (rows), one will contain the menu and one
   will to contain the application body.Not strickly necessary for a trivial demo but
   useful to explore a "standardized" layout approach.

3) For style we include some fonts and a bit of colour to make things interesting.

4) For the code, it is almost verbatim copied from the tutorial above.

5) For the comments we keep things as standard as possible minus the use of single ";"
   to delimit single line comments. We use ";;" for single line comments for aesthetic
   reasons.

6) For code block delimiters we use EXCESSIVE "top of the block" and "bottom of the block"
   comment segments. In part it helps the author (me) see clearly defined code blocks as
   well as provide indication of where a program would be split into separate files 
   (one block per file) if it ever become complex enough and warrant that type of 
   organization. Not necessary for a trivial demo but it is helpful to keep comment 
   standards consistent accross project.

7) SPECIAL NOTE: If you get a chance, you should work through the original tutorial 
   linked above because it demonstrates the use of of live coding directly in the CLOG 
   framework. CLOG is a powerful and mature framework with many features the live coding 
   feature should be experienced by everyone. I created a package for the purposes of
   testing.

8) Fonts used: Pistara Medium, Soda Fountain, Montserrat, Roboto, Headstay, Barking Cat and Bangers

IDEAS - Possible future todo items for the tutorials:

* Add pagination.
* Add some unnecessary but fun logo animation.
* Add an easter egg or two.
* Add Sqlite3 search feature.

|#

;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; SECTION 01 - Application Config
;;; --
;;; General application config.
;;;

(defpackage #:quicksearch
            (:use #:cl #:clog #:clog-web #:str)
            (:export start-app))

(in-package :quicksearch)

(defun start-app ()
       (initialize 'on-new-window :static-root (merge-pathnames "./www/" (asdf:system-source-directory :quicksearch)))
       (open-browser))

;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; SECTION 02 - Resources
;;; --
;;; External resources such as css, js, fonts, etc.
;;;

(defun f-config-css-fonts (this)
       (load-css (html-document this) "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" )
       (load-css (html-document this) "/css/quicsearch.css" ))

(defun f-clear (this)
       (setf (text this) ""))

(defun f-config-bodycolor (this-location this-color)
       (setf (background-color this-location) this-color))

;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; SECTION 03 - On Load
;;; --
;;; Everything necessary to load up the app.  
;;;

(defun on-new-window (body)
       ;; Config - set the background of the application to this default color.
       (f-config-bodycolor body "#c85007")
       ;; Add the clog-web look and feel (W3CSS)
       (clog-web-initialize body)
       ;; Load up the csss fonts that we need for the app.
       (f-config-css-fonts body)
       ;; We are going to use only a single div for the whole app window to have full control over the entire applicaiton frame.
       (let* (
               (container-main (create-div body ))
             )
             ;; Call the view, render into container-main
             (f-view-main container-main)  
             ) ;; let*
       ) ;;defun

;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; SECTION 04 - Views
;;; --
;;; Create all the views. The demo only needs one view, but for a complex app this becomes useful.  
;;;

(defun f-view-main (this-container)
       (let* (
                (frame-menu (create-div this-container :class "w3-padding-bottom w3-margin-bottom " :content ""  :style "z-index:1000; display:flex; flex-direction:column; justify-content: center; align-items: center;"))
                (frame-app (create-div this-container :class "" :style "display:flex; flex-direction:row; justify-content:center; " ))
                
                (frame-app-container (create-div frame-app :class "" :style "width:600px; display:flex; flex-direction:column; justify-content:start; "))
                ;; (panel-row-search (create-div frame-app-container :class "" ))
                (panel-row-results (create-div frame-app-container :class "" ))
                
                (content-instructions (create-div panel-row-results :class "w3-text-white w3-margin-bottom " :style "text-align:left;" ))
                (content-results (create-div panel-row-results :class "w3-padding-large " :style " display:flex; flex-direction:column; justify-content:start; align-items:center; " ))
             )
             ;; Generate products (list).
             (generate-test-products)
             ;; Load the menu.
             (menu frame-menu)
             ;; Load the instructions text.
             (instructions content-instructions)
             ;; Display some products.
             (add-products content-results)
             ) ;; let*
       ) ;; defun

;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; SECTION 05 - Tutorial
;;; --
;;; This section contains all of the code from the tutorial.  If you wanted to use the
;;; the CLOG live coding feature, this is pretty much all of the code that you would need
;;; as per the tutorial link above.
;;;

(defvar *product-id* 1 "Counter to increment our unique product ID.")
(defparameter *products* '() "A list of products.")
(defparameter *title-part-1* (list "pretty" "little" "awesome" "white" "blue"))
(defparameter *title-part-2* (list "book" "car" "laptop" "travel" "screwdriver"))

(defclass product ()
          (
            (id    :initarg :id       :accessor product-id       :type integere    :documentation "Unique ID")
            (title :initarg :title    :accessor product-title    :type string)
            (price :initarg :price    :accessor product-price    :type integer)
          )) ;; defclass

(defun menu (this-frame)
            (let* (
                     (bookmark (create-div this-frame :class "w3-center" :style "margin-bottom:35px; "))
                     (before-logo (create-div this-frame :style "z-index:2;"))
                     (logo (create-div this-frame :class "w3-padding" :style "width:600px; border:2px; border-color:#fff; border-style:solid; border-radius:5px; z-index:1; "))
                     (after-logo (create-div this-frame :style "z-index:2;"))
                  )
                  (create-img bookmark :url-src "/img/rocket.webp" )
                  (create-div before-logo :class "w3-center w3-text-white" 
                                          :content "CLOG TUTORIAL"
                                          :style "font-family:Pistara; font-size:16px; font-weight:bold; letter-spacing:5px; background-color:#c85007; margin-bottom:-15px; padding-left:20px; padding-right:20px;  ")
                  (create-div logo :class "w3-center w3-text-white" :content "QUICKSEARCH" :style "font-family:Soda Fountain; font-size:113px; " )
                  (create-div after-logo :class "w3-center w3-text-white" 
                                         :content "A simple INTEARCTIVE search demo" 
                                         :style "font-family:Montserrat; font-size:21px; font-weight:600; letter-spacing:1px; background-color:#c85007; margin-top:-20px; padding-left:20px; padding-right:20px; ")
                  ) ;; let*
            ) ;; defun

(defun instructions (this-content)
       (let* (
                (content-description (create-div this-content :class ""))
                (content-hint-1 (create-div this-content :class "w3-margin-top w3-padding-large " :style "display:flex; flex-direction:row;"))
                (content-hint-2 (create-div this-content :class "" :style "display:flex; flex-direction:row; justify-content:end;"))
             )
             (create-div content-description :class ""
                                             :style "font-family:Roboto; font-weight:300; border-left:0px; border-right:0px; border-top:1px; border-bottom:1px; border-color:#fff; border-style:dashed; padding-top:12px; padding-bottom:12px; "
                                             :content "In this demo we create a trivial list of semi randomized products.  The purpose of the demo
                                                       is to explore how a key-up event can be used to poll the list and update the results as
                                                       we type the query in the search field at the bottom of this demo.")
             (create-div content-hint-1 :style "font-family:Headstay; font-size:24px; "  
                                        :content "Hint! ( use these search terms )" 
                                        :class "")
             (create-img content-hint-1 :url-src "/img/arrow.webp" 
                                        :style "width:46px; height:18px; margin-top:24px;"
                                        )
             (create-div content-hint-2 :content "CAR TRAVEL LITTLE LAPTOP WHITE BLUE BOOK AWESOME PRETTY SCREWDRIVERS "
                                        :style "width:300px; font-size:24px; font-family:Barking Cat DEMO; margin-right:60px; "
                                        :class "w3-center "
                                        )
             ) ;; let*
       ) ;; defun

(defun random-price ()
  "Return an integer between 1 and 10.000 (price is expressed in cents)."
       (1+ (random 9999)))

(defun random-title ()
       (let* (
              (index (random (length *title-part-1*)))
              (index-2 (random (length *title-part-2*)))
            )
            (format nil "~a ~a" (elt *title-part-1* index) (elt *title-part-2* index-2))         
            ) ;; let
       ) ;; defun

(defun generate-test-products (&optional (nb 100))
       (dotimes (i nb)
                (push (make-instance 'product
                                     :id (incf *product-id*)
                                     :title (random-title)
                                     :price (random-price)
                                     ) ;; make
                      *products*) ;; push
                *products*) ;; dotimes
       ) ;; defun

(defun reset-test-products ()
       (setf *products* nil)) 

(defun print-product (it &optional (stream nil))
  "Print a product title and price on STREAM (return a new string by default)."
       (format stream "~a - ~f~&" (str:fit 20 (product-title it)) (/ (product-price it) 100)))

(defun print-products (products)
  "Return a list of products as a string (dummy, for test purposes)."
       (with-output-to-string (s)
                              (format s "Products:~&")
                              (dolist (n products)
                                      (print-product n s)
                                      ) ;; dolist
         ) ;; with
       ) ;; defun

(defun search-products (query &optional (products *products*)) 
  "Search for QUERY in the products title. This would be a DB call."
       (loop for product in products
             when (str:containsp (str:downcase query) (str:downcase (product-title product)))
             collect product
             ) ;; loop
       ) ;; defun

(defun add-products (this-content-results)
  "Create the search input and a div to contain the products.
   Bind the key-up event of the input field to our filter function."
       (let* (
                (search-field (create-div this-content-results :content "" :class "" :style "display:flex; flex-direction:row; align-items:center; width:400px;   "))
                (text-box (create-form-element search-field :text 
                                                            :placeholder "Search the site ... "
                                                            :class "w3-padding w3-input w3-text-gray w3-border-left w3-border-top w3-border-bottom test01   "
                                                            :style "border-bottom-left-radius:25px; border-top-left-radius:25px; height:40px; border-right:0px; outline:none;   "
                                                            ))
                (submit-button (create-div search-field :content "" 
                                                        :class "w3-button w3-green w3-border-top w3-border-right w3-border-bottom fa fa-search"
                                                        :style "display:flex; flex-direction:row; justify-content:center; align-items:center;
                                                                border-bottom-right-radius:25px; border-top-right-radius:25px; 
                                                                height:40px; font-size:18px; width:120px;   "
                                                         ))
                (results-div (create-div this-content-results :content "results" 
                                                              :class "w3-margin-top w3-text-white" 
                                                              :style "font-family:Chewy; font-size:18px; line-height:1.3;"))                
             )
             (set-on-key-up text-box
                            (lambda (obj event)
                                    (format t ":key-up, value: ~a~&" (value obj)) ;; logging
                                    (setf (text results-div) "") ;; zero out the result div
                                    (handle-filter-product results-div obj event) ;; populate the result div
                                    ) ;; lambda
                            ) ;; set
             (set-on-click submit-button
                           (lambda (obj)
                                   (setf (text results-div) "") ;; zero out the result div
                                   (setf (place-holder text-box) "Search the site ...")
                                   (setf (value text-box) "")
                                   (setf (text results-div) "... the submit button is not connected ...")
                                   ))
             ) ;; let*
       ) ;; defun

(defun handle-filter-product (this-div this-obj this-event)
  "Search and redisplay products."
       (declare (ignorable this-event))
       (let (
              (query (value this-obj)) 
            )
            (if (> (length query) 2)
                (display-products this-div (search-products query))
                (print "waiting for more input")
                ) ;; if
            ) ;; let
       ) ;; defun

(defun display-products (this-div products) 
  "Display these products in the page. Create a div per product, with a string to present the product.
   We don't create nice-looking Bulma product cards here."
       (dolist (n  products)
               (create-div this-div :content (format nil "~a - ~a" (product-id n) (print-product n)))
               ) ;; dolist
       ) ;; defun

;;;
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







