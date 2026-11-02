;;; my-lang-rust.el --- Rust development  -*- lexical-binding: t; -*-

;;; Code:

(require 'my-packages)

;; for rust
(use-package rust-mode
  :ensure t
  :hook (rust-mode . eglot-ensure))
(setq rust-format-on-save t)

(provide 'my-lang-rust)
;;; my-lang-rust.el ends here
