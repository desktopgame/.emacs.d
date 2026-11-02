;;; my-packages.el --- package archives  -*- lexical-binding: t; -*-

;;; Commentary:

;; Root of the module graph: depend on this module (`require' it at
;; top level) from anything that installs packages via `:ensure' or
;; `:vc'.

;;; Code:

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(provide 'my-packages)
;;; my-packages.el ends here
