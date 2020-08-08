;;;    ___  ____ ___  ____ ___________
;;;   / _ \/ __ `__ \/ __ `/ ___/ ___/
;;;  /  __/ / / / / / /_/ / /__(__  )
;;;  \___/_/ /_/ /_/\__,_/\___/____/
;;;
;;;================================;;;
;;; PACKAGES                       ;;;
;;;================================;;;

;; Faster loading
(setf gc-cons-threshold 100000000)
(add-hook 'after-init-hook (lambda ()
                             (setq gc-cons-threshold 25000000)))
(setq read-process-output-max (* 1024 1024))

;; Initialize packages
(require 'package)
(package-initialize)

;; Add MELPA repo if not available already
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; Load path
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; Refresh list
(package-refresh-contents)

;; Use use-package to manage stuff
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; Enable verbose output
(setq use-package-verbose t)

;; Autoinstall missing packages
(setq use-package-always-ensure t)

;; Auto compile
(use-package auto-compile
  :config (auto-compile-on-load-mode))

;; Prefer newer files
(setq load-prefer-newer t)

;; Start the server
(server-start)

;;;================================;;;
;;; GENERAL                        ;;;
;;;================================;;;

;; Load local settings (shell, paths, etc.)
(let ((local (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local)
    (load local)))

;; Python environment
(setq python-shell-interpreter "python3")

;; Backup, auto-save, history files to .emacs.d/
(setq backup-directory-alist '(("." . "~/.emacs.d/emacs-backup")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))
(setq savehist-file "~/.emacs.d/savehist")

;; Save undo history in .emacs
(setq undo-tree-auto-save-history t
      undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; Save history
(savehist-mode 1)

;; Truncate at 10000 items, remove dupes
(setq history-length 10000)
(setq history-delete-duplicates t)

;; Save all minibuffers, kill-ring and search history
(setq savehist-save-minibuffer-history 1)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))

;; Delete old backups automatically
(setq delete-old-versions t)

;; Make numeric backups
(setq version-control t)

;; Version control does need backups
(setq vc-make-backup-files nil)

;; Always follow symbolic links
(setq vc-follow-symlinks t)

;; No lock files
(setq create-lockfiles nil)

;; Unicode, motherfucker, do you speak it?
(set-language-environment "UTF-8")

;; Frame (= Window) title
(setq-default frame-title-format
              '((:eval (if (buffer-file-name)
                           (abbreviate-file-name (buffer-file-name))
                         "%b"))))
(setq-default icon-title-format nil
              ;; frame-title-format nil
              )

;; Remember cursor position
(save-place-mode 1)

;; Remember window layout
(desktop-save-mode)

