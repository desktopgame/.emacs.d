;;; my-completion.el --- completion and key help  -*- lexical-binding: t; -*-

;;; Commentary:

;; Depends on `my-appearance' because the icomplete face tweak must
;; run after `load-theme' (and after `fido-vertical-mode' so the
;; face is already defined).

;;; Code:

(require 'my-packages)
(require 'my-appearance)

(fido-vertical-mode 1)

(set-face-attribute 'icomplete-selected-match nil
                    :foreground "#ffffff"
                    :background "#365f9c"
                    :weight 'bold)

(which-key-mode 1)

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  :config
  (global-corfu-mode 1)

  ;; needs below code for popup
  (use-package corfu-terminal
    :ensure t
    :config
    (corfu-terminal-mode 1)))

(provide 'my-completion)
;;; my-completion.el ends here
