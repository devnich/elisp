* Packages that invoke fullframe.el have to be edited after update to comment this out. The fullframe library checks for the Emacs version in a way that is not compatible with my install.
* flycheck-clojure is currently broken when used with cider-repl, so it has been disabled
* Rename ~/ethemes/color-theme-sanityinc-tomorrow to ~/ethemes/color-theme-gooseberry-tomorrow

Currently the overwritten/copied init files are:
* .dir-locals.el
* init-local.el
* init-preload-local.el
* init-themes.el

Is buffer swapping different in new version? Check dired customizations or ibuffer-other-buffer at work:

./init-ibuffer.el:58:(global-set-key (kbd "C-x C-b") 'ibuffer)
Check whether new version uses 'ibuffer-other-window

;; (require-package 'fullframe)
;; (after-load 'ibuffer
;;  (fullframe ibuffer ibuffer-quit))

Full-framing is probably called in new version
