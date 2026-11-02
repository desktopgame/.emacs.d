;;; my-org.el --- Org mode and Babel  -*- lexical-binding: t; -*-

;;; Commentary:

;; The playground helpers live in `playground/library.org' next to
;; this file; `my/org-format-block' formats a source block that
;; declares `:format ruff'.

;;; Code:

;;; my-org.el -*- lexical-binding: t; -*-

(declare-function org-element-context "org-element")
(declare-function org-element-type "org-element")
(declare-function org-babel-get-src-block-info "ob-core")
(declare-function org-babel-lob-ingest "ob-lob")

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

(add-hook 'org-mode-hook #'display-line-numbers-mode)
(setq org-babel-python-command "python3")

(setenv "PYTHONPATH"
        (expand-file-name "playground" user-emacs-directory))

;; org python
(setq org-src-preserve-indentation t)
(setq python-indent-offset 4)
(setq org-src-tab-acts-natively t)

(defun my/org-format-block ()
  "Format the current Org source block using its :format header."
  (interactive)
  (require 'org)
  (require 'ob-core)

  (let* ((element (org-element-context))
         (info (org-babel-get-src-block-info 'light))
         (lang (car info))
         (formatter (alist-get :format (nth 2 info)))
         (directory default-directory))

    (unless (eq (org-element-type element) 'src-block)
      (user-error "Not inside a source block"))

    (unless (and (equal lang "python")
                 (equal formatter "ruff"))
      (user-error "Unsupported formatter"))

    (unless (executable-find "ruff")
      (user-error "Ruff not found"))

    (save-excursion
      (let* ((start
              (progn
                (goto-char (org-element-property
                            :post-affiliated element))
                (forward-line 1)
                (point)))
             (end
              (progn
                (goto-char (org-element-property :end element))
                (unless (re-search-backward
                         "^[ \t]*#\\+end_src\\b" start t)
                  (user-error "Cannot find end_src"))
                (line-beginning-position)))
             (code (buffer-substring-no-properties start end))
             (normalized (org-remove-indentation code))
             formatted)

        (with-temp-buffer
          (setq default-directory directory)
          (insert normalized)

          (let ((status
                 (call-process-region
                  (point-min) (point-max)
                  "ruff" t t nil
                  "format"
                  "--stdin-filename" "playground.py"
                  "-")))

            (unless (equal status 0)
              (error "Ruff failed (%s): %s"
                     status (buffer-string)))

            (setq formatted (buffer-string))))

        (unless (equal code formatted)
          (delete-region start end)
          (goto-char start)
          (insert formatted))))))

(with-eval-after-load 'org
  ;; Babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (shell . t)))

  (org-babel-lob-ingest
   (expand-file-name "playground/library.org"
                     user-emacs-directory))

  ;; LaTeX
  (setq org-format-latex-options
        (plist-put org-format-latex-options :scale 1.0))

  ;; Key bindings
  (keymap-set org-mode-map "C-c p" #'org-latex-preview))

(provide 'my-org)
;;; my-org.el ends here
