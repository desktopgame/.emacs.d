;;; init.el -*- lexical-binding: t; -*-
(fido-vertical-mode 1)

;; package
(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; flymake
(with-eval-after-load 'elisp-mode
  (setq elisp-flymake-byte-compile-load-path load-path))

;; gui
(when (display-graphic-p)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1))

;; theme
(load-theme 'manoj-dark t)

(set-face-attribute 'default nil :height 140)
(set-face-attribute 'icomplete-selected-match nil
                    :foreground "#ffffff"
                    :background "#365f9c"
                    :weight 'bold)

;; environment
(defvar my/repository-root nil
  "Root directory containing local repositories.")

(load (expand-file-name "local.el" user-emacs-directory)
      t t)

(use-package ghostel
  :vc (:url "https://github.com/dakra/ghostel"
	    :lisp-dir "lisp"
	    :rev :newest))

(prefer-coding-system 'utf-8)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Keep settings written by Customize separate from this file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t t)

;; Register Git repositories when project.el loads.
(with-eval-after-load 'project
  (when (and my/repository-root
             (file-directory-p my/repository-root))
    (dolist (dir (directory-files my/repository-root t "^[^.]"))
      (when (file-exists-p (expand-file-name ".git" dir))
        (project-remember-project
         (list 'vc 'Git (file-name-as-directory dir)))))))

;; key
(which-key-mode 1)

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

;; for elisp
(add-hook 'emacs-lisp-mode-hook #'flymake-mode)

(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (setq-local flymake-diagnostic-functions
			(remove 'elisp-flymake-checkdoc
				flymake-diagnostic-functions))))

;; for golang
(add-hook 'go-mode-hook #'eglot-ensure)

;; for rust
(use-package rust-mode
  :ensure t
  :hook (rust-mode . eglot-ensure))
(setq rust-format-on-save t)

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

;; for org
(defun my/playground ()
  "Open a temporary Org Babel playground."
  (interactive)
  (let ((buffer (get-buffer-create "*playground*")))
    (switch-to-buffer buffer)
    (unless (derived-mode-p 'org-mode)
      (org-mode))
    (when (= (buffer-size) 0)
      (insert "#+begin_src python :results output drawer\n"
              "\n"
              "#+end_src\n")
      (forward-line -2))))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (shell . t)))

(add-hook 'org-mode-hook #'display-line-numbers-mode)
(setq org-babel-python-command "python3")

(setenv "PYTHONPATH"
        (expand-file-name "~/.emacs.d/playground"))

(org-babel-lob-ingest
 (expand-file-name "~/.emacs.d/playground/library.org"))

;; for kitty

(use-package kitty-graphics
  :vc (:url "https://github.com/cashmeredev/kitty-graphics.el"
       :rev :newest)
  :config
  (kitty-graphics-setup))

(setq org-format-latex-options
      (plist-put org-format-latex-options :scale 1.0))

(with-eval-after-load 'org
  (keymap-set org-mode-map "C-c p" #'org-latex-preview))

(defalias 'my/refresh #'kitty-graphics-clear-all)

;; clipboard
(when (and (eq system-type 'gnu/linux)
           (not (display-graphic-p))
           (getenv "WAYLAND_DISPLAY")
           (executable-find "wl-copy"))
  (setq interprogram-cut-function
        (lambda (text &optional _push)
          (let ((process-connection-type nil))
            (let ((proc (start-process "wl-copy" nil "wl-copy" "-n")))
              (process-send-string proc text)
              (process-send-eof proc))))))

;; choicel
(use-package choicel
  :ensure nil
  :load-path (lambda ()
               (expand-file-name "choicel" my/repository-root))
  :bind ("C-c ?" . choicel))

;; agent-shell
(use-package agent-shell
      :ensure t
      :config
         (add-to-list 'exec-path "~/.opencode/bin/"))

(setq agent-shell-openai-authentication
      (agent-shell-openai-make-authentication :login t))

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

