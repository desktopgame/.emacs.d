;;; my-clipboard.el --- Wayland clipboard  -*- lexical-binding: t; -*-

;;; Code:

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

(provide 'my-clipboard)
;;; my-clipboard.el ends here
