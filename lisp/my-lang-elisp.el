;;; my-lang-elisp.el --- Emacs Lisp development  -*- lexical-binding: t; -*-

;;; Code:

;; flymake
(with-eval-after-load 'elisp-mode
  (setq elisp-flymake-byte-compile-load-path load-path))

;; for elisp
(add-hook 'emacs-lisp-mode-hook #'flymake-mode)

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq-local flymake-diagnostic-functions
                        (remove 'elisp-flymake-checkdoc
                                flymake-diagnostic-functions))))

(provide 'my-lang-elisp)
;;; my-lang-elisp.el ends here
