;;; -*- lexical-binding: t -*-
;; Remember to set the Hasklig font via font menu: super-t 

(setq custom-file "~/.emacs.custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

;; Theme and font
(load-theme 'modus-vivendi)

;; Disable bell sound
(setq ring-bell-function 'ignore)

;; Disable toolbar
(tool-bar-mode 0)

;; Enable relative line numbers globally
(setq display-line-numbers-type 'relative)

;; Display line numbers globally
;; (global-display-line-numbers-mode t)

;; Optional: enable only in programming/text modes
;; (add-hook 'prog-mode-hook #'display-line-numbers-mode)
;; (add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook (lambda() (display-line-numbers-mode 1)))
(add-hook 'text-mode-hook (lambda() (display-line-numbers-mode 1)))

;; Enable automatic session saving and restoring
(desktop-save-mode 1)

;; Save session when quitting
(setq desktop-save t)

;; Save every 5 minutes if there are changes
(setq desktop-auto-save-timeout 300)

;; Automatically restore without asking
(setq desktop-restore-frames t
      desktop-load-locked-desktop t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(setq package-archive-priorities
      '(("melpa-stable" . 30)
        ("gnu" . 20)
        ("melpa" . 10)))

;; Upgrade built-in packages from external package archives
;; (setq package-install-upgrade-built-in t)

(require 'use-package)
(setq use-package-always-ensure t
      use-package-expand-minimally t)

(when (getenv "WRITES_TEXT")
  (use-package auctex
    :config
    (setq TeX-auto-save t)
    (setq TeX-parse-self t)
    (setq TeX-source-correlate-mode t)
    (setq-default TeX-master nil)
    (add-hook 'LaTeX-mode-hook 'visual-line-mode)
    (add-hook 'LaTeX-mode-hook 'flyspell-mode)
    (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
    (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
    ;; (add-hook 'LaTeX-mode-hook 'turn-on-auto-fill) ; Disabled to avoid hard newline chars, use visual-line-mode

    (setq reftex-plug-into-AUCTeX t)

    ;; Ensure RefTeX looks for bib files in the current directory
    (setq reftex-use-fonts t))

  (use-package pdf-tools
    :init
    (pdf-tools-install)
    :config
    (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
          TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
          TeX-source-correlate-start-server t)
    (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
    (setq pdf-view-use-scaling t)
    (setq pdf-view-resize-factor 1.05)
    :bind (:map pdf-view-mode-map
                ("<left>" . pdf-view-previous-page-command)
                ("<right>" . pdf-view-next-page-command)))

  ;; Spellcheck setup on Windows
  ;; Install aspell/hunspell in MINGW64 Shell
  ;; pacman -S mingw-w64-x86_64-aspell mingw-w64-x86_64-aspell-en mingw-w64-x86_64-hunspell mingw-w64-x86_64-hunspell-en
  ;; list location for language dictionaries: hunspell -D
  (use-package ispell
    :init
    (setenv "LANG" "en_GB.UTF-8")
    :config
    (setq ispell-program-name "C:\\msys64\\mingw64\\bin\\hunspell.exe"
          ispell-dictionary "en_GB")))

(use-package magit)

(use-package diff-hl
  :hook (dired-mode . diff-hl-dired-mode)
  :config
  (global-diff-hl-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (unless (display-graphic-p)
    (diff-hl-margin-mode 1)))

(use-package expand-region
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package ligature
  :config
  ;; Enable all Hasklig ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("<*" "<*>" "<+>" "<$>" "***" "<|" "|>"  "<|>" "!!" "||" "==="
                                       "==>" "<<<" ">>>" "<>" "+++" "<-" "->" "=>" ">>" "<<" ">>="
                                       "=<<" ".." "..." "::" "-<" ">-" "-<<" ">>-" "++" "/=" "=="))
  (global-ligature-mode t))

(use-package epresent)

;; Fuzzy finding
;; Not compatible with Windows: https://github.com/bling/fzf.el/issues/110
(unless
    (eq system-type 'windows-nt)
  (use-package fzf
    :bind
    ;; Don't forget to set keybinds!
    :config
    (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
	  fzf/executable "fzf"
	  fzf/git-grep-args "-i --line-number %s"
	  ;; command used for `fzf-grep-*` functions
	  ;; example usage for ripgrep:
	  fzf/grep-command "rg --no-heading -nH"
	  ;; fzf/grep-command "grep -nrH"
	  ;; If nil, the fzf buffer will appear at the top of the window
	  fzf/position-bottom t
	  fzf/window-height 15))
  )

;; Programming setups on Linux/Mac
(unless (eq system-type 'windows-nt)
  ;; Global performance optimizations for LSP
  (setq gc-cons-threshold (* 100 1024 1024)
        read-process-output-max (* 1024 1024))

  ;; Company Mode (autocompletion)
  (use-package company
    :hook (clojure-mode . company-mode)
    :config
    (setq company-minimum-prefix-length 1
          company-idle-delay 0.0          ; Instant completion popup
          company-tooltip-align-annotations t))

  ;; Flycheck (syntax and error checking)
  (use-package flycheck
    :hook ((clojure-mode        . flycheck-mode)
           (clojurescript-mode  . flycheck-mode)
           (clojurec-mode       . flycheck-mode))
    :config
    (setq flycheck-check-syntax-automatically '(save mode-enabled))) ; Checks errors on save/open to save CPU

  ;; LSP Mode (navigation, diagnostics, refactoring)
  (use-package lsp-mode
    :hook ((clojure-mode . lsp)
           (clojurescript-mode . lsp)
           (clojurec-mode . lsp))
    :config
    (setq lsp-enable-indentation nil         ; Let CIDER handle code indentation
          lsp-enable-completion-at-point nil ; Let CIDER handle auto-completion data
          lsp-lens-enable nil                ; Hides distracting reference counts
          lsp-diagnostics-provider :flycheck ; Explicitly pipe LSP diagnostics into Flycheck
          ))

  ;; LSP Treemacs Integration
  (use-package lsp-treemacs
    :config
    (setq treemacs-space-between-root-nodes nil))
  
  ;; Add language-specific packages here

  ;; (use-package slime
  ;;   :config
  ;;   (setq inferior-lisp-program "sbcl"))
  
  (use-package clojure-mode)
  
  ;; CIDER (Clojure IDE)
  (use-package cider
    :defer t
    :config
    (setq cider-preferred-build-tool "lein" ; Configured for Leiningen
          cider-repl-display-help nil
          cider-font-lock-dynamically '(macro core function var)
          cider-eldoc-display-for-symbol-at-point nil))
  )

;; Programming setups on Linux/Mac
(unless (eq system-type 'windows-nt)
  ;; Global performance optimizations for LSP
  (setq gc-cons-threshold (* 100 1024 1024)
        read-process-output-max (* 1024 1024))

  ;; 1. Company Mode (enable globally for code buffers)
  (use-package company
    :hook (prog-mode . company-mode) ; works for all future programming languages
    :config
    (setq company-minimum-prefix-length 1
          company-idle-delay 0.0
          company-tooltip-align-annotations t))

  ;; 2. Flycheck (base framework)
  (use-package flycheck
    :config
    (setq flycheck-check-syntax-automatically '(save mode-enabled)))

  ;; 3. LSP Mode (base framework)
  (use-package lsp-mode
    :commands lsp
    :config
    (setq lsp-lens-enable nil
          lsp-diagnostics-provider :flycheck))

  ;; 4. LSP Treemacs integration
  (use-package lsp-treemacs
    :config
    (setq treemacs-space-between-root-nodes nil))

  ;; Language configurations
  
  ;; Clojure
  (use-package clojure-mode
    :hook ((clojure-mode        . lsp)
           (clojure-mode        . flycheck-mode)
           (clojurescript-mode  . lsp)
           (clojurescript-mode  . flycheck-mode)
           (clojurec-mode       . lsp)
           (clojurec-mode       . flycheck-mode))
    :config
    ;; Disable LSP completion/indentation only for Clojure so CIDER handles them
    (add-hook 'clojure-mode-hook
              (lambda ()
                (setq-local lsp-enable-indentation nil)
                (setq-local lsp-enable-completion-at-point nil))))

  ;; CIDER (Clojure IDE)
  (use-package cider
    :defer t
    :config
    (setq cider-preferred-build-tool "lein"
          cider-repl-display-help nil
          cider-font-lock-dynamically '(macro core function var)
          cider-eldoc-display-for-symbol-at-point nil))

  ;; Example: How to add Python in the future
  ;; (use-package python-mode
  ;;   :hook ((python-mode . lsp)
  ;;          (python-mode . flycheck-mode)))
)
