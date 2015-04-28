(set-frame-font "DejaVu Sans Mono-13")

;; Invoke the shells
(add-hook 'emacs-startup-hook 'eshell)

;; Invoke multi-term and add zsh shell

;; sudo access to directories or files on demand; see:
;;   http://emacsredux.com/blog/2013/04/21/edit-files-as-root/ option B

;; Find keyboard eval shortcut for scratch buffer
;;C-j 'eval-print-last-sexp

;; Move cursor to most recently opened file in ibuffer

;; Add syntax highlighting for drush make and Drupal PHP files if necessary

;; Add some keyboard shortcuts
(defalias 'qrr 'query-replace-regexp)
(global-set-key [f5] 'call-last-kbd-macro)

(provide 'init-local)
