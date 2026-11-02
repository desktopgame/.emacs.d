;;; my-basic.el --- editing defaults and file storage  -*- lexical-binding: t; -*-

;;; Code:

;; scroll
(setq scroll-conservatively 101
      scroll-margin 3)

(prefer-coding-system 'utf-8)

;; show line numbers
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; ~/.emacs.d/auto-save/
(let ((dir (expand-file-name "auto-save/" user-emacs-directory)))
  (make-directory dir t)
  (setq auto-save-file-name-transforms
        `((".*" ,dir t))))

;; Store backup files separately.
(let ((dir (expand-file-name "backups/" user-emacs-directory)))
  (make-directory dir t)
  (setq backup-directory-alist
        `(("." . ,dir))))

(provide 'my-basic)
;;; my-basic.el ends here
