;;; my-appearance.el --- theme and faces  -*- lexical-binding: t; -*-

;;; Commentary:

;; Anything that customises faces must load after this module (see
;; `my-completion').  Customize settings stay in custom.el.

;;; Code:

;; theme
(load-theme 'manoj-dark t)

(set-face-attribute 'default nil :height 140)

;; Keep settings written by Customize separate from this file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t t)

(provide 'my-appearance)
;;; my-appearance.el ends here
