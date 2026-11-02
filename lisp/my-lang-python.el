;;; my-lang-python.el --- Python development  -*- lexical-binding: t; -*-

;;; Code:

(require 'my-packages)

;; for python
;; Python LSP (BasedPyright)
(use-package eglot
  :ensure nil
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 "basedpyright-langserver" "--stdio")))

(use-package python
  :ensure nil
  :hook
  ((python-mode . eglot-ensure)
   (python-ts-mode . eglot-ensure)))

;; Ruff lint (Flymake)
(use-package flymake-ruff
  :ensure t
  :hook
  ((python-mode . flymake-ruff-load)
   (python-ts-mode . flymake-ruff-load)))

;; Ruff format
;; (use-package ruff-format
;;   :ensure t
;;   :hook
;;   ((python-mode . ruff-format-on-save-mode)
;;    (python-ts-mode . ruff-format-on-save-mode)))
(use-package apheleia
  :ensure t
  :config
  (setf (alist-get 'python-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  (setf (alist-get 'python-ts-mode apheleia-mode-alist)
        '(ruff-isort ruff))
  :hook
  ((python-mode . apheleia-mode)
   (python-ts-mode . apheleia-mode)))

(provide 'my-lang-python)
;;; my-lang-python.el ends here
