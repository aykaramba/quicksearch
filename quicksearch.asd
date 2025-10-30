(asdf:defsystem #:quicksearch
  :description "New CLOG System"
  :author "some@one.com"
  :license  "BSD"
  :version "0.0.0"
  :serial t
  :entry-point "quicksearch:start-app"  
  :depends-on (#:clog #:str) ; add clog plugins here as #:plugin for run time
  :components ((:file "quicksearch")))

(asdf:defsystem #:quicksearch/tools
  :defsystem-depends-on (:clog)
  :depends-on (#:quicksearch #:clog/tools) ; add clog plugins here as #:plugin/tools for design time
  :components ())
