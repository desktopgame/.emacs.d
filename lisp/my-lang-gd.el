;;; my-lang-gd.el --- Godot development  -*- lexical-binding: t; -*-

;;; Code:

(use-package gdscript-mode
  :ensure t
  :vc (:url "git@github.com:godotengine/emacs-gdscript-mode.git")
  :hook (gdscript-mode . eglot-ensure))

(provide 'my-lang-gd)
;;; my-lang-gd.el ends here
