;;; init.el --- load lisp/ modules in dependency order  -*- lexical-binding: t; -*-

;;; Commentary:

;; The actual configuration lives in `lisp/', one topic per module.
;; Each module
;;
;;   * is named my-*.el and provides a matching feature,
;;   * declares hard dependencies with top-level (require 'my-...)
;;     forms; hooks and `with-eval-after-load' need no declaration,
;;   * is loaded automatically; there is no list to maintain here.
;;
;; `my/load-modules' scans `my/lisp-dir', builds a dependency graph
;; from the require/provide pairs of local modules, topologically
;; sorts it and loads the files.  Requires for non-module features
;; (package, org, magit, ...) are left to Emacs' own `require'.  A
;; cycle aborts init with an error naming the modules involved.

;;; Code:

(defvar my/lisp-dir (expand-file-name "lisp" user-emacs-directory)
  "Directory containing the init modules.")

(add-to-list 'load-path my/lisp-dir)

(defun my--quoted-symbol (arg)
  "Return the symbol quoted by ARG, or nil when ARG is not \\='sym."
  (when (and (consp arg) (eq (car arg) 'quote))
    (let ((name (nth 1 arg)))
      (and (symbolp name) name))))

(defun my--module-info (file)
  "Return (FILE PROVIDES REQUIRES) for the module in FILE.
Only top-level `provide' and `require' forms are inspected."
  (with-temp-buffer
    (insert-file-contents file)
    (let (provides requires)
      (condition-case nil
          (while t
            (let ((form (read (current-buffer))))
              (when (consp form)
                (let ((feature (my--quoted-symbol (nth 1 form))))
                  (when feature
                    (pcase (car form)
                      ('provide (push feature provides))
                      ('require (push feature requires))))))))
        (end-of-file nil))
      (list file (nreverse provides) (nreverse requires)))))

(defun my--tsort-modules (modules)
  "Return the file list of MODULES with dependencies first.
MODULES is a list of (FILE PROVIDES REQUIRES).  Among modules
that are ready at the same time the order follows FILE.  Signal
an error when the dependency graph contains a cycle."
  (let ((owner (make-hash-table :test 'eq))   ; feature -> file
        (deps (make-hash-table :test 'equal)) ; file -> module files
        (done (make-hash-table :test 'equal))
        (pending (mapcar #'car modules))
        (order '()))
    (dolist (entry modules)
      (dolist (feature (cadr entry))
        (puthash feature (car entry) owner)))
    (dolist (entry modules)
      (let ((file (car entry))
            (local '()))
        (dolist (feature (caddr entry))
          (let ((target (gethash feature owner)))
            (when (and target
                       (not (equal target file))
                       (not (member target local)))
              (push target local))))
        (puthash file local deps)))
    (while pending
      (let ((ready
             (seq-find (lambda (file)
                         (seq-every-p (lambda (dep) (gethash dep done))
                                      (gethash file deps)))
                       pending)))
        (unless ready
          (user-error "Module dependency cycle detected among: %s"
                      (mapconcat #'file-name-nondirectory pending ", ")))
        (push ready order)
        (puthash ready t done)
        (setq pending (delete ready pending))))
    (nreverse order)))

(defun my/load-modules (&optional dir)
  "Load every module in DIR (default `my/lisp-dir') in order."
  (interactive)
  (let ((modules (mapcar #'my--module-info
                         (directory-files (or dir my/lisp-dir) t
                                          "\\`my-.*\\.el\\'"))))
    (dolist (file (my--tsort-modules modules))
      (load file nil 'nomsg))))

(my/load-modules)

(provide 'init)
;;; init.el ends here
