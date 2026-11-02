;;; my-commands.el --- interactive commands  -*- lexical-binding: t; -*-

;;; Code:

(defun my/copy-file-path ()
  "Copy the current file path."
  (interactive)
  (if-let* ((path (buffer-file-name)))
      (progn
        (kill-new path)
        (message "Copied: %s" path))
    (user-error "This buffer is not visiting a file")))

(defun my/copy-file-name ()
  "Copy the current file name."
  (interactive)
  (if-let* ((path (buffer-file-name)))
      (let ((name (file-name-nondirectory path)))
        (kill-new name)
        (message "Copied: %s" name))
    (user-error "This buffer is not visiting a file")))

(defun my/copy-directory ()
  "Copy the current working directory."
  (interactive)
  (kill-new default-directory)
  (message "Copied: %s" default-directory))

(provide 'my-commands)
;;; my-commands.el ends here
