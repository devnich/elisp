
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
;;  autopair, js2-mode, diff-mode-, multi-term, php-mode, virtualenv, geben, color-theme, dired-toggle-sudo, grails-mode, groovy-eval, groovy-mode, groovy-electric, inf-groovy

;;-------------------------------
;; Get elisp files
;;-------------------------------
;; Find correct directory paths
(if (equal (getenv "USER") "root")
    (defcustom homedir "/home/ewa" "set user's absolute directory")
  (defcustom homedir (getenv "HOME") "set user's absolute directory")
  )

(add-to-list 'load-path (concat homedir "/elisp"))
(add-to-list 'load-path (concat homedir "/elisp/autocomplete"))
(setq load-path (cons (concat homedir "/elisp/geben-0.26") load-path))

;; Load theme in Emacs 24
(if (> emacs-major-version 23)
    (progn
      (add-to-list 'custom-theme-load-path (concat homedir "/ethemes/emacs-color-theme-roc"))
      (load-theme 'roc-light t))
  ;; Load theme in Emacs 23 (invoke with M-x color-theme-roc)
  (progn
    (setq load-path (cons (concat homedir "/elisp/color-theme-6.6.0") load-path))
    (setq load-path (cons (concat homedir "/ethemes/emacs-color-theme-roc") load-path))
    (require 'color-theme-roc))
  )

;; Color references for 256-color terminal:
;; http://upload.wikimedia.org/wikipedia/commons/9/95/Xterm_color_chart.png
;; http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html

;;-------------------------------
;; CEDET experimentation
;;-------------------------------
;; Enable built-in CEDET
(global-ede-mode 1)
;; (require 'semantic/sb) ;; not required?
(semantic-mode 1)

;; Semantic
(if (> emacs-major-version 23)
    (progn
      (global-semantic-idle-completions-mode t)
      (global-semantic-decoration-mode t)
      (global-semantic-highlight-func-mode t)
      (global-semantic-show-unmatched-syntax-mode t)
      ))

;; CC-mode
(add-hook 'c-mode-hook '(lambda ()
        (setq ac-sources (append '(ac-source-semantic) ac-sources))
        (local-set-key (kbd "RET") 'newline-and-indent)
        (linum-mode t)
        (semantic-mode t)))

;; Autocomplete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (concat homedir "/elisp/dict"))
(ac-config-default)

;; JDEE experimentation
;; (add-to-list 'load-path (concat homedir "/elisp/jdee-2.4.1/lisp"))
;; (load "jde")

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
(setq multi-term-program "/bin/zsh")            ;; use bash in terminal
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

;; Suppress autopair in term mode
(add-hook 'term-mode-hook
          #'(lambda ()
              ;; Disable in <24
              (setq autopair-dont-activate t)
              ;; Disable in >=24
              (autopair-mode -1)))

;; Suppress autopair in js2 mode (redundant)
(add-hook 'js2-mode-hook
          #'(lambda ()
              ;; Disable in <24
              (setq autopair-dont-activate t)
              ;; Disable in >=24
              (autopair-mode -1)))

;; Suppress autopair in groovy mode (use groovy-electric)
(add-hook 'groovy-mode-hook
          #'(lambda ()
              ;; Disable in <24
              (setq autopair-dont-activate t)
              ;; Disable in >=24
              (autopair-mode -1)))

;;---------------------------
;; Look and feel customizations
;;---------------------------
;; Strip out GUI elements
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))

;; Disable scroll bar and tooltip if there's a windowing system
(when (display-graphic-p)
  (scroll-bar-mode -1)  
  (tooltip-mode -1)
  )

;; Inhibit startup messages
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)

;; Sort Buffer menu by name column
(setq Buffer-menu-sort-column 2)

;; Set which flags are passed to ls for dired display
(setq dired-listing-switches "-alk")

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

;; Add hostname to menu bar
(define-key global-map [menu-bar host]
  (cons (concat "@" system-name "   ")
        (make-sparse-keymap system-name)))


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
(if (> emacs-major-version 23)
    (progn
      (require 'dired-toggle-sudo)
      (define-key dired-mode-map (kbd "C-c C-s") 'dired-toggle-sudo)
      (eval-after-load 'tramp
        '(progn
           ;; Allow to use: /sudo:user@host:/path/to/file
           (add-to-list 'tramp-default-proxies-alist
                        '(".*" "\\`.+\\'" "/ssh:%h:"))))
      )
  )

;;---------------------------
;; Fonts and face decoration
;;---------------------------
;; Fonts
(set-frame-font "DejaVu Sans Mono-14")
(when (display-graphic-p)
  (set-face-font 'variable-pitch "Verdana-13"))

;; Old hard-coded font colors
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
;; Use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Major mode for editing Groovy code." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;; Make Groovy mode electric by default.
(add-hook 'groovy-mode-hook
          '(lambda ()
             (require 'groovy-electric)
             (groovy-electric-mode)))

 ;; Load inf-groovy and set inf-groovy key definition in groovy-mode.
(autoload 'run-groovy "inf-groovy" "Run an inferior Groovy process")
(autoload 'inf-groovy-keys "inf-groovy" "Set local key defs for inf-groovy in groovy-mode")
(add-hook 'groovy-mode-hook
          '(lambda ()
             (inf-groovy-keys)))
;; '(auto-complete-mode 1)

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
;; IMAP
;; SMTP

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
