;;; early-init.el --- before the first frame  -*- lexical-binding: t; -*-

;;; Commentary:

;; Frame-level defaults that take effect earlier and cheaper than
;; doing the same from init.el.

;;; Code:

;; gui
(when (display-graphic-p)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(provide 'early-init)
;;; early-init.el ends here
