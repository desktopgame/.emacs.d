;;; my-kitty.el --- kitty terminal graphics  -*- lexical-binding: t; -*-

;;; Code:

(require 'my-packages)

;; for kitty
(use-package kitty-graphics
  :vc (:url "https://github.com/cashmeredev/kitty-graphics.el"
       :rev :newest)
  :config
  (kitty-graphics-setup))

(defalias 'my/refresh #'kitty-graphics-clear-all)

(provide 'my-kitty)
;;; my-kitty.el ends here
