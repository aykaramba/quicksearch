# QUICKSEARCH - A simple interacive search demo.

<img width="800" height="875" alt="quicksearch" src="https://github.com/user-attachments/assets/50c1d4b4-6060-4363-b379-ddee1bc954d2" />

This is an attempt to test a quicksearch technique demonstrated in the following tutorial:

Tutorial Link: https://web-apps-in-lisp.github.io/isomorphic-web-frameworks/clog/index.html

Author of the tutorial: https://github.com/vindarel/

Almost no changes were made to the code, so most of the code and comments are by Vincent Dardel with minor updates by me. I wanted to go through the tutorial, implement the code and see how a quick search based on keystroke input works, package it up and prepare it for adding features. If any, the following updates were made to the tutorials

SPECIAL NOTE: If you get a chance, you should work through the original tutorial linked above because it demonstrates the use of of live coding directly in the CLOG framework. CLOG is a powerful and mature framework with many features the live coding feature should be experienced by everyone. I created a package for the purposes of
testing.

# INSTALLATION

1) Git clone to your local dir as appropriate.
2) Load the system: (ql:quickload :quicksearch)
3) Start the app: (quicksearch:start-app)

# Copyright

All copyright to original code owned by Vincent Dardel.
All other code is copyright of Robert Taylor.
