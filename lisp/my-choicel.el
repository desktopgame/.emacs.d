;;; my-choicel.el --- choicel integration  -*- lexical-binding: t; -*-

;;; Commentary:

;; Depends on `my-env' because the load path is resolved from
;; `my/repository-root' at init time.

;;; Code:

(require 'my-packages)
(require 'my-env)

(use-package choicel
  :ensure nil
  :load-path (lambda ()
               (expand-file-name "choicel" my/repository-root))
  :bind ("C-c ?" . choicel))

(provide 'my-choicel)
;;; my-choicel.el ends here
