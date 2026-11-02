;;; my-ghostel.el --- Git for the terminal  -*- lexical-binding: t; -*-

;;; Code:

(require 'my-packages)

(use-package ghostel
  :vc (:url "https://github.com/dakra/ghostel"
       :lisp-dir "lisp"
       :rev :newest))

(provide 'my-ghostel)
;;; my-ghostel.el ends here
