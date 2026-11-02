;;; my-vc.el --- Git integration  -*- lexical-binding: t; -*-

;;; Code:

(require 'my-packages)

;; git client
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

;; git diff
(use-package diff-hl
  :ensure t
  :config
  (global-diff-hl-mode 1))

(unless (display-graphic-p)
  (diff-hl-margin-mode 1))

;; integrate with magit
(with-eval-after-load 'magit
  (add-hook 'magit-post-refresh-hook
            #'diff-hl-magit-post-refresh))

(provide 'my-vc)
;;; my-vc.el ends here
