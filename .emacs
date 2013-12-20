;; show columns
(setq column-number-mode t)

;; make y/n dialogs terse
(fset 'yes-or-no-p 'y-or-n-p)

;; non positive integers mean no toolbar
(tool-bar-mode -1)

;; non positive integers mean no menubar
;;(menu-bar-mode 0)

;; get rid of scroll bar
(menu-bar-no-scroll-bar)

;; show matching parentheses
(require 'paren)
(show-paren-mode 1)

;; no stupid double space convention for sentence endings
(setq sentence-end-double-space nil)

(add-to-list 'load-path "~/.emacs.d/")
(require 'edit-server)
(edit-server-start)
(if (and (daemonp) (locate-library "edit-server"))
     (progn
       (require 'edit-server)
       (edit-server-start)))

(setq edit-server-new-frame nil)

(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)

(put 'downcase-region 'disabled nil)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(inhibit-startup-screen t)
 '(save-place t nil (saveplace))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(blink-cursor-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

