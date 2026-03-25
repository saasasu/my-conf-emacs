;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(modus-vivendi)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Hasklug Nerd Font" :foundry "outline" :slant normal :weight regular :height 120 :width normal)))))

(setq ring-bell-function 'ignore)

;; Enable relative line numbers globally
(setq display-line-numbers-type 'relative)

;; Display line numbers globally
;; (global-display-line-numbers-mode t)

;; Optional: enable only in programming/text modes
;; (add-hook 'prog-mode-hook #'display-line-numbers-mode)
;; (add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'prog-mode-hook (lambda() (display-line-numbers-mode 1)))
(add-hook 'text-mode-hook (lambda() (display-line-numbers-mode 1)))

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

(require 'use-package)
(setq use-package-always-ensure t
      use-package-expand-minimally t)

;; SLIME
(use-package slime
  :config
  (setq inferior-lisp-program "sbcl"))

;; (use-package vterm)

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
  (setq reftex-plug-into-AUCTeX t))

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

(use-package magit)

(use-package expand-region
  :config
  (global-set-key (kbd "C-=") 'er/expand-region)
  )

(use-package ligature
  :config
  ;; Enable all Hasklig ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("<*" "<*>" "<+>" "<$>" "***" "<|" "|>"  "<|>" "!!" "||" "==="
                                       "==>" "<<<" ">>>" "<>" "+++" "<-" "->" "=>" ">>" "<<" ">>="
                                       "=<<" ".." "..." "::" "-<" ">-" "-<<" ">>-" "++" "/=" "=="))
  (global-ligature-mode t))
