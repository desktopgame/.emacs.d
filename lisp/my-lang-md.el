;;; my-lang-md.el --- markdown edit  -*- lexical-binding: t; -*-

;;; Code:

(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" . markdown-mode)
  :hook (markdown-mode . visual-line-mode)
  :config
  (setq markdown-hide-markup t))

(provide 'my-lang-md)
;;; my-lang-md.el ends here
