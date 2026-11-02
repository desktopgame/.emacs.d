;;; my-agent-shell.el --- agent-shell  -*- lexical-binding: t; -*-

;;; Code:

(require 'my-packages)

(use-package agent-shell
  :ensure t
  :config
  (add-to-list 'exec-path "~/.opencode/bin/"))

(setq agent-shell-openai-authentication
      (agent-shell-openai-make-authentication :login t))

(provide 'my-agent-shell)
;;; my-agent-shell.el ends here
