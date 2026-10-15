;;; init.el -*- lexical-binding: t; -*-
(fido-vertical-mode 1)

;; environment
(defvar my/repository-root nil
  "Root directory containing local repositories.")

(load (expand-file-name "local.el" user-emacs-directory)
      t t)

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

;; for elisp
(add-hook 'emacs-lisp-mode-hook #'flymake-mode)

(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (setq-local flymake-diagnostic-functions
			(remove 'elisp-flymake-checkdoc
				flymake-diagnostic-functions))))

;; for golang
(add-hook 'go-mode-hook #'eglot-ensure)

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