;; emacs-mac specific settings
(when (eq system-type 'darwin)
  (setq mac-pass-command-to-system nil)
  (setq-default mac-command-modifier 'super)
  (setq-default mac-right-command-modifier 'hyper)
  (setq-default mac-option-modifier 'meta))

;; Secret stuff
(defvar my/spotify-api-client-id nil)
(defvar my/spotify-api-client-secret nil)
(let ((secret (expand-file-name "secret.el" user-emacs-directory)))
  (when (file-exists-p secret)
    (load secret)))

;; Free up some nice prefix keys
(define-key global-map (kbd "M-f") nil) ; file related
(define-key global-map (kbd "M-a") nil) ; jumping in buffer
(define-key global-map (kbd "M-e") nil) ; environment specific
(define-key global-map (kbd "M-c") nil) ; configuration
(define-key global-map (kbd "M-s") nil) ; spotify
(define-key global-map (kbd "M-g") nil) ; magit
(define-key global-map (kbd "M-r") nil) ; run, compile, test
(define-key global-map (kbd "s-e") nil) ; org stuff
(define-key global-map (kbd "C-j") nil)

;;;================================;;;
;;; MODES                          ;;;
;;;================================;;;

(defvar-local hidden-mode-line-mode nil)
(define-minor-mode hidden-mode-line-mode
  "Minor mode to hide the mode-line in the current buffer"
  :init-value nil
  :global t
  :variable hidden-mode-line-mode
  :group 'editing-basics
  (if hidden-mode-line-mode
      (setq hide-mode-line mode-line-format
            mode-line-format nil)
    (setq mode-line-format hide-mode-line
          hide-mode-line nil))
  (force-mode-line-update)
  (redraw-display)
  (when (and (called-interactively-p 'interactive)
             hidden-mode-line-mode)
    (run-with-idle-timer
     0 nil 'message
     "Hidden mode-line enabled.")))

(defvar my/keys-minor-mode-map
  (make-sparse-keymap)
  "My/keys-minor-mode keymap.")

(define-minor-mode my/keys-minor-mode
  "A minor mode to override any major mode with my keys."
  :init-value t
  :lighter " my/keys")

(my/keys-minor-mode 1)

(defvar my/slisp-minor-mode-map
  (make-sparse-keymap)
  "My/slisp-minor-mode keymap.")

(define-minor-mode my/slisp-minor-mode
  "A minor mode to make editing s-expressions with evil easier."
  :init-value nil
  :lighter " my/slisp")

;;;================================;;;
;;; FUNCTIONS                      ;;;
;;;================================;;;

;; TODO: bind temp key to current expression

(defun my/extend-list (list-var elements)
  "Extend LIST-VAR with ELEMENTS."
  (let ((list (symbol-value list-var)))
    (if list
        (setcdr (last list) elements)
      (set list-var elements)))
  (symbol-value list-var))

(defun my/is-under-git-vc ()
  "Return t if the current file is under git version control."
  (and (buffer-file-name)
       (file-exists-p (buffer-file-name))
       (car (vc-git-branches))))

(defun my/highlight-comments ()
  "Highlight specific strings in comments."
  (font-lock-add-keywords nil '(("\\<\\(FIXME\\|TODO\\|NOTE\\):"
                                 1 'font-lock-warning-face t))))

(defun my/suppress-messages (old-fun &rest args)
  "Suppress minibuffer messages of OLD-FUN taking ARGS."
  (cl-flet ((silence (&rest args1) (ignore)))
    (advice-add 'message :around #'silence)
    (unwind-protect
        (apply old-fun args)
      (advice-remove 'message #'silence))))

(defun my/face-under-cursor (point)
  "Get the current face under the cursor (at POINT)."
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face)
      (message "No face at %d" point))))

(defun my/delete-desktop-file ()
  "Delete the desktop file used to restore the previous working environment."
  (interactive)
  (let ((desktop-file "~/.emacs.d/.emacs.desktop")
        (desktop-lock-file "~/.emacs.d/.emacs.desktop.lock"))
    (if (file-exists-p desktop-file)
        (progn
          (delete-file desktop-file t)
          (delete-file desktop-lock-file t)
          (message "Deleted desktop file."))
      (message "Desktop file not found or already deleted."))))

(defun my/flycheck-toggle-error-list ()
  "Toggle the display of the flycheck error list."
  (interactive)
  (let ((window (flycheck-get-error-list-window)))
    (if window
        (delete-window window)
      (flycheck-list-errors))))

(defun my/current-file-size ()
  "Get the size of the current file being edited."
  (interactive)
  (if (and (buffer-file-name)
           (file-exists-p (buffer-file-name)))
      (let ((attr (file-attributes (buffer-file-name))))
        (file-size-human-readable (nth 7 attr)))
    ""))

(defun my/abbreviate-path (path)
  "Abbreviate a file path (as PATH) to use only single letters to refer to directories."
  (let* ((path-list (split-string
                     (abbreviate-file-name path) "/"))
         (chars (mapcar (lambda (dir-string)
                          (substring dir-string 0 1))
                        path-list)))
    (concat
     (mapconcat 'identity (reverse (cdr (reverse chars)))
                "/")
     "/"
     (car (last path-list)))))

(defun my/eval-root-sexp ()
  "Evaluate the top level s-expression if available."
  (interactive)
  (save-excursion
    (while (in-string-p)
      (forward-char))
    (up-list (car (syntax-ppss)))
    (elisp--eval-last-sexp nil)))

(defun my/evil-eval-at-eol (fun)
  "Evaluate function FUN at end of line."
  (end-of-line)
  (funcall fun)
  (evil-append nil))

(defun my/writable-line-next ()
  "Go to the next writable line."
  (interactive)
  (evil-next-line)
  (while (get-text-property (point) 'read-only)
      (evil-next-line)))

(defun my/writable-line-prev ()
  "Go to the prev writable line."
  (interactive)
  (evil-previous-line)
  (while (get-text-property (point) 'read-only)
      (evil-previous-line)))

(defun my/file-buffer-next ()
  "Switch to next file buffer."
  (interactive)
  (evil-next-buffer)
  (while (or (minibufferp)
             (string-match "*" (buffer-name)))
    (evil-next-buffer)))

(defun my/file-buffer-prev ()
  "Switch to prev file buffer."
  (interactive)
  (evil-prev-buffer)
  (while (or (minibufferp)
             (string-match "*" (buffer-name)))
    (evil-prev-buffer)))

(defun my/buffer-face-mode-serif ()
  "Set font to serif for this buffer."
  (interactive)
  (setq buffer-face-mode-face '(:family "Palatino" :height 160))
  (buffer-face-mode))

;;;================================;;;
;;; HOOKS & ADVICE                 ;;;
;;;================================;;;

;; Display color column for python
(add-hook 'python-mode-hook
          (lambda ()
            (turn-on-auto-fill)
            (setq show-trailing-whitespace t)))

;; Highlight TODOs etc
(add-hook 'prog-mode-hook 'my/highlight-comments)

;; No line break in compilation buffer
(add-hook 'compilation-mode-hook (lambda ()
                                   (setq word-wrap nil)))

;; Turn off personal keybinds in the minibuffer
(add-hook 'minibuffer-setup-hook (lambda ()
                                   (my/keys-minor-mode 0)))

;; Use serif font for org-mode
;; (add-hook 'org-mode-hook #'my/buffer-face-mode-serif)

;; Disable mode-line when scrolling with wheel/trackpad
(advice-add 'mac-mwheel-scroll :around (lambda (orig-fun &rest args)
                                         (unless hidden-mode-line-mode
                                           (setq hide-mode-line mode-line-format
                                                 mode-line-format nil))
                                         (apply orig-fun args)
                                         (unless hidden-mode-line-mode
                                           (setq mode-line-format hide-mode-line))))

;;;================================;;;
;;; PACKAGE CONFIG                 ;;;
;;;================================;;;

;; Fix path on OS X
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

;; Vi mode
(use-package evil
  :demand
  :config
  (evil-mode 1)

  (defun my/evil-bind (key-string func)
    "Bind a key (as KEY-STRING) for all evil states (except insert)."
    (define-key evil-normal-state-map (kbd key-string) func)
    (define-key evil-motion-state-map (kbd key-string) func)
    (define-key evil-visual-state-map (kbd key-string) func))

  (defun my/evil-multi-bind (state key-func-pairs)
    "Bind multiple keys to their associated functions (as
    KEY-FUNC-PAIRS) in STATE."
    (mapcar (lambda (pair)
              (define-key state (kbd (car pair)) (cdr pair)))
            key-func-pairs))

  ;; Don't override evil keymaps
  (setq-default evil-overriding-maps nil)
  (setq-default evil-intercept-maps nil)

  ;; Search for visual selection
  (use-package evil-visualstar
    :config (global-evil-visualstar-mode))

  ;; Surround operator
  (use-package evil-surround
    :config (global-evil-surround-mode 1))

  ;; Indent with 4 spaces by default
  (setq evil-shift-width 4)

  ;; Motion state as default
  (setq evil-motion-state-modes
        (append evil-emacs-state-modes evil-motion-state-modes)
        evil-emacs-state-modes nil)

  ;; Free up leader keys
  (my/evil-bind "," nil)
  (my/evil-bind "\\" nil)
  (my/evil-bind "SPC" nil)
  (my/evil-bind "s" nil))

;; Vim-like buffer diffs
(use-package vdiff)

;; Better parentheses management
(use-package smartparens
  :demand
  :config
  (setq smartparens-strict-mode t
        sp-highlight-pair-overlay nil
        sp-highlight-wrap-overlay nil
        sp-highlight-wrap-tag-overlay nil)
  (sp-with-modes sp-lisp-modes
    (sp-local-pair "'" nil :actions nil))

  (add-hook 'prog-mode-hook #'smartparens-mode)
  (add-hook 'emacs-lisp-mode-hook #'my/slisp-minor-mode)

  (use-package evil-smartparens
    :config
    (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode)
    ;; Smartparens overwrites evil's backspace action, which
    ;; allows us to delete tabs/spaces in one go. So we map it back.
    (add-hook 'emacs-lisp-mode-hook
              (lambda ()
                (evil-define-key 'insert emacs-lisp-mode-map (kbd "<backspace>")
                  'backward-delete-char-untabify))))

  ;; Slurping, barfing and editing
  (evil-define-key 'normal my/slisp-minor-mode-map
    "W" 'sp-forward-symbol
    "B" 'sp-backward-symbol
    "K" 'sp-split-sexp
    "(" 'sp-up-sexp
    ")" 'sp-down-sexp
    "H" 'sp-beginning-of-sexp
    "L" 'sp-end-of-sexp
    "[" 'sp-previous-sexp
    "]" 'sp-next-sexp)
  :bind (:map smartparens-mode-map
              ("s-h" . sp-backward-barf-sexp)
              ("s-j" . sp-backward-slurp-sexp)
              ("s-k" . sp-forward-slurp-sexp)
              ("s-l" . sp-forward-barf-sexp)
              ("s-t" . sp-transpose-sexp)
              ("s-u" . sp-unwrap-sexp)
              ("s-w" . sp-wrap-entire-symbol)
              ("s-K" . sp-split-sexp)
              ("s-J" . sp-join-sexp)
              ("s-c" . sp-convolute-sexp)))

;; Fast jumping
(use-package ace-jump-mode
  :demand
  :config
  (evil-define-key 'normal my/keys-minor-mode-map
    "sc" 'ace-jump-char-mode
    "sw" 'ace-jump-word-mode
    "sl" 'ace-jump-line-mode))

;; show guide when pressing certain combinations
(use-package which-key
  :demand
  :config
  (which-key-mode)
  (define-key global-map (kbd "M-c k") 'which-key-show-top-level))

;; Editorconfig
(use-package editorconfig
  :demand
  :config (editorconfig-mode 1))

;; Use tags files
(use-package ggtags)

;; Auto completion
(use-package company
  :demand
  :config
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1)
  (add-hook 'after-init-hook 'global-company-mode)
  (define-key company-active-map
    (kbd "<tab>") 'company-complete-common-or-cycle)
  (define-key company-active-map
    (kbd "<backtab>") 'company-select-previous)

  ;; TODO: Fix broken evil-repeat after completion
  (mapc #'evil-declare-change-repeat
        '(company-complete-mouse
          company-complete-selection
          company-complete-common))
  (mapc #'evil-declare-ignore-repeat
        '(company-abort
          company-select-next
          company-select-previous
          company-select-next-or-abort
          company-select-previous-or-abort
          company-select-mouse
          company-show-doc-buffer
          company-show-location
          company-search-candidates
          company-filter-candidates)))

;; AucTeX
(use-package tex
  :demand
  :ensure auctex
  :mode "\\.tex\\'"
  :config
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-PDF-mode t
        TeX-electric-math nil)
  (setq-default TeX-master nil
                TeX-engine 'xetex
                word-wrap t))

;; Ivy
(use-package counsel
  :demand
  :config
  (ivy-mode 1)
  (defun my/ivy-partial-or-next ()
    "FIXME Try to tab complete and go to next line if this fails."
    (interactive)
    (ivy-partial)
    (ivy-next-line))

  (defun my/counsel-mdfind-function (string &rest _unused)
    "Use macOSs mdfind utility to search for files."
    (if (< (length string) 4)
        (ivy-more-chars)
      (counsel--async-command
       (format "mdfind -onlyin ~/ '%s'" string))
      nil))

  (defun my/counsel-spotlight (&optional initial-input)
    "Open file using spotlight. TODO: add sorting function."
    (interactive)
    (ivy-read "spotlight: " 'my/counsel-mdfind-function
              :initial-input initial-input
              :dynamic-collection t
              :sort t
              :action (lambda (x)
                        (when (string-match "\\(\/.*\\)\\'" x)
                          (let ((file-name (match-string 1 x)))
                            (find-file file-name))))))

  (setq ivy-use-virtual-buffers t
        ivy-count-format "%d/%d "
        ivy-height 16
        ivy-wrap t)

  ;; Ivy-bibtex integration
  (use-package ivy-bibtex
    :disabled
    :mode "\\.tex\\'"
    :init (defvar LaTeX-mode-map)
    :config
    (setq bibtex-completion-bibliography "~/Documents/library.bib"
          bibtex-completion-pdf-field "file"
          bibtex-completion-display-formats
          '((t . "${author:36} ${title:52} ${journal:36} ${year:4}"))
          bibtex-completion-pdf-open-function (lambda (fpath) (call-process "open" nil 0 nil fpath))
          ivy-bibtex-default-action 'ivy-bibtex-insert-citation
          bibtex-completion-cite-prompt-for-optional-arguments nil)
    :bind (:map LaTeX-mode-map
                ("M-e b" . ivy-bibtex)))

  ;; Counsel spotify
  (use-package counsel-spotify
    :disabled
    :config
    (setq counsel-spotify-client-id my/spotify-api-client-id
          counsel-spotify-client-secret my/spotify-api-client-secret)
    :bind (("M-s p" . counsel-spotify-toggle-play-pause)
           ("M-s l" . counsel-spotify-next)
           ("M-s h" . counsel-spotify-previous)
           ("M-s a" . counsel-spotify-search-artist)
           ("M-s t" . counsel-spotify-search-track)))

  ;; Projectile integration
  (use-package counsel-projectile
    :after projectile
    :config (use-package ag)
    :bind (("M-f g" . counsel-projectile-rg)
           ("M-f p" . counsel-projectile-switch-project)
           ("M-f f" . counsel-projectile-find-file)))

  :bind (("M-f b" . ivy-switch-buffer)
         ("M-f r" . counsel-recentf)
         ("M-f l" . my/counsel-spotlight)
         ("M-/" . swiper)
         :map ivy-minibuffer-map
         ("<tab>" . my/ivy-partial-or-next)
         ("<backtab>" . ivy-previous-line)
         ("C-<return>" . ivy-call)
         ("<up>" . ivy-previous-history-element)
         ("<down>" . ivy-next-history-element))
  )

;; Projectile project management
(use-package projectile
  :demand
  :config
  (defun my/intelli-tag ()
    "Use the appropriate tagging system depending on the major mode."
    (interactive)
    (cond ((string-equal major-mode "c++-mode")
           (rtags-find-symbol-at-point))
          ((string-equal major-mode "tuareg-mode")
           (merlin-locate))
          (t (projectile-find-tag))))

  (setq projectile-completion-system 'ivy
        projectile-enable-caching nil)
  (my/extend-list 'projectile-globally-ignored-files
                  '("GRTAGS" "GTAGS" "TAGS" "GPATH"))
  (my/extend-list 'projectile-globally-ignored-file-suffixes
                  '("pyc" "#"))
  (my/extend-list 'projectile-globally-ignored-directories
                  '("__pycache__" ".cache" ".ipynb_checkpoints"))
  :bind (("M-f h" . projectile-find-other-file)
         ("M-f s" . projectile-replace)
         ("M-r t" . projectile-test-project)
         ("M-r r" . projectile-run-project)
         ("M-r b" . projectile-compile-project)))

;; Magit
(use-package magit
  :demand
  :config
  (use-package diff-hl
    :demand
    :config
    ;; Massive trickery to get the indicators exactly where I want them
    (setq diff-hl-margin-symbols-alist
          '((insert . "▍")
            (change . "▍")
            (delete . "▍")
            (unknown . "▍")
            (ignored . "▍")))

    (global-diff-hl-mode)
    (diff-hl-margin-mode 1)
    (add-hook 'magit-post-refresh-hook #'diff-hl-update)
    :bind (:map my/keys-minor-mode-map
                ("M-c g" . global-diff-hl-mode)))
  (use-package evil-magit)

  ;; Magit popups should use emacs state
  (setq evil-motion-state-modes (delete 'magit-popup-mode evil-motion-state-modes))
  (add-to-list 'evil-emacs-state-modes 'magit-popup-mode)
  :bind (("M-g s" . magit-status)))

;; Ranger file manager
(use-package ranger
  :demand
  :bind (("M-f n" . ranger)))

;; File/Tag tree
(use-package treemacs
  :demand
  :config
  (setq treemacs-git-integration t
        treemacs-no-png-images t)
  (use-package treemacs-evil
    :demand
    :after treemacs)
  (use-package treemacs-projectile
    :demand
    :after treemacs)
  :bind (("M-f t" . treemacs)))

;; Syntax checker
(use-package flycheck
  :config
  ;; That double arrow is ugly
  (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
    (vector #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00010000
            #b00011000
            #b00011100
            #b00011110
            #b00011111
            #b00011110
            #b00011100
            #b00011000
            #b00010000
            #b00000000
            #b00000000
            #b00000000
            #b00000000))
  (use-package flycheck-mypy)
  (add-hook 'after-init-hook #'global-flycheck-mode)
  ;; THIS LINE WILL FUCK UP EMACS REALLY BADLY
  ;; (add-hook 'evil-normal-state-entry-hook #'flycheck-buffer)
  (setq flycheck-check-syntax-automatically
        '(mode-enabled save))
  (add-to-list 'display-buffer-alist
               `(,(rx bos "*Flycheck errors*" eos)
                 (display-buffer-reuse-window
                  display-buffer-in-side-window)
                 (side . bottom)
                 (reuseable-frames . visible)
                 (window-height . 0.33)))
  :bind (("M-f e" . my/flycheck-toggle-error-list)))

;; Rainbow parens for lisp
(use-package rainbow-delimiters
  :config (add-hook 'emacs-lisp-mode-hook
                    (lambda ()
                      (rainbow-delimiters-mode 1))))

;; Highlight numbers
(use-package highlight-numbers
  :config (add-hook 'prog-mode-hook #'highlight-numbers-mode))

;; Better C++ syntax highlighting
(use-package modern-cpp-font-lock
  :config
  (add-hook 'cc-mode-hook 'modern-c++-font-lock-mode)
  (setq modern-c++-operators '("&" "::" "+" "-" "*" "/" "=")
        modern-c++-literal-boolean t
        modern-c++-literal-integer t
        modern-c++-literal-string t
        modern-c++-literal-null-pointer t))

;; Highlight color codes
(use-package rainbow-mode
  :bind (("M-c c" . rainbow-mode)))

;; Show a column at 80 chars etc
(use-package fill-column-indicator
  :config
  ;; https://github.com/alpaker/Fill-Column-Indicator/issues/54#issuecomment-218344694
  (advice-add 'company-call-frontends :before
              (lambda (command)
                (if (string-equal major-mode "python-mode")
                    (progn (when (string-equal "show" command)
                             (turn-off-fci-mode))
                           (when (string-equal "hide" command)
                             (turn-on-fci-mode))))))

  (add-hook 'python-mode-hook
            (lambda ()
              (fci-mode 1)
              (set-fill-column 120)
              (redraw-display))))

;; Fringe markers
(use-package evil-fringe-mark
  :disabled
  :config (global-evil-fringe-mark-mode))

;; Highlight undo, redo etc...
(use-package volatile-highlights
  :disabled
  :config
  (vhl/define-extension 'evil 'evil-paste-after 'evil-paste-before
                        'evil-paste-pop 'evil-move)
  (vhl/install-extension 'evil)
  :bind (("M-c v" . volatile-highlights-mode)))

;; Extra icons
(use-package all-the-icons
  :config
  (use-package all-the-icons-ivy
    :disabled
    :after counsel
    :config (all-the-icons-ivy-setup)))

;; Lean
(use-package lean-mode)

;; Rust
(use-package rust-mode)

;; Python
(use-package python-mode)

;; Markdown
(use-package markdown-mode)

;; OCaml
(use-package tuareg
  :disabled
  :preface
  ;; Setup merlin
  (let ((opam-share (ignore-errors
                      (car (process-lines "opam" "config" "var" "share")))))
    (when (and opam-share (file-directory-p opam-share))
      (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
      (autoload 'merlin-mode "merlin" nil t nil)
      (add-hook 'tuareg-mode-hook 'merlin-mode t)
      (add-hook 'caml-mode-hook 'merlin-mode t)
      (setq merlin-command 'opam)
      (add-to-list 'company-backends 'merlin-company-backend)))
  :config
  (setq tuareg-match-patterns-aligned t)
  (evil-define-key 'normal tuareg-mode-map
    (kbd "]]") 'merlin-phrase-next
    (kbd "[[") 'merlin-phrase-prev)
  :bind
  (:map merlin-mode-map
        ("SPC t" . merlin-type-enclosing)
        ("C-o" . merlin-pop-stack)))

;; Python stuff
(use-package conda
  :ensure t
  :demand
  :preface
  (custom-set-variables
   '(conda-anaconda-home (expand-file-name "~/anaconda3/")))
  :config
  (conda-env-initialize-interactive-shells)
  (setq conda-env-home-directory (expand-file-name "~/anaconda3/")
        conda-anaconda-home (expand-file-name "~/anaconda3/"))
  ;; (conda-env-activate "psi")
  )

;; Language Server Protocol
(use-package lsp-mode
  :init (setq lsp-keymap-prefix "s-p")
  :hook ((python-mode . lsp)
         (c++-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (setq lsp-enable-snippet t)
  (use-package company-lsp
    :demand
    :config (setq company-lsp-cache-candidates 'auto))
  (use-package lsp-treemacs)
  (use-package lsp-ivy)
  (use-package lsp-rust
    :disabled))

;; Jupyter
(use-package jupyter)

;; EIN
(use-package ein
  :disabled
  :config
  (use-package websocket)
  (use-package request)
  (use-package deferred)
  (use-package skewer-mode)

  ;; Jedi interoperability
  ;; (add-hook 'ein:connect-mode-hook 'ein:jedi-setup)

  ;; Default to multilang mode
  (setq ein:notebook-modes '(ein:notebook-multilang-mode ein:notebook-python-mode))
  (setq ein:notebook-create-checkpoint-on-save t
        ein:notebook-kill-buffer-ask t
        ein:use-auto-complete t
        ein:complete-on-dot t)

  (define-key global-map (kbd "M-e n")
    (lambda ()
      (interactive)
      (let ((jupyter-path (concat conda-env-home-directory "envs/" conda-env-current-name "/bin/jupyter"))
            (jupyter-directory default-directory)
            (jupyter-server "http://127.0.0.1")
            (jupyter-port "8888")
            (jupyter-pass ""))
        (ein:jupyter-server-start jupyter-path jupyter-directory)
        (let ((notebook-url (concat jupyter-server ":" jupyter-port)))
          (ein:notebooklist-login notebook-url jupyter-pass)))))
          ;; (ein:notebooklist-open notebook-url)
          

  ;; Paste above
  (defun yank-cell-above ()
    (interactive)
    (ein:worksheet-goto-prev-input)
    (ein:worksheet-yank-cell))

  ;; Vim like keybinds
  (evil-define-key 'normal ein:notebook-python-mode-map
    (kbd "<C-return>") 'ein:worksheet-execute-cell
    (kbd "<S-return>") 'ein:worksheet-execute-cell-and-goto-next
    (kbd "<return>") 'ein:worksheet-execute-cell
    (kbd "C-]") 'ein:pytools-jump-to-source-command
    (kbd "C-o") 'ein:pytools-jump-back-command
    (kbd "j") 'my/writable-line-next
    (kbd "k") 'my/writable-line-prev
    (kbd "]") 'ein:worksheet-goto-next-input
    (kbd "[") 'ein:worksheet-goto-prev-input
    (kbd "M-e s") 'ein:notebook-save-notebook-command
    (kbd "M-e r") 'ein:notebook-restart-kernel-command
    (kbd "M-e i") 'ein:notebook-kernel-interrupt-command
    (kbd "M-e e") 'ein:notebook-view-traceback
    (kbd "M-e t") 'ein:worksheet-toggle-output
    (kbd "M-e O") 'ein:worksheet-insert-cell-above
    (kbd "M-e o") 'ein:worksheet-insert-cell-below
    (kbd "M-e j") 'ein:worksheet-move-cell-down
    (kbd "M-e k") 'ein:worksheet-move-cell-up
    (kbd "M-e J") 'ein:worksheet-merge-cell
    (kbd "M-e K") 'ein:worksheet-split-cell-at-point
    (kbd "M-e m") 'ein:worksheet-toggle-cell-type
    (kbd "M-e y") 'ein:worksheet-copy-cell
    (kbd "M-e d") 'ein:worksheet-kill-cell
    (kbd "M-e p") 'ein:worksheet-yank-cell
    (kbd "M-e P") 'yank-cell-above)

  (evil-define-key 'insert ein:notebook-python-mode-map
    (kbd "<C-return>") 'ein:worksheet-execute-cell
    (kbd "<S-return>") 'ein:worksheet-execute-cell-and-goto-next
    (kbd "C-]") 'ein:pytools-jump-to-source-command
    (kbd "C-o") 'ein:pytools-jump-back-command
    (kbd "<backtab>") 'ein:pytools-request-tooltip-or-help
    (kbd "<tab>") 'ein:completer-complete))

;;;================================;;;
;;; MODELINE                       ;;;
;;;================================;;;

;; Faces
(defgroup my/modeline nil
  "Fancy mode-line."
  :group 'mode-line)

(defface my/modeline-active
  '((t (:inherit mode-line)))
  "Base face for mode-line."
  :group 'my/modeline)

(defface my/modeline-inactive
  '((t (:inherit mode-line-inactive)))
  "Base face for inactive mode-line."
  :group 'my/modeline)

(defface my/modeline-evil
  '((t (:foreground "white" :bold t :inherit mode-line)))
  "Base face for evil state indicator."
  :group 'my/modeline)

(defface my/modeline-evil-normal
  '((t (:foreground "blue" :inherit my/modeline-evil)))
  "Face for evil normal state indicator."
  :group 'my/modeline)

(defface my/modeline-evil-insert
  '((t (:foreground "green" :inherit my/modeline-evil)))
  "Face for evil insert state indicator."
  :group 'my/modeline)

(defface my/modeline-evil-replace
  '((t (:foreground "red" :inherit my/modeline-evil)))
  "Face for evil replace state indicator."
  :group 'my/modeline)

(defface my/modeline-evil-operator
  '((t (:foreground "purple" :inherit my/modeline-evil)))
  "Face for evil operator state indicator."
  :group 'my/modeline)

(defface my/modeline-evil-motion
  '((t (:foreground "turquoise" :inherit my/modeline-evil)))
  "Face for evil motion state indicator."
  :group 'my/modeline)

(defface my/modeline-evil-visual
  '((t (:foreground "light blue" :inherit my/modeline-evil)))
  "Face for evil visual state indicator."
  :group 'my/modeline)

(defface my/modeline-evil-emacs
  '((t (:foreground "yellow" :inherit my/modeline-evil)))
  "Face for evil emacs state indicator."
  :group 'my/modeline)

(defcustom my/modeline-separator
  ;; (concat "  " (all-the-icons-octicon "primitive-dot" :height 0.5 :v-adjust 0.2) "  ")
  " ╱ "
  "Separator used between mode-line elements."
  :group 'my/modeline)

(easy-menu-define my/git-menu nil "Git"
  `("Git"))

(defun my/mode-line-make-xpm (color height width)
  "Create an XPM bitmap."
  (propertize
   " " 'display
   (let ((data (make-list height (make-list width 1)))
         (color (or color "None")))
     (create-image
      (concat
       (format "/* XPM */\nstatic char * percent[] = {\n\"%i %i 2 1\",\n\". c %s\",\n\"  c %s\","
               (length (car data))
               (length data)
               color
               color)
       (apply #'concat
              (cl-loop with idx = 0
                       with len = (length data)
                       for dl in data
                       do (cl-incf idx)
                       collect
                       (concat "\""
                               (cl-loop for d in dl
                                        if (= d 0) collect (string-to-char " ")
                                        else collect (string-to-char "."))
                               (if (eq idx len) "\"};" "\",\n")))))
      'xpm t :ascent 'center))))

(defun my/git-menu-populate ()
  "Populate the git branch menu with entries."
  (easy-menu-create-menu
   "Branches"
   (mapcar (lambda (x)
             (vector x `(lambda ()
                          (interactive)
                          (magit-checkout ,x))
                     t))
           (magit-list-refnames))))

(add-hook 'menu-bar-update-hook
          (lambda ()
            (easy-menu-add-item my/git-menu
                                '() (my/git-menu-populate))))

(defun my/mode-line-evil-state-indicator ()
  "Return a char depending on the current evil mode."
  (let* ((state (cond ((evil-normal-state-p) '("N" . my/modeline-evil-normal))
                      ((evil-insert-state-p) '("I" . my/modeline-evil-insert))
                      ((evil-motion-state-p) '("M" . my/modeline-evil-motion))
                      ((evil-emacs-state-p) '("E" . my/modeline-evil-emacs))
                      ((evil-visual-state-p) '("V" . my/modeline-evil-visual))
                      ((evil-replace-state-p) '("R" . my/modeline-evil-replace))
                      ((evil-operator-state-p) '("O" . my/modeline-evil-operator))))
         (state-string (car state))
         (state-face (cdr state)))
    (propertize (my/mode-line-make-xpm (face-foreground state-face nil t) 28 4)
                'face state-face)
    ;; (propertize "■" 'face state-face)
    ;; (propertize (my/mode-line-make-xpm (face-foreground state-face nil t) 10 9)
    ;;             'face state-face)
    ))

(defun my/mode-line-modified-indicator ()
  "Display an indication of whether the buffer is modified or read-only."
  (let* ((mod-icon (all-the-icons-faicon "chain-broken" :height 0.7 :v-adjust -0.0))
         (notmod-icon (all-the-icons-faicon "link" :height 0.7 :v-adjust -0.0))
         (ro-icon (all-the-icons-octicon "lock" :height 0.7 :v-adjust -0.0))
         (state (cond ((buffer-modified-p) mod-icon)
                      ((not (buffer-modified-p)) notmod-icon)
                      ((buffer-read-only) ro-icon))))
    (propertize state))
  ;; (let ((face (cond ((buffer-modified-p) 'my/modeline-evil-replace)
  ;;                   ((not (buffer-modified-p)) 'my/modeline-evil-operator)
  ;;                   ((buffer-read-only) 'my/modeline-evil-insert))))
  ;;   (propertize (my/mode-line-make-xpm (face-foreground face nil t) 10 9)
  ;;               'face face))
  )

(defun my/mode-line-flycheck-indicator ()
  "Display the flycheck status."
  (let* ((issues (if flycheck-current-errors
                     (let ((count (let-alist
                                      (flycheck-count-errors flycheck-current-errors)
                                    (+ (or .warning 0) (or .error 0)))))
                       (format "%s %s" (all-the-icons-octicon "zap" :height 0.8 :v-adjust 0.1) count))
                   (all-the-icons-octicon "check" :height 0.8 :v-adjust 0.1)))
         (text (pcase flycheck-last-status-change
                 ('finished `(,issues . ,(format "%s Issues" issues)))
                 ('running `(,(all-the-icons-octicon "sync" :height 0.8 :v-adjust 0.1) . "Running"))
                 ('no-checker  `(,(all-the-icons-octicon "search" :height 0.8 :v-adjust 0.1) . "No checker"))
                 ('not-checked `(,(all-the-icons-octicon "circle-slash" :height 0.8 :v-adjust 0.1) . "Not checked"))
                 ('errored     `(,(all-the-icons-octicon "bug" :height 0.8 :v-adjust 0.1) . "Errored"))
                 ('interrupted `(,(all-the-icons-octicon "x" :height 0.8 :v-adjust 0.1) . "Interrupted"))
                 ('suspicious `(,(all-the-icons-octicon "gist-secret" :height 0.8 :v-adjust 0.1) . "Suspicious"))))
         (symbol (car text))
         (help-text (cdr text)))
    (propertize symbol 'help-echo help-text
                'mouse-face '(:underline t)
                'local-map (make-mode-line-mouse-map
                            'mouse-1 #'my/flycheck-toggle-error-list))))

(defun my/mode-line-vc-git-indicator ()
  "Display the git status in the mode-line."
  (let* ((current-branch (car (vc-git-branches)))
         (state (pcase (vc-git-state (buffer-file-name))
                  ('up-to-date `(,(all-the-icons-octicon "check" :v-adjust 0.1) . "Up-to-date"))
                  ('edited `(,(all-the-icons-octicon "pencil" :v-adjust 0.15) . "Edited"))
                  ('needs-update `(,(all-the-icons-octicon "cloud-download" :v-adjust 0.1) . "Needs update"))
                  ('needs-merge `(,(all-the-icons-octicon "git-merge" :v-adjust 0.1) . "Needs merge"))
                  ('unlocked-changes `(,(all-the-icons-octicon "shield" :v-adjust 0.1) . "Unlocked changes"))
                  ('added `(,(all-the-icons-octicon "checklist" :v-adjust 0.1) . "Added"))
                  ('removed `(,(all-the-icons-octicon "trashcan" :v-adjust 0.1) . "Removed"))
                  ('conflict `(,(all-the-icons-octicon "zap" :v-adjust 0.1) . "Conflict"))
                  ('missing `(,(all-the-icons-octicon "search" :v-adjust 0.1) . "Missing"))
                  ('ignored `(,(all-the-icons-octicon "x" :v-adjust 0.1) . "Ignored"))
                  ('unregistered `(,(all-the-icons-octicon "question" :v-adjust 0.1) . "Unregistered"))))
         (state-symbol (car state))
         (state-help (cdr state)))
    (if (and (buffer-file-name)
             (file-exists-p (buffer-file-name))
             current-branch)
        (concat
         (propertize (format "%s" (all-the-icons-octicon "git-branch"))
                     'face `(:height 1.0 :family ,(all-the-icons-octicon-family))
                     'display '(raise 0.1))
         (propertize (format " %s " current-branch)
                     'mouse-face '(:underline t)
                     'local-map (make-mode-line-mouse-map
                                 'mouse-1 #'my/git-menu))
         (propertize (format " %s" state-symbol)
                     'face `(:height 0.9 :family ,(all-the-icons-octicon-family))
                     'help-echo state-help))
      "")))

(defun my/mode-line-clock ()
  "Display the current time."
  (concat
   (propertize (all-the-icons-octicon "clock" :v-adjust 0.05)
               'face `(:height 1.0 :family ,(all-the-icons-octicon-family)))
   (propertize (format-time-string "  %R")
               'help-echo (format-time-string "Date: %F"))))

(defun my/mode-line-mode-icon ()
  "Display an icon depending on the current major mode."
  (let* ((family (all-the-icons-icon-family-for-mode major-mode))
         (icon (all-the-icons-icon-for-mode major-mode :v-adjust 0.05
                                            :face `(:height 0.7 :family ,family))))
    (propertize icon 'face 'my/modeline-evil-operator)))

(defun my/mode-line-pad-right (rhs)
  "Pad mode-line to the right using the propertized RHS."
  (let* ((rhs-format (format-mode-line rhs))
         (reserve (length rhs-format)))
    (list (propertize " " 'display
                      `((space :align-to (- right ,reserve))))
          rhs)))

;; Modeline
(setq-default mode-line-format
              (list
               ;; `(:eval (my/mode-line-make-xpm nil 30 2))
               ;; " "
               `(:eval (my/mode-line-evil-state-indicator))
               " "
               `(:eval (propertize "%b" 'face 'my/modeline-evil-replace
                                   'help-echo (buffer-file-name)))
               " "
               `(:eval (my/mode-line-modified-indicator))
               my/modeline-separator
               (propertize "%02l") ":"
               (propertize "%02c")
               " "
               (propertize "%p")
               my/modeline-separator
               `(:eval (my/mode-line-mode-icon))
               " "
               `(:eval (propertize "%m"
                                   'mouse-face '(:underline t)
                                   'local-map (make-mode-line-mouse-map
                                               'mouse-1 #'mouse-major-mode-menu)
                                   'help-echo buffer-file-coding-system))
               my/modeline-separator
               `(:eval (my/mode-line-flycheck-indicator))
               `(:eval (my/mode-line-pad-right `(,(my/mode-line-vc-git-indicator)
                                                 ;; ,(if (my/is-under-git-vc)
                                                 ;;      my/modeline-separator)
                                                 ;; ,(my/mode-line-clock)
                                                 )))
               ))

;;;================================;;;
;;; ORG                            ;;;
;;;================================;;;

(defun my/org-insert-todo-and-goto-insert-below ()
  "Insert a todo heading below and go to insert mode."
  (interactive)
  (evil-previous-line)
  (my/evil-eval-at-eol
   (lambda ()
     (org-insert-todo-heading nil)))
  (evil-append 1))

(defun my/org-insert-todo-and-goto-insert-above ()
  "Insert a todo heading above and go to insert mode."
  (interactive)
  (evil-previous-line)
  (my/evil-eval-at-eol
   (lambda ()
     (org-insert-todo-heading nil)))
  (evil-append 1))

(defun my/org-insert-heading-and-goto-insert-below ()
  "Insert a heading below and go to insert mode."
  (interactive)
  (my/evil-eval-at-eol
   (lambda ()
     (org-insert-heading-after-current)))
  (evil-append 1))

(defun my/org-insert-heading-and-goto-insert-above ()
  "Insert a heading above and go to insert mode."
  (interactive)
  (evil-previous-line)
  (my/evil-eval-at-eol
   (lambda ()
     (org-insert-heading-after-current)))
  (evil-append 1))

(defun my/org-archive ()
  "Archive all done tasks older than two weeks."
  (interactive)
  (org-map-entries
   (lambda ()
     (when (org-entry-is-done-p)
       (org-archive-subtree)
       (setq org-map-continue-from (outline-previous-heading))))
  "+CLOSED<=\"<-2w>\""  'tree))

;; Config
(use-package org
  :demand
  :config
  (setq org-log-done t
        org-hide-emphasis-markers nil
        org-agenda-files
        (file-expand-wildcards "~/org/*.org")
        org-confirm-babel-evaluate nil
        org-src-tab-acts-natively t
        org-src-fontify-natively t
        org-pretty-entities t
        org-enforce-todo-checkbox-dependencies t
        org-enforce-todo-dependencies t
        org-preview-latex-default-process 'dvipng
        org-latex-listings 'minted
        org-latex-listings-options '(("breaklines" "true"))
        org-latex-pdf-process
        '("xelatex -interaction nonstopmode -shell-escape %f"
          "xelatex -interaction nonstopmode -shell-escape %f")
        org-image-actual-width nil
        org-agenda-dim-blocked-tasks t
        org-todo-keywords
        '((sequence "TODO" "WAITING" "FEEDBACK" "HOLD" "|" "DONE" "WAIVED"))
        org-todo-keyword-faces
        '(("WAITING" . org-special-keyword)
          ("FEEDBACK" . org-special-keyword)
          ("WAIVED" . org-done)
          ("HOLD" . org-scheduled-previously))
        org-catch-invisible-edits 'error
        ;; FIXME: org opens new frame?!
        org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
           "* TODO %?\n"))
        org-icalendar-timezone "Europe/Berlin"
        org-icalendar-date-time-format ";TZID=%Z:%Y%m%dT%H%M%S"
        org-icalendar-include-todo "all"
        org-archive-location "~/org/archive.org::* Done (from %s)")

  (add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)
  (add-to-list 'org-latex-packages-alist '("" "minted" nil))
  ;; FIXME: `org-toggle-latex-fragment` not defined?
  ;; (add-hook 'org-mode-hook (lambda ()
  ;;                            (add-hook 'evil-insert-state-entry-hook
  ;;                                      'org-toggle-latex-fragment nil t)))
  ;; Keybinds
  (evil-define-key 'normal org-mode-map
    (kbd "<return>") 'org-ctrl-c-ctrl-c
    (kbd "s-o") (lambda ()
                  (interactive)
                  (org-insert-heading-respect-content)
                  (evil-append-line 1))
    (kbd "s-O") 'my/org-insert-heading-and-goto-insert-above
    (kbd "s-t") (lambda ()
                  (interactive)
                  (org-insert-todo-heading-respect-content)
                  (evil-append-line 1))
    (kbd "s-T") 'my/org-insert-todo-and-goto-insert-above
    (kbd "s-d") 'org-todo
    (kbd "s-e a") 'my/org-archive
    (kbd "s-e l y") 'org-store-link
    (kbd "s-e l p") 'org-insert-link
    (kbd "s-e t") 'org-date-from-calendar
    (kbd "s-e w") 'org-babel-tangle
    (kbd "s-e i") 'org-toggle-inline-images
    (kbd "s-e p") 'org-latex-export-to-pdf
    (kbd "s-e s") 'my/buffer-face-mode-serif
    (kbd "s-h") 'org-metaleft
    (kbd "s-l") 'org-metaright
    (kbd "s-k") 'org-metaup
    (kbd "s-j") 'org-metadown
    (kbd "s-H") 'org-shiftmetaleft
    (kbd "s-L") 'org-shiftmetaright
    (kbd "s-K") 'org-shiftmetaup
    (kbd "s-J") 'org-shiftmetadown)
  :bind (("s-e c" . org-capture)))

;; References in org
(use-package org-ref
  :after org)

;; Pretty bullets
(use-package org-bullets
  :after org
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode)))
  (setq org-bullets-bullet-list
        '("⚫" "◉" "⚬" "○")))

;; Ipython integration
(use-package ob-ipython
  :disabled
  :after org
  :config
  (defun my/ob-ipython-join-cell ()
    "Join the current cell with the one below it."
    (interactive)
    (when (org-in-src-block-p)
      (let* ((current-cell (save-excursion
                             (my/ob-ipython-end-of-block)
                             (goto-char (line-beginning-position))
                             (point)))
             (next-cell (save-excursion
                          (org-babel-remove-result)
                          (org-babel-next-src-block)
                          (org-babel-remove-result)
                          (point))))
        (kill-region
         (save-excursion
           (goto-char current-cell)
           (forward-line 1)
           (point))
         (save-excursion
           (goto-char next-cell)
           (forward-line -1)
           (point)))
        (save-excursion (org-babel-next-src-block)
                        (my/ob-ipython-end-of-block)
                        (newline) (yank))
        (delete-region current-cell
                       (save-excursion
                         (org-babel-next-src-block)
                         (line-end-position))))))

  ;; TODO: This could be a lot more intelligent
  (defun my/ob-ipython-split-cell (&optional async)
    "Split the current cell at point with ASYNC flag if non-nil."
    (interactive)
    (when (org-in-src-block-p)
      (newline)
      (insert (concat "\n#+END_SRC\n"
                      "\n#+BEGIN_SRC ipython :session"
                      (if async " :async")
                      "\n"))))

  (defun my/ob-ipython-insert-cell (&optional async)
    "Insert new code block at point with ASYNC flag if non-nil."
    (let ((maybe-async (if async
                           " :async"
                         nil)))
      (insert (concat "\n#+BEGIN_SRC ipython" " :session"
                      maybe-async "\n" "\n#+END_SRC\n"))
      (evil-previous-line 2)
      (evil-insert 1)))

  (defun my/ob-ipython-insert-cell-above ()
    "Insert new code block above the cursor or current cell."
    (interactive)
    (if (org-in-src-block-p)
        (goto-char (org-element-property
                    :begin (org-element-context))))
    (evil-previous-line 1)
    (my/ob-ipython-insert-cell))

  (defun my/ob-ipython-insert-cell-below ()
    "Insert new code block below the cursor or current cell."
    (interactive)
    (cond ((or (my/ob-ipython-between-cell-and-result-p)
               (org-in-src-block-p))
           (goto-char (org-element-property
                       :end (org-element-context)))
           (my/ob-ipython-jump-out-of-result))
          ((or (my/ob-ipython-result-p)
               (my/ob-ipython-full-result-p))
           (my/ob-ipython-jump-out-of-result))
          (t (evil-next-line 1)))
    (my/ob-ipython-insert-cell))

  (defun my/ob-ipython-full-result-p ()
    "Return t if the result has one or more lines, nil otherwise."
    (or
     ;; Top line (RESULT...)
     (and (my/ob-ipython-result-p)
          (not (string-empty-p (org-element-property
                                :value (org-element-context)))))
     ;; In the body
     (save-excursion
       (goto-char (line-beginning-position))
       (not (= (point) (org-babel-result-end))))))

  (defun my/ob-ipython-result-p ()
    "Return t if the cursor is on a result, nil otherwise."
    (let ((line (thing-at-point 'line t)))
      (when (string-match org-babel-results-keyword line)
        t)))

  (defun my/ob-ipython-between-cell-and-result-p ()
    "Return t if cursor is between a src block and a result."
    (and (not (org-in-src-block-p))
         (save-excursion
           (goto-char (org-element-property
                       :end (org-element-context)))
           (my/ob-ipython-result-p))))

  (defun my/ob-ipython-jump-out-of-result ()
    "Jump out of the result, regardless of length etc."
    (interactive)
    (when (or (my/ob-ipython-result-p)
              (my/ob-ipython-full-result-p))
      (evil-next-line 1)
      (goto-char (line-beginning-position))
      (goto-char (org-babel-result-end))
      (if (my/ob-ipython-full-result-p)
          (evil-next-line 1))))

  (defun my/ob-ipython-delete-cell ()
    "Delete the current cell."
    (interactive)
    (org-babel-remove-result)
    (let ((boundaries (my/ob-ipython-block-boundaries)))
      (delete-region (car boundaries)
                     (cdr boundaries))))

  (defun my/ob-ipython-block-boundaries ()
    "Return boundaries if inside a src block, nil otherwise."
    (let* ((case-fold-search t))
      (org-between-regexps-p "^[ \t]*#\\+begin_.*"
                             "^[ \t]*#\\+end_.*")))

  (defun my/ob-ipython-beginning-of-block ()
    "Move the cursor to the beginning of the block."
    (interactive)
    (goto-char (car (my/ob-ipython-block-boundaries))))

  (defun my/ob-ipython-end-of-block ()
    "Move the cursor to the beginning of the block."
    (interactive)
    (goto-char (cdr (my/ob-ipython-block-boundaries))))

  (defun my/ob-ipython-beginning-of-block-content ()
    "Move the cursor to the beginning of the block content."
    (interactive)
    (my/ob-ipython-beginning-of-block)
    (while (org-at-block-p)
      (forward-line))
    (point))

  (defun my/ob-ipython-end-of-block-content ()
    "Move the cursor to the end of the block content."
    (interactive)
    (my/ob-ipython-end-of-block)
    (forward-line -1)
    (end-of-line)
    (point))

  (evil-define-text-object my/ob-ipython-around-cell (count)
    "Select around the cell."
    :type 'line
    (interactive "<c>")
    (-cons-to-list (my/ob-ipython-block-boundaries)))

  (evil-define-text-object my/ob-ipython-inner-cell (count)
    "Select inside the cell."
    :type 'line
    (interactive "<c>")
    `(,(save-excursion (my/ob-ipython-beginning-of-block-content))
      ,(save-excursion (my/ob-ipython-end-of-block-content))))

  (dolist (mode '(operator visual))
    (evil-define-key mode org-mode-map
      "ic" 'my/ob-ipython-inner-cell
      "ac" 'my/ob-ipython-around-cell))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((ipython . t)
     (emacs-lisp . t)
     (shell . t))))

;; Polymode
(use-package polymode
  :disabled t
  :config (add-to-list 'auto-mode-alist '("\\.org" . poly-org-mode)))

;;;================================;;;
;;; INTERFACE                      ;;;
;;;================================;;;

;; Set default font
(when (eq system-type 'darwin)
  (set-face-attribute 'default nil :family "Fantasque Sans Mono" :height 140))

;; Set title bar to frame background on macOS
(when (eq system-type 'darwin)
  (setq default-frame-alist '((ns-transparent-titlebar . t) (ns-appearance . dark))))

;; Default frame size
(add-hook 'after-init-hook (lambda ()
                             (when (and window-system
                                        (not (file-exists-p "~/.emacs.d/.emacs.desktop")))
                               (set-frame-size (selected-frame) 130 56))))

;; Border frame
(set-frame-parameter (selected-frame) 'internal-border-width 1)

;; Split vertically in ediff-mode
(setq ediff-split-window-function 'split-window-horizontally)

;; Smooth scrolling
(setq scroll-conservatively 10000)

;; Keep a margin of 10 lines
(setq scroll-margin 10)

;; Sentences end with space
(setq sentence-end-double-space nil)

;; Indent with spaces
(setq-default indent-tabs-mode nil)

;; Tab key indents at beginning of line, completes otherwise
(setq-default tab-always-indent nil)

;; Backspace deletes whitespace properly
(setq backward-delete-char-untabify-method 'hungry)

;; Get rid of newline at eob
(setq-default require-final-newline nil
              mode-require-final-newline nil)

;; Pretty symbols
(global-prettify-symbols-mode 1)

;; Hide scrollbars, toolbar
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Highlight matching brackets
(show-paren-mode 1)

;; Don't show cursor in other windows
(setq-default cursor-in-non-selected-windows nil)

;; Use a different cursor in emacs mode
(setq-default evil-emacs-state-cursor 'hbar)

;; Don't blink the cursor
(blink-cursor-mode -1)

;; Show line, col in modeline
(line-number-mode t)
(column-number-mode t)

;; Relative line numbers
(setq display-line-numbers-type 'relative)

;; Prettier fringes
(fringe-mode '(10 . 10))
(setq-default left-margin-width 2)
(setq-default right-margin-width 2)

;; Remove annoying bell for abort etc.
(setq visible-bell nil
      ring-bell-function 'ignore)

;; I'm lazy, I stay in bed (dudu dudu duu duu duu duuuu)
(fset 'yes-or-no-p 'y-or-n-p)

;; Theme
(load-theme 'endor t)
(setq endor-use-org-sans nil)

;; Load customizations last
(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;;;================================;;;
;;; KEYBINDINGS                    ;;;
;;;================================;;;

;; Indent with return
(define-key my/keys-minor-mode-map (kbd "RET") 'newline-and-indent)

;; Better window movement
(define-key my/keys-minor-mode-map (kbd "M-j") 'windmove-down)
(define-key my/keys-minor-mode-map (kbd "M-k") 'windmove-up)
(define-key my/keys-minor-mode-map (kbd "M-h") 'windmove-left)
(define-key my/keys-minor-mode-map (kbd "M-l") 'windmove-right)
(define-key my/keys-minor-mode-map (kbd "M-<tab>") 'evil-window-next)

;; Better buffer movement
(define-key my/keys-minor-mode-map (kbd "M-]") 'my/file-buffer-next)
(define-key my/keys-minor-mode-map (kbd "M-[") 'my/file-buffer-prev)
(define-key my/keys-minor-mode-map (kbd "M-}") 'next-buffer)
(define-key my/keys-minor-mode-map (kbd "M-{") 'previous-buffer)
(define-key my/keys-minor-mode-map (kbd "M-<backspace>") 'kill-this-buffer)
(define-key my/keys-minor-mode-map (kbd "M-w") 'kill-buffer-and-window)
(define-key my/keys-minor-mode-map (kbd "M-o") 'delete-other-windows)

;; macOS defaults
(when (eq system-type 'darwin)
  (define-key my/keys-minor-mode-map (kbd "s-q") 'save-buffers-kill-emacs)
  (define-key global-map (kbd "s-v") 'yank))

;; Open emacs config
(define-key my/keys-minor-mode-map (kbd "M-f c")
  (lambda ()
    "Edit emacs config."
    (interactive)
    (find-file "~/.emacs.d/init.el")))

;; Change theme
(define-key my/keys-minor-mode-map (kbd "M-c t") 'load-theme)

;; Hide mode-line
(define-key my/keys-minor-mode-map (kbd "M-c m") 'hidden-mode-line-mode)

;; Highlight current line
(define-key my/keys-minor-mode-map (kbd "M-c h") 'hl-line-mode)

;; Display line numbers
(define-key my/keys-minor-mode-map (kbd "M-c l") 'display-line-numbers-mode)

;; Evaluate elisp buffer
(define-key my/keys-minor-mode-map (kbd "M-c r") 'eval-buffer)

;; Remove dekstop file to get rid of old modes, buffers etc
(define-key my/keys-minor-mode-map (kbd "M-c d") 'my/delete-desktop-file)

;; Show face under cursor
(define-key my/keys-minor-mode-map (kbd "M-c u") 'my/face-under-cursor)

;; Eval top-level sexp regardless of cursor-position
(define-key emacs-lisp-mode-map (kbd "C-j") 'my/eval-root-sexp)

;; Change buffer in modeline by scrolling
(define-key mode-line-buffer-identification-keymap
  (kbd "<mode-line><wheel-up>") 'my/file-buffer-next)
(define-key mode-line-buffer-identification-keymap
  (kbd "<mode-line><wheel-down>") 'my/file-buffer-prev)

;; Increase/decrease text size
(define-key my/keys-minor-mode-map (kbd "s-+") 'text-scale-increase)
(define-key my/keys-minor-mode-map (kbd "s--") 'text-scale-decrease)

;; Escape ALWAYS exits
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key isearch-mode-map [escape] 'isearch-abort)
(define-key isearch-mode-map "\e" 'isearch-abort)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'keyboard-escape-quit)

;; Use projectile tags
(define-key evil-normal-state-map (kbd "C-]") 'my/intelli-tag)

;; Proper yank behaviour
(define-key evil-normal-state-map "Y"
  (lambda ()
    (interactive)
    (evil-yank (point) (point-at-eol))))

;; Substitute line FIXME
(define-key evil-normal-state-map "S"
  (lambda ()
    (interactive)
    (evil-delete-whole-line (point-at-bol) (point-at-eol) 'line ?_)
    (evil-paste-before 1)))

;; Play macro
(define-key evil-normal-state-map "Q"
  (lambda ()
    (interactive)
    (evil-execute-macro 1 last-kbd-macro)))

;; Better line movement
(define-key evil-normal-state-map "L" 'evil-last-non-blank)
(define-key evil-visual-state-map "L" 'evil-last-non-blank)
(define-key evil-normal-state-map "H" 'evil-first-non-blank-of-visual-line)
(define-key evil-visual-state-map "H" 'evil-first-non-blank-of-visual-line)

;; Better vertical line movement
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
(define-key evil-visual-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-visual-state-map (kbd "k") 'evil-previous-visual-line)

;; Comment line
(define-key evil-visual-state-map (kbd "gc") 'comment-dwim)
(define-key evil-normal-state-map (kbd "gcc") 'comment-line)
