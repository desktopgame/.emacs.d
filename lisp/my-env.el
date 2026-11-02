;;; my-env.el --- local environment  -*- lexical-binding: t; -*-

;;; Commentary:

;; Loads local.el, which may set `my/repository-root' and other
;; machine-specific values.  Modules that resolve paths relative to
;; the repository root (e.g. choicel) must depend on this module.

;;; Code:

(defvar my/repository-root nil
  "Root directory containing local repositories.")

(load (expand-file-name "local.el" user-emacs-directory)
      t t)

;; Register Git repositories when project.el loads.
(with-eval-after-load 'project
  (when (and my/repository-root
             (file-directory-p my/repository-root))
    (dolist (dir (directory-files my/repository-root t "^[^.]"))
      (when (file-exists-p (expand-file-name ".git" dir))
        (project-remember-project
         (list 'vc 'Git (file-name-as-directory dir)))))))

(provide 'my-env)
;;; my-env.el ends here
