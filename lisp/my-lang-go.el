;;; my-lang-go.el --- Go development  -*- lexical-binding: t; -*-

;;; Code:

;; for golang
(add-hook 'go-mode-hook #'eglot-ensure)

(provide 'my-lang-go)
;;; my-lang-go.el ends here
