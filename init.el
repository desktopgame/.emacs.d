;;; init.el --- load every module in lisp/  -*- lexical-binding: t; -*-

;;; Commentary:

;; The actual configuration lives in `lisp/', one topic per module.
;; Each module is named my-*.el, ends with (provide 'my-...) matching
;; its basename, and declares hard dependencies with top-level
;; (require 'my-...) forms.
;;
;; Requiring every module found below is all this file does: Emacs'
;; own `require' machinery resolves the dependency graph recursively
;; (a topological sort), loads each module exactly once, and signals
;; "Recursive require" on a cycle.  Hooks and `with-eval-after-load'
;; are order-independent and need no declaration.

;;; Code:

(defconst my/lisp-dir (expand-file-name "lisp" user-emacs-directory)
  "Directory containing the init modules.")

(add-to-list 'load-path my/lisp-dir)

(dolist (file (directory-files my/lisp-dir t "\\`my-.*\\.el\\'"))
  (require (intern (file-name-base file))))

(provide 'init)
;;; init.el ends here
