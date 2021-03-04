;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-zenburn)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.




;; My stuff begins here!

(require 'server)
(when (not (eq (server-running-p) t))
  (server-start))

;;(global-visual-line-mode t)
(delete-selection-mode t)
;;(dired-listing-switches "-al")

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(global-set-key (kbd "M-/") 'undo-fu-only-redo)

(setq evil-default-state 'emacs
      evil-emacs-state-modes nil
      evil-insert-state-modes nil
      evil-motion-state-modes nil
      evil-normal-state-modes nil)
(add-hook! 'evil-local-mode-hook #'evil-emacs-state)

(menu-bar-mode t)


(setq doom-font (font-spec :family "Consolas" :size 17))
(add-hook! 'doom-load-theme-hook :append
  (set-fontset-font "fontset-default" 'cyrillic "Consolas"))


;(add-hook 'dired-mode-hook 'dired-hide-details-mode)
(setq dired-listing-switches "-ahloG -v --group-directories-first")



(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)

(global-set-key (kbd "C-c r") 'replace-regexp)



;; use variable-pitch fonts for some headings and titles
(setq zenburn-use-variable-pitch t)
;; scale headings in org-mode
(setq zenburn-scale-org-headlines t)
;; scale headings in outline-mode
(setq zenburn-scale-outline-headlines t)





(global-set-key (kbd "C-M-y") '(lambda () (interactive)
                                 (insert "λ")))


;;;; Main packages ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(use-package reverse-im
  :ensure reverse-im
  :custom
  (reverse-im-input-methods '("russian-computer"))
  :config
  (reverse-im-mode t))

(add-hook! 'racket-mode-hook
           'racket-xp-mode
           #'(lambda () (interactive)
               (flycheck-mode -1)
               (racket-smart-open-bracket-mode -1)
               ;;(flyspell-mode nil)
               ))


(use-package! swiper
  :config
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  :bind
  ("C-s" . swiper))



(map!
 "C-\"" (lambda! (execute-kbd-macro (kbd "C-q \""))))

(+global-word-wrap-mode t)

;;;; Visual regexp

(use-package! visual-regexp-steroids)

(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)



;;;; Indentation

(setq highlight-indent-guides-method 'bitmap)
(setq highlight-indent-guides-auto-character-face-perc 30)
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)


;;;; Sunrise

(require 'sunrise-buttons)
(require 'sunrise-modeline)
(require 'sunrise-mirror)
(require 'sunrise-tree)


(setq sunrise-attributes-display-mask '(t t nil nil nil nil))
(setq sunrise-listing-switches "-ahloG -v --group-directories-first")


;;;; My additions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.doom.d/local/my/")
(require 'dired-show-less)
(add-hook! 'dired-mode-hook #'diredTZA-hide-fields-add-menu)




(require 'my-main)
(require 'my-scrtex)
