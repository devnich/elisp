
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
)

;;-------------------------------
;; Environment assumptions
;;-------------------------------
;; Available through Synaptic:
;;  ESS, emacs-goodies
;;  
;; Available from the web:
;;  autopair, js2-mode, diff-mode-, multi-term, php-mode, virtualenv, geben

;;-------------------------------
;; Get elisp files
;;-------------------------------
(add-to-list 'load-path "~/elisp")
(setq load-path (cons "~/elisp/geben-0.26" load-path))

;; Load theme in Emacs 23
;; (setq load-path (cons "~/elisp/color-theme-6.6.0" load-path))
;; (setq load-path (cons "~/elisp/emacs-color-theme-solarized" load-path))
;; (require 'color-theme-solarized)
;; (color-theme-solarized-light)

;; Load theme in Emacs 24
(add-to-list 'custom-theme-load-path "~/ethemes/emacs-color-theme-roc")
(load-theme 'roc-light t)


;;-------------------------------
;; Shell and Terminal Settings
;;-------------------------------
;; Add colors for shell mode
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Add colors for term mode
(add-hook 'term-mode-hook 'ansi-color-for-comint-mode-on)

;; Prevent default term colors from overriding color theme
(setq term-default-bg-color nil)
(setq term-default-fg-color nil)

;; Invoke the shells
(eshell)
(rename-buffer "* ~$")
;; (shell)

;; Use multi-term to handle multiple terminal instances
(require 'multi-term)
(setq multi-term-program "/bin/bash")           ;; use bash in terminal
(global-set-key (kbd "C-c T") 'multi-term)      ;; create new terminal buffer
(global-set-key (kbd "C-c t") 'multi-term-next) ;; switch terminals

;; Mimic shell mode toggle
(add-to-list 'term-bind-key-alist '("C-c C-j" . term-line-mode))
(add-to-list 'term-bind-key-alist '("C-c C-k" . term-char-mode))

;; Define additional keys that bypass Emacs and go to the remote terminal
(defun term-send-esc ()
  "Send ESC in term mode"
  (interactive)
  (term-send-raw-string "\e"))

(add-hook 'term-mode-hook
          (lambda () (define-key term-raw-map (kbd "ESC") 'term-send-esc)))
(add-hook 'term-mode-hook
          (lambda () (define-key term-raw-map (kbd "C-y") 'term-paste)))


;;-------------------------------
;; Parentheses and highlighting
;;-------------------------------
(show-paren-mode t)
(transient-mark-mode t)

;; Load autopair in all buffers
(require 'autopair)
(autopair-global-mode)
(add-hook 'shell-script-mode-hook
          '(lambda () (autopair-mode)))
          ;; #'(lambda () (autopair-mode)))

;; Suppress autopair in term mode
(add-hook 'term-mode-hook
          '(lambda () (setq autopair-dont-activate t)))

;; Suppress autopair in js2 mode (redundant)
(add-hook 'js2-mode-hook
          '(lambda () (setq autopair-dont-activate t)))

;; Suppress autopair in groovy mode (use groovy-electric)
(add-hook 'groovy-mode-hook
          '(lambda () (setq autopair-dont-activate t)))

;;---------------------------
;; Look and feel customizations
;;---------------------------
;; Strip out GUI elements
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))

;; Disable scroll bar and tooltip if there's a windowing system
(when (display-graphic-p)
  (scroll-bar-mode -1)  
  (tooltip-mode -1))

;; Inhibit startup messages
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)

;; Sort Buffer menu by name column
(setq Buffer-menu-sort-column 2)

;; Show column numbers
(column-number-mode 1)

;; Scroll single line
(setq scroll-step 1)

;; Show tooltips in echo area
(setq tooltip-use-echo-area t)

;; Cut and paste between Emacs and OS clipboard
(setq x-select-enable-clipboard t)

;; Show clock
(setq display-time-12hr-format t)
(display-time)

;;---------------------------
;; Custom key bindings
;;---------------------------
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-x\C-r" 'rename-buffer)
(global-set-key "\M-s" 'isearch-forward-regexp)
(global-set-key "\M-r" 'isearch-backward-regexp)
(defalias 'qrr 'query-replace-regexp)
(global-set-key [f5] 'call-last-kbd-macro)
(fset 'yes-or-no-p 'y-or-n-p)

;; Indentation uses spaces
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

;; Count words in buffer (defined below)
(global-set-key "\C-c\C-w" 'count-words-buffer)

;;-------------------------------
;; Toggle sudo in dired mode
;;-------------------------------
(require 'dired-toggle-sudo)
(define-key dired-mode-map (kbd "C-c C-s") 'dired-toggle-sudo)
(eval-after-load 'tramp
 '(progn
    ;; Allow to use: /sudo:user@host:/path/to/file
    (add-to-list 'tramp-default-proxies-alist
		  '(".*" "\\`.+\\'" "/ssh:%h:"))))

;;---------------------------
;; Fonts and face decoration
;;---------------------------
;; Fonts
(set-frame-font "DejaVu Sans Mono-14")
(when (display-graphic-p)
  (set-face-font 'variable-pitch "Verdana-13"))

;; Font colors
;; (setq font-lock-face-attributes
;;       '((font-lock-builtin-face "dark magenta")
;;         (font-lock-comment-deliminter-face "dark goldenrod")
;;         (font-lock-comment-face "saddle brown")
;;         (font-lock-constant-face "red")
;;         ;;(font-lock-doc-face "")
;;         (font-lock-function-name-face "blue")
;;         (font-lock-keyword-face "dark orange")
;;         (font-lock-string-face "forest green")
;;         (font-lock-type-face "medium blue")
;;         (font-lock-variable-name-face "firebrick")))
;; ;; Background color
;; (set-background-color "old lace")

;; Syntax highlighting everywhere
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; Change wrapping and fonts depending on mode
;;(add-hook 'visual-line-mode-hook (lambda () (variable-pitch-mode t)))
(add-hook 'org-mode-hook (lambda () (variable-pitch-mode t)))
(add-hook 'org-mode-hook (lambda () (visual-line-mode t)))
(add-hook 'rst-mode-hook (lambda () (visual-line-mode t)))
(add-hook 'rst-mode-hook (lambda () (flyspell-mode t)))

;;-------------------------------
;; ----  PROGRAMMING MODES   ----
;;-------------------------------

;;-------------------------------
;; Diff mode-
;;-------------------------------
(require 'diff-mode-)

;;-------------------------------
;; Generic mode for .inp (Mplus)
;;-------------------------------
(require 'generic-x)
(define-generic-mode
  'mplus-mode
  '("!")  ;; comment
  '("on" "by" "with" "if" "xwith" "|" "eq" "is" "then") ;; keywords
  '((";" . 'font-lock-keyword-face)
    ("all" . 'font-lock-builtin-face)
    ("mean" . 'font-lock-builtin-face)
    ("sum" . 'font-lock-builtin-face)
    ("Names" . 'font-lock-builtin-face)
    ("Grouping" . 'font-lock-builtin-face)
    ("Useobs" . 'font-lock-builtin-face)
    ("Cluster" . 'font-lock-builtin-face)
    ("Usevariables" . 'font-lock-builtin-face)
    ("Count" . 'font-lock-builtin-face)
    ("Categorical" . 'font-lock-builtin-face)
    ("Missing" . 'font-lock-builtin-face)
    ("%Within%" . 'font-lock-builtin-face)
    ("%Between%" . 'font-lock-builtin-face)) ;; operators and builtins
  '("\\.inp$")
  nil
  "A mode for Mplus input files"
)

;; Decipher encoding for Binary/MS-DOS files
(modify-coding-system-alist 'file "\\.inp\\'" 'iso-latin-1-dos)

;;---------------------------
;; Dot graphing language
;;---------------------------
(autoload 'graphviz-dot-mode "graphviz-dot-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.gv$" . graphviz-dot-mode))

;;---------------------------
;; Latex output viewer
;;---------------------------
(setq tex-dvi-view-command "xdvi")

;;---------------------------
;; Groovy mode
;;---------------------------
;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Major mode for editing Groovy code." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;;; make Groovy mode electric by default.
(add-hook 'groovy-mode-hook
          '(lambda ()
             (require 'groovy-electric)
             (groovy-electric-mode)))

;;---------------------------
;; PHP
;;---------------------------
;;---------------------------
;; PHP mode (actually "improved PHP mode" by David House)
;;---------------------------
(require 'php-mode)
(add-to-list 'auto-mode-alist '("\\.module$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.install$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.profile$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.engine$" . php-mode))

(autoload 'geben "geben" "DBGp protocol frontend, a script debugger" t)
;; Debug a simple PHP script.
;; Change the session key "idekey" to any session key text you like
(defun my-php-debug ()
  "Run current PHP script for debugging with geben"
  (interactive)
  (call-interactively 'geben)
  (shell-command
    (concat "XDEBUG_CONFIG='idekey=emacs-xdebug' /usr/bin/php5 "
    (buffer-file-name) " &"))
  )

(define-key php-mode-map [f6] 'my-php-debug)

;;---------------------------
;; PHP mode hooks
;;---------------------------
;; (setq debug-on-error t)
(defun my-php-shell ()
  "Invoke the PHP interactive shell inside a multiterm instance"
  (interactive)
  (multi-term)
  (process-send-string nil "php -a \n")
  (rename-buffer "*PHP Shell*")
  (php-shell-mode)
  )

(defun send-to-php-shell ()
  "Evaluate current PHP file in the interactive shell"
  (interactive)
  (let ((scriptbuffer (buffer-string)))
    (set-buffer (get-buffer "*PHP Shell*"))
    ;; If no buffer named *PHP Shell*, run my-php-shell ;;
    (process-send-string nil scriptbuffer)
    )
  )

(define-key php-mode-map (kbd "C-c C-s") 'my-php-shell)
(define-key php-mode-map (kbd "C-c C-c") 'send-to-php-shell)

;;---------------------------
;; PHP interactive shell minor mode
;;---------------------------
(define-minor-mode php-shell-mode
  "Toggle the minor mode for the PHP interactive shell"
  ;; The initial value.
  :init-value nil
  ;; The indicator for the mode line.
  :lighter " phpshell"
  ;; The minor mode bindings.
  :keymap
  '(([?\;] . php-shell-nice-returns)
    ;; ([C-M-backspace]
    ;;  . (lambda ()
    ;;      (interactive)
    ;;      (php-shell-nice-returns t)))
    )
  :group 'php-minor)

(defun php-shell-nice-returns ()
  "Provide nice newline behavior in the interactive shell"
  (interactive)
  (term-line-mode)
  (insert " . \"\\n\";")
  (term-char-mode)
  )

;;---------------------------
;; Restructured Text mode
;;---------------------------
(require 'rst)
(setq auto-mode-alist
      (append '(("\\.txt$" . rst-mode)
                ("\\.rst$" . rst-mode)
                ("\\.rest$" . rst-mode)) auto-mode-alist))
(setq rst-mode-lazy nil)

;;---------------------------
;; Org mode
;;---------------------------
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-todo-list-sublevels nil)
(setq org-todo-keywords
       '((sequence "TODO" "|" "Done" "Won't fix" "Superseded")))
;; (setq org-agenda-files (list "~/Dropbox/Home.org"
;;                              "~/Dropbox/Dissertation.org"
;;                              "~/Dropbox/GalloGeneral.org"
;;                              "~/Dropbox/Segmentation.org"
;;                              "~/Dropbox/BrandHealth.org"
;;                              "~/Dropbox/CustomerHealth.org"))

;;---------------------------
;; Haskell
;;---------------------------
;;(require 'inf-haskell)

;;---------------------------
;; R (ESS)
;;---------------------------
(setq ess-eval-visibility-p nil)

;;---------------------------
;; Oz
;;---------------------------
(or (getenv "OZHOME")
    (setenv "OZHOME" 
            "~/mozart"))   ; or wherever Mozart is installed
(setenv "PATH" (concat (getenv "OZHOME") "/bin:" (getenv "PATH")))
 
(setq load-path (cons (concat (getenv "OZHOME") "/share/elisp")
                      load-path))

(add-to-list 'load-path "~/mozart/share/elisp")

(setq auto-mode-alist 
      (append '(("\\.oz\\'" . oz-mode)
                ("\\.ozg\\'" . oz-gump-mode))
              auto-mode-alist))
 
(autoload 'run-oz "oz" "" t)
(autoload 'oz-mode "oz" "" t)
(autoload 'oz-gump-mode "oz" "" t)
(autoload 'oz-new-buffer "oz" "" t)

;;---------------------------
;; Javascript
;;---------------------------
;; NB: You must byte-compile "js2.el" on the locally-installed version of emacs
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;---------------------------
;; Python
;;---------------------------
(autoload 'python-mode "python" "Python editing mode." t)
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; Force use of Python 3
;;(setq py-python-command "python3")

;; Add Enthought distribution to python path
;;(setenv "PYTHONPATH" "~/epython")

;; (require 'virtualenv)

;; Documentation
(add-hook 'python-mode-hook
          '(lambda () (eldoc-mode 1)) t)

;; Reformat paragraphs
(add-hook 'python-mode-hook
          '(lambda () (setq fill-column 84)))

;; Temporary - will be superseded by CEDET and Emacs Code Browser
;; Index code with imenu 
(add-hook 'python-mode-hook #'imenu-add-menubar-index)

;;------------------------
;; Word count
;;------------------------
;; from http://www.linux.com/archive/feed/56236

(defun count-words-region (beginning end)
  "Print number of words in the region."
  (interactive "r")
  (message "Counting words in region ... ")

;;; 1. Set up appropriate conditions.
  (save-excursion
    (let ((count 0))
      (goto-char beginning)

;;; 2. Run the while loop.
      (while (and (< (point) end)
                  (re-search-forward "\\w+\\W*" end t))
        (setq count (1+ count)))

;;; 3. Send a message to the user.
      (cond ((zerop count)
             (message
              "The region does NOT have any words."))
            ((= 1 count)
             (message
              "The region has 1 word."))
            (t
             (message
              "The region has %d words." count))))))

;; Count the words in the entire document
(defun count-words-buffer ()
  "Count all the words in the buffer"
  (interactive)
  (count-words-region (point-min) (point-max) )
)

;;------------------------
;; Mail
;;------------------------
;; wanderlust
(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;; IMAP
(setq elmo-imap4-default-server "imap.gmail.com")
(setq elmo-imap4-default-user "devnich@gmail.com") 
(setq elmo-imap4-default-authenticate-type 'clear) 
(setq elmo-imap4-default-port '993)
(setq elmo-imap4-default-stream-type 'ssl)

(setq elmo-imap4-use-modified-utf7 t)

;; Hacks
;; (setq starttls-use-gnutls t)
;; (setq starttls-gnutls-program "gnutls-cli")
;; (setq starttls-extra-arguments '("--insecure"))
;; (setq
;;  ssl-certificate-verification-policy 1
;;  ssl-program-name "gnutls-cli"
;;  ssl-program-arguments '("-p" service host))

;; SMTP
(setq wl-smtp-connection-type 'starttls)
(setq wl-smtp-posting-port 587)
(setq wl-smtp-authenticate-type "plain")
(setq wl-smtp-posting-user "mattofransen")
(setq wl-smtp-posting-server "smtp.gmail.com")
(setq wl-local-domain "gmail.com")
(setq wl-message-id-domain "gmail.com")

(setq wl-default-folder "%inbox")
(setq wl-default-spec "%")
(setq wl-draft-folder "%[Gmail]/Drafts") ; Gmail IMAP
(setq wl-trash-folder "%[Gmail]/Trash")

(setq wl-folder-check-async t) 

(setq elmo-imap4-use-modified-utf7 t)

(autoload 'wl-user-agent-compose "wl-draft" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'wl-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-send
      'wl-draft-kill
      'mail-send-hook))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
