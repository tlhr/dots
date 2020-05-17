;;; anderson-theme.el --- Bluefox Theme

;; Copyright 2017-present, All rights reserved
;;
;; Code licensed under the MIT license

;; Author: Thomas Löhr
;; Version: 0.0.1
;; Package-Requires: ((emacs "24"))
;; URL: https://github.com/tlhr/anderson

;;; Commentary:

;; A light color theme for Emacs.

;;; Code:

(deftheme anderson)

(defgroup anderson-theme nil
  "Options for the bluefox theme."
  :group 'faces)

(defcustom anderson-sans-font "DIN"
  "Sans Font to use."
  :group 'anderson-theme
  :type 'string)

(defcustom anderson-serif-font "Palatino"
  "Serif Font to use."
  :group 'anderson-theme
  :type 'string)

(defcustom anderson-tooltip-font-size 140
  "Font size in 1/10 pts to use for tooltips."
  :group 'anderson-theme
  :type 'integer)

(defcustom anderson-modeline-font-size 160
  "Font size in 1/10 pts to use for the modeline."
  :group 'anderson-theme
  :type 'integer)

(defcustom anderson-speedbar-font-size 160
  "Font size in 1/10 pts to use for the speedbar."
  :group 'anderson-theme
  :type 'integer)

(defcustom anderson-use-org-serif nil
  "Whether or not to use a serif font for org mode."
  :group 'anderson-theme
  :type 'boolean)

(let ((class '((class color) (min-colors 89)))
      (fg1              "#c5beba")
      (fg2              "#bab7b7")
      (fg3              "#a49e9a")
      (fg4              "#837d7a")
      (bg1              "#363432")
      (bg2              "#4e4d4c")
      (bg3              "#5f5e5d")
      (bg4              "#645d59")
      (key2             "#be503e")
      (key3             "#c4c18b")
      (builtin          "#c7a095")
      (keyword          "#628b97")
      (const            "#be503e")
      (comment          "#837d7a")
      (func             "#7bb292")
      (str              "#a8c1c5")
      (type             "#d7ae38")
      (var              "#bad4f5")
      (warning          "#f0a4af")
      (rainbow-1        "#d7ae38")
      (rainbow-2        "#c4c18b")
      (rainbow-3        "#c7a095")
      (rainbow-4        "#be503e")
      (rainbow-5        "#f0a4af")
      (rainbow-6        "#bad4f5")
      (rainbow-7        "#a8c1c5")
      (rainbow-8        "#628b97")
      (rainbow-9        "#7bb292"))

  (custom-theme-set-faces
   'anderson
   ;; default
   `(cursor ((,class (:background ,fg2))))
   `(default ((((type nil)) (:background "#000000" :foreground ,fg1))
              (,class (:background ,bg1 :foreground ,fg1))))
   `(default-italic ((,class (:italic t))))
   `(ffap ((,class (:foreground ,fg4))))
   `(fringe ((,class (:background ,bg1 :foreground ,fg1))))
   `(highlight ((,class (:foreground ,fg2 :background ,bg2))))
   `(hl-line ((,class (:background  ,bg2))))
   `(info-quoted-name ((,class (:foreground ,builtin))))
   `(info-string ((,class (:foreground ,str :italic t))))
   `(lazy-highlight ((,class (:foreground ,fg2 :background ,bg3))))
   `(link ((,class (:foreground ,const :underline t))))
   `(minibuffer-prompt ((,class (:bold t :foreground ,const))))
   `(region ((,class (:background ,bg3 :foreground ,fg3))))
   `(show-paren-match-face ((,class (:background ,bg4 :foreground ,rainbow-7))))
   `(show-paren-mismatch-face ((,class (:background ,bg4 :foreground ,rainbow-8))))
   `(trailing-whitespace ((,class :foreground nil :background ,fg2)))
   `(vertical-border ((,class (:foreground ,bg2))))
   `(warning ((,class (:foreground ,warning))))
   `(whitespace-trailing ((,class :inherit trailing-whitespace)))
   ;; linum
   `(linum ((,class (:foreground ,bg4 :background ,bg1 :bold nil :underline nil))))
   `(linum-highlight-face ((,class (:foreground ,var :background ,bg1 :bold nil :underline nil))))
   `(linum-relative-current-face ((,class (:foreground ,var :background ,bg1 :bold nil :underline nil))))
   ;; flycheck
   `(flycheck-error ((,class (:underline ,const))))
   `(flycheck-warning ((,class (:underline ,type))))
   `(flycheck-info ((,class (:underline ,keyword))))
   `(flycheck-error-list-error ((,class (:foreground ,const :bold t))))
   `(flycheck-error-list-warning ((,class (:foreground ,type :bold t))))
   `(flycheck-error-list-info ((,class (:foreground ,keyword :bold t))))
   `(flycheck-error-list-line-number ((,class (:foreground ,fg1))))
   `(flycheck-error-list-column-number ((,class (:foreground ,fg1))))
   `(flycheck-error-list-checker-name ((,class (:foreground ,const))))
   `(flycheck-fringe-error ((,class (:foreground ,const))))
   `(flycheck-fringe-warning ((,class (:foreground ,type))))
   `(flycheck-fringe-info ((,class (:foreground ,keyword))))
   ;; interface
   `(custom-face-tag ((,class (:foreground ,func :bold t))))
   `(custom-variable-tag ((,class (:foreground ,func :bold t))))
   `(custom-group-tag ((,class (:foreground ,func :bold t))))
   `(tooltip ((,class (:family ,anderson-sans-font :height ,anderson-tooltip-font-size :foreground ,bg1 :background ,fg2))))
   ;; Ac
   `(ac-candidate-face ((,class (:background ,bg3 :foreground ,fg1))))
   `(ac-candidate-mouse-face ((,class (:background ,builtin :foreground ,fg1))))
   `(ac-completion-face ((,class (:underline t :foreground ,keyword))))
   `(ac-selection-face ((,class (:background ,keyword :foreground ,bg1))))
   ;; Header
   `(header-line ((,class (:background ,bg3 :foreground ,fg1))))
   ;; Info
   `(info-header-node ((,class (:foreground ,key2 :italic t :bold t))))
   `(info-header-xref ((,class (:foreground ,const :underline t))))
   `(info-index-match ((,class (:foreground ,fg1 :background ,builtin))))
   `(info-menu-header ((,class (:foreground ,fg1 :bold t))))
   `(info-menu-star ((,class (:foreground ,const))))
   `(info-node ((,class (:foreground ,key2 :italic t :bold t))))
   `(info-xref ((,class (:foreground ,const :underline t))))
   ;; auto-highlight-symbol
   `(ahs-definition-face ((,class (:foreground ,bg1 :background ,keyword))))
   `(ahs-edit-mode-face ((,class (:foreground ,bg1 :background ,const))))
   `(ahs-face ((,class (:foreground ,bg1 :background ,builtin))))
   `(ahs-plugin-defalt-face ((,class (:foreground ,bg1 :background ,builtin))))
   `(ahs-plugin-bod-face ((,class (:foreground ,bg1 :background ,keyword))))
   `(ahs-plugin-whole-buffer-face ((,class (:foreground ,bg1 :background ,keyword))))
   ;; guide-key
   `(guide-key/prefix-command-face ((,class (:foreground ,keyword))))
   `(guide-key/highlight-command-face ((,class (:foreground ,const))))
   `(guide-key/key-face ((,class (:foreground ,const))))
   ;; Speedbar
   `(speedbar-button-face ((,class (:family ,anderson-sans-font :height ,anderson-speedbar-font-size :foreground ,type))))
   `(speedbar-directory-face ((,class (:family ,anderson-sans-font :height ,anderson-speedbar-font-size :foreground ,keyword))))
   `(speedbar-file-face ((,class (:family ,anderson-sans-font :height ,anderson-speedbar-font-size :foreground ,fg1))))
   `(speedbar-highlight-face ((,class (:family ,anderson-sans-font :height ,anderson-speedbar-font-size :foreground ,var :bold t))))
   `(speedbar-selected-face ((,class (:family ,anderson-sans-font :height ,anderson-speedbar-font-size :foreground ,var))))
   `(speedbar-tag-face ((,class (:family ,anderson-sans-font :height ,anderson-speedbar-font-size :foreground ,func))))
   `(speedbar-separator-face ((,class (:family ,anderson-sans-font :height ,anderson-speedbar-font-size :foreground ,var :bold t))))
   ;; Emacs Ipython Notebook
   `(ein:cell-input-prompt ((,class (:foreground ,keyword :background ,bg1 :bold t))))
   `(ein:cell-output-prompt ((,class (:foreground ,const :background ,bg1 :bold t))))
   `(ein:cell-input-area ((,class (:background ,bg2))))
   `(ein:cell-output-stderr ((,class (:background ,builtin))))
   `(ein:notification-tab-normal ((,class (:background ,bg2))))
   `(ein:notification-tab-selected ((,class (:foreground ,var :background ,bg2 :bold t))))
   `(ein:pos-tip-face ((,class (:foreground ,bg1 :background ,fg2))))
   ;; syntax
   `(font-lock-builtin-face ((,class (:foreground ,builtin))))
   `(font-lock-comment-face ((,class (:foreground ,comment))))
   `(font-lock-constant-face ((,class (:foreground ,const))))
   `(font-lock-doc-face ((,class (:foreground ,comment :italic t))))
   `(font-lock-function-name-face ((,class (:foreground ,func))))
   `(font-lock-keyword-face ((,class (:bold ,class :foreground ,keyword))))
   `(font-lock-negation-char-face ((,class (:foreground ,const))))
   `(font-lock-reference-face ((,class (:foreground ,const))))
   `(font-lock-string-face ((,class (:foreground ,str :italic t))))
   `(font-lock-type-face ((,class (:foreground ,type :bold t))))
   `(font-lock-variable-name-face ((,class (:foreground ,var))))
   `(font-lock-warning-face ((,class (:foreground ,warning :background ,bg2))))
   `(font-lock-preprocessor-face ((,class (:foreground ,key2))))
   `(font-lock-regexp-grouping-backslash ((,class (:foreground ,builtin))))
   `(font-lock-regexp-grouping-construct ((,class (:foreground ,builtin))))
   ;; ivy
   `(ivy-read-action ((,class (:foreground ,keyword :bold t))))
   `(ivy-confirm-face ((,class (:foreground ,keyword :bold t))))
   `(ivy-current-match ((,class (:background ,bg2))))
   `(ivy-highlight-face ((,class (:foreground ,fg2 :background ,bg2))))
   `(ivy-cursor ((,class (:foreground ,bg1 :background ,fg1))))
   `(ivy-match-required-face ((,class (:foreground ,key2 :bold t))))
   `(ivy-remote ((,class (:foreground ,keyword))))
   `(ivy-subdir ((,class (:foreground ,const))))
   `(ivy-virtual ((,class (:foreground ,type))))
   `(ivy-minibuffer-match-face-1 ((,class (:foreground ,fg1))))
   `(ivy-minibuffer-match-face-2 ((,class (:foreground ,rainbow-2 :bold t))))
   `(ivy-minibuffer-match-face-3 ((,class (:foreground ,rainbow-3 :bold t))))
   `(ivy-minibuffer-match-face-4 ((,class (:foreground ,rainbow-4 :bold t))))
   `(swiper-match-face-1 ((,class (:foreground ,fg1))))
   `(swiper-match-face-2 ((,class (:foreground ,rainbow-2 :bold t))))
   `(swiper-match-face-3 ((,class (:foreground ,rainbow-3 :bold t))))
   `(swiper-match-face-4 ((,class (:foreground ,rainbow-4 :bold t))))
   ;; python
   `(py-number-face ((,class (:foreground ,const))))
   `(py-decorators-face ((,class (:foreground ,const))))
   `(py-exception-name-face ((,class (:foreground ,key2 :bold t))))
   `(py-builtins-face ((,class (:foreground ,var))))
   `(py-variable-name-face ((,class (:foreground ,type))))
   `(py-pseudo-keyword-face ((,class (:foreground ,const :bold t))))
   ;; auto-complete
   `(ac-completion-face ((,class (:underline t :foreground ,keyword))))
   ;; company
   `(company-echo-common ((,class (:foreground ,bg1 :background ,fg1))))
   `(company-preview ((,class (:background ,bg1 :foreground ,key2))))
   `(company-preview-common ((,class (:foreground ,bg2 :background ,fg3))))
   `(company-preview-search ((,class (:foreground ,type :background ,bg1))))
   `(company-scrollbar-bg ((,class (:background ,fg2))))
   `(company-scrollbar-fg ((,class (:background ,keyword))))
   `(company-template-field ((,class (:inherit region))))
   `(company-tooltip ((,class (:foreground ,bg1 :background ,fg3))))
   `(company-tooltip-annotation ((,class (:foreground ,keyword))))
   `(company-tooltip-common ((,class (:foreground ,type))))
   `(company-tooltip-common-selection ((,class (:foreground ,type))))
   `(company-tooltip-mouse ((,class (:inherit highlight))))
   `(company-tooltip-selection ((,class (:foreground ,bg1 :background ,fg2))))
   ;; spaceline
   `(spaceline-evil-emacs ((,class (:foreground ,fg1 :background ,keyword))))
   `(spaceline-evil-insert ((,class (:foreground ,fg1 :background ,builtin))))
   `(spaceline-evil-motion ((,class (:foreground ,fg1 :background ,const))))
   `(spaceline-evil-normal ((,class (:foreground ,fg1 :background ,type))))
   `(spaceline-evil-replace ((,class (:foreground ,fg1 :background ,func))))
   `(spaceline-evil-visual ((,class (:foreground ,fg1 :background ,str))))
   `(spaceline-flycheck-error ((,class (:foreground ,const))))
   `(spaceline-flycheck-warning ((,class (:foreground ,type))))
   `(spaceline-flycheck-info ((,class (:foreground ,keyword))))
   `(spaceline-highlight-face ((,class (:foreground ,fg1 :background ,type))))
   `(spaceline-modified ((,class (:foreground ,fg1 :background ,keyword))))
   `(spaceline-python-venv ((,class (:foreground ,var))))
   `(spaceline-read-only ((,class (:foreground ,fg1 :background ,builtin))))
   `(spaceline-unmodified ((,class (:foreground ,fg1 :background ,type))))
   ;; diff-hl
   `(diff-hl-change ((,class (:foreground ,rainbow-5 :background ,rainbow-5))))
   `(diff-hl-delete ((,class (:foreground ,rainbow-9 :background ,rainbow-9))))
   `(diff-hl-insert ((,class (:foreground ,rainbow-6 :background ,rainbow-6))))
   ;; enh-ruby
   `(enh-ruby-heredoc-delimiter-face ((,class (:foreground ,str))))
   `(enh-ruby-op-face ((,class (:foreground ,keyword))))
   `(enh-ruby-regexp-delimiter-face ((,class (:foreground ,str))))
   `(enh-ruby-string-delimiter-face ((,class (:foreground ,str))))
   ;; font-latex
   `(font-latex-bold-face ((,class (:foreground ,type))))
   `(font-latex-italic-face ((,class (:foreground ,fg1 :italic t))))
   `(font-latex-match-reference-keywords ((,class (:foreground ,const))))
   `(font-latex-match-variable-keywords ((,class (:foreground ,var))))
   `(font-latex-string-face ((,class (:foreground ,str))))
   `(font-latex-sedate-face ((,class (:foreground ,const))))
   `(font-latex-sectioning-0-face ((,class (:foreground ,const :bold t))))
   `(font-latex-sectioning-1-face ((,class (:foreground ,const :bold t))))
   `(font-latex-sectioning-2-face ((,class (:foreground ,const :bold t))))
   `(font-latex-sectioning-3-face ((,class (:foreground ,const :bold t))))
   `(font-latex-sectioning-4-face ((,class (:foreground ,const :bold t))))
   `(font-latex-sectioning-5-face ((,class (:foreground ,const :bold t))))
   ;; gnus-group
   `(gnus-group-mail-1 ((,class (:foreground ,keyword :bold t))))
   `(gnus-group-mail-1-empty ((,class (:inherit gnus-group-mail-1 :bold nil))))
   `(gnus-group-mail-2 ((,class (:foreground ,const :bold t))))
   `(gnus-group-mail-2-empty ((,class (:inherit gnus-group-mail-2 :bold nil))))
   `(gnus-group-mail-3 ((,class (:foreground ,comment :bold t))))
   `(gnus-group-mail-3-empty ((,class (:inherit gnus-group-mail-3 :bold nil))))
   `(gnus-group-mail-low ((,class (:foreground ,bg4 :bold t))))
   `(gnus-group-mail-low-empty ((,class (:inherit gnus-group-mail-low :bold nil))))
   `(gnus-group-news-1 ((,class (:foreground ,keyword :bold t))))
   `(gnus-group-news-1-empty ((,class (:inherit gnus-group-news-1 :bold nil))))
   `(gnus-group-news-2 ((,class (:foreground ,const :bold t))))
   `(gnus-group-news-2-empty ((,class (:inherit gnus-group-news-2 :bold nil))))
   `(gnus-group-news-3 ((,class (:foreground ,comment :bold t))))
   `(gnus-group-news-3-empty ((,class (:inherit gnus-group-news-3 :bold nil))))
   `(gnus-group-news-4 ((,class (:inherit gnus-group-news-low))))
   `(gnus-group-news-4-empty ((,class (:inherit gnus-group-news-low-empty))))
   `(gnus-group-news-5 ((,class (:inherit gnus-group-news-low))))
   `(gnus-group-news-5-empty ((,class (:inherit gnus-group-news-low-empty))))
   `(gnus-group-news-6 ((,class (:inherit gnus-group-news-low))))
   `(gnus-group-news-6-empty ((,class (:inherit gnus-group-news-low-empty))))
   `(gnus-group-news-low ((,class (:foreground ,bg4 :bold t))))
   `(gnus-group-news-low-empty ((,class (:inherit gnus-group-news-low :bold nil))))
   `(gnus-header-content ((,class (:foreground ,keyword))))
   `(gnus-header-from ((,class (:foreground ,var))))
   `(gnus-header-name ((,class (:foreground ,type))))
   `(gnus-header-subject ((,class (:foreground ,func :bold t))))
   `(gnus-summary-markup-face ((,class (:foreground ,const))))
   `(gnus-summary-normal-ancient ((,class (:inherit gnus-summary-normal-read))))
   `(gnus-summary-normal-read ((,class (:foreground ,bg4 :weight normal))))
   `(gnus-summary-normal-ticked ((,class (:foreground ,keyword :weight light))))
   `(gnus-summary-normal-unread ((,class (:foreground ,comment :weight normal))))
   `(gnus-summary-selected ((,class (:inverse-video t))))
   ;; helm
   `(helm-bookmark-w3m ((,class (:foreground ,type))))
   `(helm-buffer-not-saved ((,class (:foreground ,type :background ,bg1))))
   `(helm-buffer-process ((,class (:foreground ,builtin :background ,bg1))))
   `(helm-buffer-saved-out ((,class (:foreground ,fg1 :background ,bg1))))
   `(helm-buffer-size ((,class (:foreground ,fg1 :background ,bg1))))
   `(helm-candidate-number ((,class (:foreground ,bg1 :background ,fg1))))
   `(helm-ff-directory ((,class (:foreground ,func :background ,bg1 :weight bold))))
   `(helm-ff-executable ((,class (:foreground ,key2 :background ,bg1 :weight normal))))
   `(helm-ff-file ((,class (:foreground ,fg1 :background ,bg1 :weight normal))))
   `(helm-ff-invalid-symlink ((,class (:foreground ,key3 :background ,bg1 :weight bold))))
   `(helm-ff-prefix ((,class (:foreground ,bg1 :background ,keyword :weight normal))))
   `(helm-ff-symlink ((,class (:foreground ,keyword :background ,bg1 :weight bold))))
   `(helm-grep-cmd-line ((,class (:foreground ,fg1 :background ,bg1))))
   `(helm-grep-file ((,class (:foreground ,fg1 :background ,bg1))))
   `(helm-grep-finish ((,class (:foreground ,fg2 :background ,bg1))))
   `(helm-grep-lineno ((,class (:foreground ,fg1 :background ,bg1))))
   `(helm-grep-match ((,class (:foreground nil :background nil :inherit helm-match))))
   `(helm-grep-running ((,class (:foreground ,func :background ,bg1))))
   `(helm-header ((,class (:foreground ,fg2 :background ,bg1 :underline nil :box nil))))
   `(helm-match ((,class (:foreground ,const :background ,bg1))))
   `(helm-match-item ((,class (:foreground ,const))))
   `(helm-moccur-buffer ((,class (:foreground ,func :background ,bg1))))
   `(helm-selection ((,class (:background ,bg2 :underline nil))))
   `(helm-selection-line ((,class (:background ,bg2))))
   `(helm-separator ((,class (:foreground ,fg2 :background ,bg1))))
   `(helm-source-go-package-godoc-description ((,class (:foreground ,str))))
   `(helm-source-header ((,class (:foreground ,keyword :background ,bg1 :underline nil :weight bold))))
   `(helm-time-zone-current ((,class (:foreground ,builtin :background ,bg1))))
   `(helm-time-zone-home ((,class (:foreground ,type :background ,bg1))))
   `(helm-visible-mark ((,class (:foreground ,bg1 :background ,bg3))))
   ;; icomplete
   `(icompletep-determined ((,class :foreground ,builtin)))
   ;; ido
   `(ido-first-match ((,class (:foreground ,keyword :bold t))))
   `(ido-only-match ((,class (:foreground ,warning))))
   `(ido-subdir ((,class (:foreground ,builtin))))
   ;; isearch
   `(isearch ((,class (:bold t :foreground ,warning :background ,bg3))))
   `(isearch-fail ((,class (:foreground ,bg1 :background ,warning))))
   ;; jde-java
   `(jde-java-font-lock-constant-face ((t (:foreground ,const))))
   `(jde-java-font-lock-modifier-face ((t (:foreground ,key3))))
   `(jde-java-font-lock-number-face ((t (:foreground ,var))))
   `(jde-java-font-lock-package-face ((t (:foreground ,var))))
   `(jde-java-font-lock-private-face ((t (:foreground ,keyword))))
   `(jde-java-font-lock-public-face ((t (:foreground ,keyword))))
   ;; js2-mode
   `(js2-external-variable ((,class (:foreground ,type  ))))
   `(js2-function-param ((,class (:foreground ,const))))
   `(js2-jsdoc-html-tag-delimiter ((,class (:foreground ,str))))
   `(js2-jsdoc-html-tag-name ((,class (:foreground ,key2))))
   `(js2-jsdoc-value ((,class (:foreground ,str))))
   `(js2-private-function-call ((,class (:foreground ,const))))
   `(js2-private-member ((,class (:foreground ,fg3))))
   ;; js3-mode
   `(js3-error-face ((,class (:underline ,warning))))
   `(js3-external-variable-face ((,class (:foreground ,var))))
   `(js3-function-param-face ((,class (:foreground ,key3))))
   `(js3-instance-member-face ((,class (:foreground ,const))))
   `(js3-jsdoc-tag-face ((,class (:foreground ,keyword))))
   `(js3-warning-face ((,class (:underline ,keyword))))
   ;; magit
   `(magit-branch ((,class (:foreground ,const :weight bold))))
   `(magit-diff-context-highlight ((,class (:background ,bg3 :foreground ,fg3))))
   `(magit-diff-file-header ((,class (:foreground ,fg2 :background ,bg3))))
   `(magit-diffstat-added   ((,class (:foreground ,type))))
   `(magit-diffstat-removed ((,class (:foreground ,var))))
   `(magit-hash ((,class (:foreground ,fg2))))
   `(magit-hunk-heading           ((,class (:background ,bg3))))
   `(magit-hunk-heading-highlight ((,class (:background ,bg3))))
   `(magit-item-highlight ((,class :background ,bg3)))
   `(magit-log-author ((,class (:foreground ,fg3))))
   `(magit-process-ng ((,class (:foreground ,warning :weight bold))))
   `(magit-process-ok ((,class (:foreground ,func :weight bold))))
   `(magit-section-heading        ((,class (:foreground ,keyword :weight bold))))
   `(magit-section-highlight      ((,class (:background ,bg2))))
   ;; mode-line
   `(mode-line ((,class (:family ,anderson-sans-font :height ,anderson-modeline-font-size :foreground nil :background ,bg3 :box (:line-width 5 :color ,bg3)))))
   `(mode-line-inactive ((,class (:inherit mode-line :foreground ,bg4 :background ,bg2 :box (:line-width 5 :color ,bg2)))))
   `(mode-line-buffer-id ((,class (:foreground ,type :background nil))))
   `(mode-line-highlight ((,class (:foreground nil :background nil :underline t))))
   `(my/modeline-evil ((,class (:foreground nil :inherit mode-line :background nil))))
   `(my/modeline-evil-normal ((,class (:foreground ,keyword :bold t))))
   `(my/modeline-evil-emacs ((,class (:foreground ,builtin :bold t))))
   `(my/modeline-evil-insert ((,class (:foreground ,const :bold t))))
   `(my/modeline-evil-replace ((,class (:foreground ,key2 :bold t))))
   `(my/modeline-evil-visual ((,class (:foreground ,type :bold t))))
   `(my/modeline-evil-motion ((,class (:foreground ,var :bold t))))
   `(my/modeline-evil-operator ((,class (:foreground ,func :bold t))))
   ;; mu4e
   `(mu4e-cited-1-face ((,class (:foreground ,fg2))))
   `(mu4e-cited-7-face ((,class (:foreground ,fg3))))
   `(mu4e-header-marks-face ((,class (:foreground ,type))))
   `(mu4e-view-url-number-face ((,class (:foreground ,type))))
   ;; org
   `(org-agenda-date ((,class (:foreground ,rainbow-2 :underline nil))))
   `(org-agenda-dimmed-todo-face ((,class (:foreground ,comment))))
   `(org-agenda-done ((,class (:foreground ,keyword))))
   `(org-agenda-structure ((,class (:foreground ,rainbow-3))))
   `(org-meta-line ((,class (:foreground ,comment :background ,bg2 :italic t))))
   `(org-block ((,class (:foreground ,rainbow-5))))
   `(org-block-begin-line ((,class (:foreground ,comment :background ,bg2 :italic t))))
   `(org-block-end-line ((,class (:foreground ,comment :background ,bg2 :italic t))))
   `(org-block-background ((,class (:background ,fg4))))
   `(org-code ((,class (:inherit org-block-background))))
   `(org-column ((,class (:background ,bg4))))
   `(org-column-title ((,class (:inherit org-column :weight bold :underline t))))
   `(org-date ((,class (:foreground ,builtin :underline t))))
   `(org-document-info ((,class (:foreground ,rainbow-8))))
   `(org-document-info-keyword ((,class (:foreground ,comment))))
   `(org-document-title ((,class (:weight bold :foreground ,const :height 1.44))))
   `(org-done ((,class (:foreground ,keyword :bold t))))
   `(org-ellipsis ((,class (:foreground ,comment))))
   `(org-footnote ((,class (:foreground ,rainbow-8))))
   `(org-formula ((,class (:foreground ,rainbow-4))))
   `(org-headline-done ((,class (:foreground ,comment :bold nil :strike-through t))))
   `(org-hide ((,class (:foreground ,bg1 :background ,bg1))))
   `(org-level-1 ((,class (:family ,(if anderson-use-org-serif anderson-serif-font) :bold ,(if anderson-use-org-serif nil t) :foreground ,fg1 :height ,(if anderson-use-org-serif 1.8 1.2)))))
   `(org-level-2 ((,class (:family ,(if anderson-use-org-serif anderson-serif-font) :bold ,(if anderson-use-org-serif nil t) :foreground ,fg1 :height ,(if anderson-use-org-serif 1.4 1.0)))))
   `(org-level-3 ((,class (:family ,(if anderson-use-org-serif anderson-serif-font) :bold ,(if anderson-use-org-serif nil nil) :foreground ,fg1 :height ,(if anderson-use-org-serif 1.0 1.0)))))
   `(org-level-4 ((,class (:family ,(if anderson-use-org-serif anderson-serif-font) :bold ,(if anderson-use-org-serif nil nil) :foreground ,fg1 :height ,(if anderson-use-org-serif 1.0 1.0)))))
   `(org-level-5 ((,class (:family ,(if anderson-use-org-serif anderson-serif-font) :bold ,(if anderson-use-org-serif nil nil) :foreground ,fg1 :height ,(if anderson-use-org-serif 1.0 1.0)))))
   `(org-level-6 ((,class (:family ,(if anderson-use-org-serif anderson-serif-font) :bold ,(if anderson-use-org-serif nil nil) :foreground ,fg1 :height ,(if anderson-use-org-serif 1.0 1.0)))))
   `(org-level-7 ((,class (:family ,(if anderson-use-org-serif anderson-serif-font) :bold ,(if anderson-use-org-serif nil nil) :foreground ,fg1 :height ,(if anderson-use-org-serif 1.0 1.0)))))
   `(org-level-8 ((,class (:family ,(if anderson-use-org-serif anderson-serif-font) :bold ,(if anderson-use-org-serif nil nil) :foreground ,fg1 :height ,(if anderson-use-org-serif 1.0 1.0)))))
   `(org-link ((,class (:foreground ,rainbow-2 :underline t))))
   `(org-priority ((,class (:foreground ,rainbow-2))))
   `(org-scheduled ((,class (:foreground ,rainbow-6))))
   `(org-scheduled-previously ((,class (:foreground ,rainbow-7))))
   `(org-scheduled-today ((,class (:foreground ,rainbow-6))))
   `(org-sexp-date ((,class (:foreground ,fg4))))
   `(org-special-keyword ((,class (:foreground ,type :bold t))))
   `(org-table ((,class (:foreground ,rainbow-3))))
   `(org-tag ((,class (:foreground ,rainbow-4 :bold t :background ,bg2))))
   `(org-todo ((,class (:foreground ,const :bold t))))
   `(org-upcoming-deadline ((,class (:foreground ,rainbow-7))))
   `(org-warning ((,class (:weight bold :foreground ,rainbow-4))))
   ;; outline
   `(outline-1 ((,class (:foreground ,rainbow-6))))
   `(outline-2 ((,class (:foreground ,rainbow-3))))
   `(outline-3 ((,class (:foreground ,rainbow-2))))
   `(outline-4 ((,class (:foreground ,rainbow-5))))
   `(outline-5 ((,class (:foreground ,rainbow-5))))
   `(outline-6 ((,class (:foreground ,rainbow-8))))
   ;; Volatile
   `(vhl/default-face ((,class (:foreground nil :background ,keyword))))
   ;; powerline
   `(powerline-evil-base-face ((t (:foreground ,bg2))))
   `(powerline-evil-emacs-face ((,class (:inherit powerline-evil-base-face :background ,rainbow-7))))
   `(powerline-evil-insert-face ((,class (:inherit powerline-evil-base-face :background ,rainbow-2))))
   `(powerline-evil-motion-face ((,class (:inherit powerline-evil-base-face :background ,rainbow-3))))
   `(powerline-evil-normal-face ((,class (:inherit powerline-evil-base-face :background ,keyword))))
   `(powerline-evil-operator-face ((,class (:inherit powerline-evil-base-face :background ,rainbow-4))))
   `(powerline-evil-replace-face ((,class (:inherit powerline-evil-base-face :background ,rainbow-8))))
   `(powerline-evil-visual-face ((,class (:inherit powerline-evil-base-face :background ,rainbow-5))))
   ;; rainbow-delimiters
   `(rainbow-delimiters-depth-1-face ((,class :foreground ,rainbow-1)))
   `(rainbow-delimiters-depth-2-face ((,class :foreground ,rainbow-2)))
   `(rainbow-delimiters-depth-3-face ((,class :foreground ,rainbow-3)))
   `(rainbow-delimiters-depth-4-face ((,class :foreground ,rainbow-4)))
   `(rainbow-delimiters-depth-5-face ((,class :foreground ,rainbow-5)))
   `(rainbow-delimiters-depth-6-face ((,class :foreground ,rainbow-6)))
   `(rainbow-delimiters-depth-7-face ((,class :foreground ,rainbow-7)))
   `(rainbow-delimiters-depth-8-face ((,class :foreground ,rainbow-8)))
   `(rainbow-delimiters-unmatched-face ((,class :foreground ,warning)))
   ;; rpm-spec
   `(rpm-spec-dir-face ((,class (:foreground ,rainbow-6))))
   `(rpm-spec-doc-face ((,class (:foreground ,rainbow-4))))
   `(rpm-spec-ghost-face ((,class (:foreground ,rainbow-3))))
   `(rpm-spec-macro-face ((,class (:foreground ,rainbow-7))))
   `(rpm-spec-obsolete-tag-face ((,class (:inherit font-lock-warning-face))))
   `(rpm-spec-package-face ((,class (:foreground ,rainbow-3))))
   `(rpm-spec-section-face ((,class (:foreground ,rainbow-7))))
   `(rpm-spec-tag-face ((,class (:foreground ,rainbow-2))))
   `(rpm-spec-var-face ((,class (:foreground "#a0522d"))))
   ;; slime
   `(slime-repl-inputed-output-face ((,class (:foreground ,type))))
   ;; spam
   `(spam ((,class (:inherit gnus-summary-normal-read :foreground ,warning :strike-through t :slant oblique))))
   ;; term
   `(term ((,class (:foreground ,fg1 :background ,bg1))))
   `(term-color-black ((,class (:foreground ,bg3 :background ,bg3))))
   `(term-color-blue ((,class (:foreground ,func :background ,func))))
   `(term-color-cyan ((,class (:foreground ,str :background ,str))))
   `(term-color-green ((,class (:foreground ,type :background ,bg3))))
   `(term-color-magenta ((,class (:foreground ,builtin :background ,builtin))))
   `(term-color-red ((,class (:foreground ,keyword :background ,bg3))))
   `(term-color-white ((,class (:foreground ,fg2 :background ,fg2))))
   `(term-color-yellow ((,class (:foreground ,var :background ,var))))
   ;; undo-tree
   `(undo-tree-visualizer-current-face ((,class :foreground ,builtin)))
   `(undo-tree-visualizer-default-face ((,class :foreground ,fg2)))
   `(undo-tree-visualizer-register-face ((,class :foreground ,type)))
   `(undo-tree-visualizer-unmodified-face ((,class :foreground ,var)))
   ;; web-mode
   `(web-mode-builtin-face ((,class (:inherit ,font-lock-builtin-face))))
   `(web-mode-comment-face ((,class (:inherit ,font-lock-comment-face))))
   `(web-mode-constant-face ((,class (:inherit ,font-lock-constant-face))))
   `(web-mode-doctype-face ((,class (:inherit ,font-lock-comment-face))))
   `(web-mode-function-name-face ((,class (:inherit ,font-lock-function-name-face))))
   `(web-mode-html-attr-name-face ((,class (:foreground ,type))))
   `(web-mode-html-attr-value-face ((,class (:foreground ,func))))
   `(web-mode-html-tag-face ((,class (:foreground ,keyword :bold t))))
   `(web-mode-keyword-face ((,class (:foreground ,keyword))))
   `(web-mode-string-face ((,class (:foreground ,str))))
   `(web-mode-type-face ((,class (:inherit ,font-lock-type-face))))
   `(web-mode-warning-face ((,class (:inherit ,font-lock-warning-face))))
   ;; which-func
   `(which-func ((,class (:inherit ,font-lock-function-name-face))))
   `(dired-directory ((,class (:foreground ,func :weight normal))))
   `(dired-flagged ((,class (:foreground ,keyword))))
   `(dired-header ((,class (:foreground ,keyword :background ,bg1))))
   `(dired-ignored ((,class (:inherit shadow))))
   `(dired-mark ((,class (:foreground ,var :weight bold))))
   `(dired-marked ((,class (:foreground ,builtin :weight bold))))
   `(dired-perm-write ((,class (:foreground ,fg3 :underline t))))
   `(dired-symlink ((,class (:foreground ,str :weight normal :slant italic))))
   `(dired-warning ((,class (:foreground ,warning :underline t))))
   `(diredp-compressed-file-name ((,class (:foreground ,fg3))))
   `(diredp-compressed-file-suffix ((,class (:foreground ,fg4))))
   `(diredp-date-time ((,class (:foreground ,var))))
   `(diredp-deletion-file-name ((,class (:foreground ,keyword :background ,bg4))))
   `(diredp-deletion ((,class (:foreground ,keyword :weight bold))))
   `(diredp-dir-heading ((,class (:foreground ,fg2 :background ,bg4))))
   `(diredp-dir-name ((,class (:inherit dired-directory))))
   `(diredp-dir-priv ((,class (:inherit dired-directory))))
   `(diredp-executable-tag ((,class (:foreground ,builtin))))
   `(diredp-file-name ((,class (:foreground ,fg1))))
   `(diredp-file-suffix ((,class (:foreground ,fg4))))
   `(diredp-flag-mark-line ((,class (:foreground ,fg2 :slant italic :background ,bg4))))
   `(diredp-flag-mark ((,class (:foreground ,fg2 :weight bold :background ,bg4))))
   `(diredp-ignored-file-name ((,class (:foreground ,fg1))))
   `(diredp-mode-line-flagged ((,class (:foreground ,warning))))
   `(diredp-mode-line-marked ((,class (:foreground ,warning))))
   `(diredp-no-priv ((,class (:foreground ,fg1))))
   `(diredp-number ((,class (:foreground ,const))))
   `(diredp-other-priv ((,class (:foreground ,builtin))))
   `(diredp-rare-priv ((,class (:foreground ,builtin))))
   `(diredp-read-priv ((,class (:foreground ,type))))
   `(diredp-write-priv ((,class (:foreground ,keyword))))
   `(diredp-exec-priv ((,class (:foreground ,str))))
   `(diredp-symlink ((,class (:foreground ,warning))))
   `(diredp-link-priv ((,class (:foreground ,warning))))
   `(diredp-autofile-name ((,class (:foreground ,str))))
   `(diredp-tagged-autofile-name ((,class (:foreground ,str))))
   `(icicle-whitespace-highlight               ((,class (:background ,var))))
   `(icicle-special-candidate                  ((,class (:foreground ,fg2))))
   `(icicle-extra-candidate                    ((,class (:foreground ,fg2))))
   `(icicle-search-main-regexp-others          ((,class (:foreground ,var))))
   `(icicle-search-current-input               ((,class (:foreground ,keyword))))
   `(icicle-search-context-level-8             ((,class (:foreground ,warning))))
   `(icicle-search-context-level-7             ((,class (:foreground ,warning))))
   `(icicle-search-context-level-6             ((,class (:foreground ,warning))))
   `(icicle-search-context-level-5             ((,class (:foreground ,warning))))
   `(icicle-search-context-level-4             ((,class (:foreground ,warning))))
   `(icicle-search-context-level-3             ((,class (:foreground ,warning))))
   `(icicle-search-context-level-2             ((,class (:foreground ,warning))))
   `(icicle-search-context-level-1             ((,class (:foreground ,warning))))
   `(icicle-search-main-regexp-current         ((,class (:foreground ,fg1))))
   `(icicle-saved-candidate                    ((,class (:foreground ,fg1))))
   `(icicle-proxy-candidate                    ((,class (:foreground ,fg1))))
   `(icicle-mustmatch-completion               ((,class (:foreground ,type))))
   `(icicle-multi-command-completion           ((,class (:foreground ,fg2 :background ,bg2))))
   `(icicle-msg-emphasis                       ((,class (:foreground ,func))))
   `(icicle-mode-line-help                     ((,class (:foreground ,fg4))))
   `(icicle-match-highlight-minibuffer         ((,class (:foreground ,builtin))))
   `(icicle-match-highlight-Completions        ((,class (:foreground ,func))))
   `(icicle-key-complete-menu-local            ((,class (:foreground ,fg1))))
   `(icicle-key-complete-menu                  ((,class (:foreground ,fg1))))
   `(icicle-input-completion-fail-lax          ((,class (:foreground ,keyword))))
   `(icicle-input-completion-fail              ((,class (:foreground ,keyword))))
   `(icicle-historical-candidate-other         ((,class (:foreground ,fg1))))
   `(icicle-historical-candidate               ((,class (:foreground ,fg1))))
   `(icicle-current-candidate-highlight        ((,class (:foreground ,warning :background ,bg3))))
   `(icicle-Completions-instruction-2          ((,class (:foreground ,fg4))))
   `(icicle-Completions-instruction-1          ((,class (:foreground ,fg4))))
   `(icicle-completion                         ((,class (:foreground ,var))))
   `(icicle-complete-input                     ((,class (:foreground ,builtin))))
   `(icicle-common-match-highlight-Completions ((,class (:foreground ,type))))
   `(icicle-candidate-part                     ((,class (:foreground ,var))))
   `(icicle-annotation                         ((,class (:foreground ,fg4))))
  ))


;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'anderson)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; anderson-theme.el ends here
