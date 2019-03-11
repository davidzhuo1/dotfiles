;;; init.el --- customizations     -*- lexical-binding: t; -*-
(defconst emacs-start-time (current-time))

;; Speed up startup by running gc later and not running regex on plugins
(defvar file-name-handler-alist-old file-name-handler-alist)
(setq file-name-handler-alist nil
      gc-cons-threshold (eval-when-compile (* 384 1024 1024))
      gc-cons-percentage 0.6
      debug-on-error t
      debug-on-quit t)
(message "--> Loading user init file: %s" user-init-file)

;; Back to default after init
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist file-name-handler-alist-old
                  gc-cons-threshold (eval-when-compile (* 64 1024 1024))
                  gc-cons-percentage 0.1
                  debug-on-error nil
                  debug-on-quit nil)
            (if (get-buffer "*scratch*")
                (kill-buffer "*scratch*"))
            (delete-other-windows)
            (garbage-collect)
            (let ((elapsed (float-time (time-subtract (current-time)
                                                      emacs-start-time))))
              (message "--> Done with init! (%.3fs)" elapsed))
            )
          )

;; Auto-recompile emacs settings on save
(defun byte-recompile-all-init-files ()
  "Recompile all of the startup files"
  (interactive)
  (byte-recompile-directory (concat user-emacs-directory "elpa") 0))
(defun byte-compile-user-init-file ()
  (let ((byte-compile-warnings '(unresolved)))
    ;; In case compilation fails, don't leave the old .elc around:
    (when (file-exists-p (concat user-init-file "c"))
      (delete-file (concat user-init-file "c")))
    (byte-compile-file user-init-file)
    (when (file-exists-p custom-file)
      (byte-compile-file custom-file))
    (byte-recompile-all-init-files)
    ))
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (when (equal buffer-file-name user-init-file)
              (add-hook 'after-save-hook 'byte-compile-user-init-file t t)
              (add-hook 'before-save-hook 'delete-trailing-whitespace nil 'local)
              )))

;; Initialize packages
(setq package-enable-at-startup nil
      package-archives '(("melpa-stable" . "https://stable.melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ;; ("marmalade" . "https://marmalade-repo.org/packages/")
                         )
      use-package-verbose t
      package-menu-async t)
(package-initialize)
(eval-when-compile
  (progn
    (add-to-list 'load-path (concat user-emacs-directory "elpa/use-package-2.4"))
    (require 'use-package)
    (setq use-package-minimum-reported-time 0.001)
    ))
(require 'bind-key)

;; elisp library
(use-package dash :ensure t )

;; Shrink minor modes in mode-line
(use-package delight :ensure t )

;; Basic GUI stuff, remove line-break character and auto-wrap, highlight parens
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode) (horizontal-scroll-bar-mode -1))
(when (fboundp 'tooltip-mode) (tooltip-mode -1))
(when (fboundp 'blink-cursor-mode) (blink-cursor-mode 1))
(fset 'yes-or-no-p 'y-or-n-p)
(setq-default inhibit-startup-message t
              inhibit-startup-echo-area-message t
              initial-scratch-message nil
              visible-bell nil
              auto-window-vscroll nil
              column-number-mode t
              size-indication-mode t
              indicate-empty-lines t
              nobreak-char-display t
              jit-lock-defer-time 0.005
              bidi-display-reordering nil
              )

;; Mini-buffer stuff
(setq history-delete-duplicates t)

;; Actual GUI stuff
(setq ns-antialias-text t
      frame-resize-pixelwise t)

(defun after-make-frame-hook (&optional frame)
  (progn
    (menu-bar-mode -1) ;; Need this for going back to tty emacs
    (select-frame frame)
    (when (window-system frame)
      ;; (color-theme-sanityinc-tomorrow--define-theme bright)
      (set-face-attribute 'default frame :height 126)
      (set-frame-size frame 100 72)
      (set-frame-position frame 0 0)
      )
    )
  )
(add-hook 'after-make-frame-functions 'after-make-frame-hook)

;; (use-package color-theme-sanityinc-tomorrow)
(use-package material-theme
  :ensure t
  :init (load-theme 'material t)
  )

(setq mode-line-percent-position nil
      display-time-mode nil
      size-indication-mode t
      display-battery-mode nil)
(use-package smart-mode-line
  :ensure t
  :after delight
  :init
  (setq sml/no-confirm-load-theme t)
  :config
  (setq sml/theme 'respectful)
  (setq mode-line-format (delq 'mode-line-position mode-line-format)) ;; No big gap
  (setq sml/col-number-format "%2c"
        sml/line-number-format "%4l"
        sml/mule-info nil
        sml/name-width 64
        sml/position-percentage-format nil
        sml/replacer-regexp-list nil
        sml/show-trailing-N nil)
  ;; (set-face-attribute 'sml/line-number nil :foreground "orange" :weight 'bold)
  ;; (set-face-attribute 'sml/col-number nil :foreground "orange")
  ;; (set-face-attribute 'sml/folder nil :foreground "yellow")
  ;; (set-face-attribute 'sml/filename nil :foreground "green" :weight 'bold)
  ;; (set-face-attribute 'sml/git nil :foreground "blue")
  ;; (set-face-attribute 'sml/vc nil :foreground "blue")
  ;; (set-face-attribute 'sml/vc-edited nil :foreground "blue")
  ;; (set-face-attribute 'sml/modes nil :foreground "cyan")
  ;; (set-face-attribute 'sml/minor-modes nil :foreground "cyan")
  ;; (set-face-attribute 'sml/mule-info nil)
  (sml/setup)
  )

(use-package linum
  :after whitespace
  :init (setq-default linum-format " ")
        (setq linum-format " ")
  )
(defun goto-line-with-feedback() (interactive)
       "Print line numbers when jumping to line"
       (unwind-protect
           (progn
             (setq linum-format "%d ")
             (linum-mode 1)
             (goto-line (read-number "Go to line: "))
             )
         (progn
           (setq linum-format " ")
           (linum-mode 0)
           (when (fboundp 'git-gutter:update-all-windows) (git-gutter:update-all-windows))
           )
         ))
(global-set-key [remap goto-line] 'goto-line-with-feedback)
(define-key global-map (kbd "C-l") 'goto-line)

;; Prevent temp files from emacs in directory
(setq auto-save-default nil
      make-backup-files nil
      create-lockfiles nil)

;; Save cursor location in standard emacs dir
(use-package saveplace
  :unless noninteractive
  :init (setq save-place-file (concat user-emacs-directory (system-name) ".saveplace")
              save-place-forget-unreadable-files nil)
  (if (<= emacs-major-version 24)
      (setq-default save-place t)
    (save-place-mode 1))
  )

;; Whitespace Manipulation
(use-package whitespace
  :delight WS
  :init (setq whitespace-style '(tab-mark)
              show-trailing-whitespace t
              tab-width 4
              default-tab-width 4
              require-final-newline t)
  (setq-default indent-tabs-mode nil)
  (setq ws-major-mode-exceptions '())
  (add-hook 'before-save-hook
            (lambda ()
              (unless (apply 'derived-mode-p ws-major-mode-exceptions)
                (delete-trailing-whitespace))))
  :config (global-whitespace-mode 1)
  )

;; Remote file access
(use-package tramp
  :defer t
  :init
  (setq tramp-default-method "rsync"
        tramp-use-ssh-controlmaster-options nil
        tramp-auto-save-directory "~/.emacs.d/tramp-autosave-dir")
  )

;; Window management
(defun kill-completions-window ()
  "Removes *Completions* from buffer after you've opened a file"
  (if (get-buffer "*Completions*")
      (kill-buffer "*Completions*")))
(add-hook 'minibuffer-exit-hook 'kill-completions-window)

;; Kill both buffer and window when doing C-x k
(global-set-key (kbd "C-x k") 'kill-buffer-and-window)

;; Get list of visible buffers
(defun visible-frames-list ()
  (-filter
   (lambda (fobj) (string= (framep fobj) "ns"))
   (visible-frame-list))
  )

(defun get-filenames-for-buffers (buffer-list)
  (-map
   (lambda (buffer-name) (buffer-file-name (get-buffer buffer-name)))
   buffer-list)
  )

(use-package ibuffer
  :bind (("C-x C-b" . ibuffer-other-window))
  :init (defalias 'list-buffers 'ibuffer)
  (setq ibuffer-show-empty-filter-groups nil
        frame-auto-hide-function 'delete-frame
        ibuffer-use-other-window nil
        ibuffer-expert t)
  (setq ibuffer-saved-filter-groups
        '(("ibuffer-groups"
           ("Config" (or (filename . ".emacs.d")
                         (filename . "init.*el")))
           ("Internal" (or (name . "^\\*")))
           ("Tags" (or (name . "tags$")))
          ))
        )

  :config (add-hook 'ibuffer-mode-hook
                    (lambda ()
                      (ibuffer-auto-mode 1)
                      (ibuffer-switch-to-saved-filter-groups "ibuffer-groups")
                      ))

  (defun ibuffer-previous-line ()
    "Wraparound ibuffer navigation"
    (interactive) (previous-line)
    (if (<= (line-number-at-pos) 2)
        (goto-line (- (count-lines (point-min) (point-max)) 2))))
  (defun ibuffer-next-line ()
    "Wraparound ibuffer navigation"
    (interactive) (next-line)
    (if (>= (line-number-at-pos) (- (count-lines (point-min) (point-max)) 1))
        (goto-line 3)))
  (define-key ibuffer-mode-map (kbd "<up>") 'ibuffer-previous-line)
  (define-key ibuffer-mode-map (kbd "<down>") 'ibuffer-next-line)
  (define-key ibuffer-mode-map (kbd "<return>") 'ibuffer-do-view-other-frame)

  ;; Use human readable Size column instead of original one
  (define-ibuffer-column size-h
    (:name "Size" :inline t)
    (cond
     ((> (buffer-size) 1000000) (format "%7.1f M" (/ (buffer-size) 1000000.0)))
     ((> (buffer-size) 1000)    (format "%7.1f K" (/ (buffer-size) 1000.0)))
     (t                         (format "%7d B" (buffer-size))))
    )

  ;; Modify the default ibuffer-formats
  (setq ibuffer-formats
        '((mark modified read-only " "
                (name 18 18 :left :elide) " "
                (size-h 9 -1 :right) " "
                (mode 16 16 :left :elide) " "
                filename-and-process)))

  (setq-default ibuffer-collapsed-groups (list "Internal" "Tags" "Config"))
  (defun ibuffer-collapse-groups ()
    "Collapse groups in ibuffer"
    (dolist (group ibuffer-collapsed-groups)
      (progn
        (goto-char 1)
        (when (search-forward (concat "[ " group " ]") (point-max) t)
          (progn
            (move-beginning-of-line nil)
            (ibuffer-toggle-filter-group)
            )
          )
        )
      )
    (goto-char 1)
    (search-forward "[ " (point-max) t)
    )
  (add-hook 'ibuffer-hook 'ibuffer-collapse-groups)

  (global-set-key (kbd "C-x k") (lambda () (interactive) (kill-buffer (current-buffer))))
  )

;; Cursor control
(global-set-key [(control left)] 'backward-word)
(global-set-key [(control right)] 'forward-word)
(global-set-key [(control meta up)] (lambda () (forward-line -5)))
(global-set-key [(control meta down)] (lambda () (forward-line 5)))
(delete-selection-mode 1)
(setq shift-select-mode t
      transient-mark-mode t)
(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end] 'end-of-buffer)
(setq mac-option-modifier 'meta)
(unless (fboundp 'region-active-p) (defun region-active-p () (and transient-mark-mode mark-active)))

;; Better scroll
(setq scroll-margin 2
      mouse-wheel-progressive-speed nil
      scroll-conservatively 10000
      fast-but-imprecise-scrolling t)

;; Background update file
(global-auto-revert-mode t)
(setq auto-revert-interval 1
      auto-revert-remote-files t)

;; Clipboard control
(defun cut-line-or-region ()
  "Cut line or region - this mimics Sublime Text's cut function"
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (kill-region (line-beginning-position) (line-beginning-position 2))
    )
  )
(global-set-key (kbd "C-w") 'cut-line-or-region)
(unless (file-remote-p default-directory) ; Tramp would freeze up w/ xclip
  (use-package xclip
    :ensure t
    :config (xclip-mode 1)
    )
  )
(setq yank-excluded-properties t
      delete-active-region t
      kill-do-not-save-duplicates t
      kill-ring-max 20)

;; Send clipboard over ssh
(use-package osc52
  :load-path "~/.emacs.d/lisp/"
  :config (osc52-set-cut-function)
  )

;; Sublime-style commenting
(defun comment-or-uncomment-region-or-line ()
  "Comment region or line - this mimics Sublime Text's commenting function"
  (interactive)
  (let (beg end was-selected)
    (setq was-selected (region-active-p))
    (if was-selected (setq beg (save-excursion
                                 (goto-char (region-beginning))
                                 (beginning-of-line)
                                 (point))
                           end (save-excursion
                                 (goto-char (region-end))
                                 (backward-char 1)
                                 (end-of-line)
                                 (point)))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)
    (unless was-selected (forward-line))
    )
  )
(global-set-key (kbd "M-;") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "s-/") 'comment-or-uncomment-region-or-line)

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  :bind ("C-q" . mc/mark-next-like-this-word)
  )

;; Git Gutter
(use-package git-gutter
  :ensure t
  :delight git-gutter-mode
  :after linum
  :init (setq git-gutter:added-sign "+"
              git-gutter:modified-sign "|"
              git-gutter:deleted-sign "-"
              git-gutter:update-interval 3
              git-gutter:hide-gutter t)
  :config (global-git-gutter-mode t)
          ;; (git-gutter:linum-setup)
  )

(defun isearch-highlighted-selection (forward)
  "Search for the highlighted selection, or perform the normal search"
  (if (region-active-p)
      (when (not (eq (region-beginning) (region-end)))
        (progn
          (setq isearch-string-selection (buffer-substring (region-beginning) (region-end)))
          (deactivate-mark)
          (isearch-mode forward nil nil nil)
          (isearch-yank-string isearch-string-selection)))
    (if forward (call-interactively 'isearch-forward)
      (call-interactively 'isearch-backward))
    )
  )
(global-set-key (kbd "C-s") (lambda () (interactive) (isearch-highlighted-selection t)))
(global-set-key (kbd "C-r") (lambda () (interactive) (isearch-highlighted-selection nil)))
(define-key isearch-mode-map (kbd "s-v") 'isearch-yank-kill)

;; Auto Complete
(use-package company
  :ensure t
  :delight company-mode
  :bind ("<M-tab>" . company-etags)
  :config (global-company-mode)
  ;; (set-face-attribute 'company-tooltip nil :foreground "lightgray" :foreground "black")
  ;; (set-face-attribute 'company-tooltip-selection nil :background "steelblue" :foreground "white")
  )

(use-package ido
  :ensure t
  :init (progn
          (setq ido-everywhere t)
          (ido-mode 1)
          )
  )

(use-package ido-vertical-mode
  :ensure t
  :after ido
  :init (ido-vertical-mode 1)
  )

(use-package flx-ido
  :ensure t
  :after ido
  :init (progn
          (setq flx-ido-use-faces nil
                ido-enable-flex-matching t)
          (flx-ido-mode 1)
          )
  )

(use-package smex
  :ensure t
  :after flx-ido
  :init (progn
          (setq custom-file (concat user-emacs-directory ".smex-items"))
          (smex-initialize)
          )
  :bind ("M-x" . smex)
  )

;; Paren config
(use-package paren
  :init (setq show-paren-delay 0.005)
  :config (show-paren-mode 1)
  (electric-pair-mode)
  )

;; Git stuff
(use-package magit
  :ensure t
  :commands (magit-blame)
  )

;; Syntax Highlighting and Auto style
(use-package asl-mode
  :load-path "~/.emacs.d/lisp/"
  :mode ("\\.asl\\'" "\\.asli\\'")
  :config (setq ws-major-mode-exceptions (nconc ws-major-mode-exceptions '(asl-mode)))
  )

(use-package lua-mode
  :ensure t
  :defer t
  :init (setq lua-indent-level 4)
  :config (setq ws-major-mode-exceptions (nconc ws-major-mode-exceptions '(lua-mode)))
  )

(use-package go-mode :ensure t :defer t)
(use-package swift3-mode :ensure t :defer t)
(use-package ruby-mode :ensure t :defer t)

(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" "README\\'" "\\.markdown\\'")
  )

(use-package dts-mode
  :ensure t
  :mode ("\\.dts\\'" "\\.dtsi\\'" "\\.dt\\'")
  :config (setq ws-major-mode-exceptions (nconc ws-major-mode-exceptions '(dts-mode)))
  )

(use-package python
  :mode (("\\.py\\'"  . python-mode)
         ("\\.pyc\\'" . python-mode)
         ("\\.wsgi$"  . python-mode))
  ;; :interpreter ("python" . python-mode)
  :init (setq python-shell-completion-native-disabled-interpreters '("python"))
  :config
  (add-hook 'inferior-python-mode-hook
            (lambda ()
              (define-key inferior-python-mode-map (kbd "C-x k") 'kill-buffer-and-window)
              ))
  )

(use-package yaml-mode
  :ensure t
  :mode "\\.yaml\\'"
  :config (setq ws-major-mode-exceptions (nconc ws-major-mode-exceptions '(yaml-mode)))
  )

(use-package cmake-mode
  :no-require t
  :mode ("CMakeLists.txt" "\\.cmake\\'")
  :config (autoload 'cmake-font-lock-activate "cmake-font-lock" nil t)
          (add-hook 'cmake-mode-hook 'cmake-font-lock-activate nil t)
  )

(use-package sh-script
  :mode (("\\.cfg\\'"         . sh-mode)
         ("\\.c*sh\\'"        . sh-mode)
         ("\\.[a-zA-Z]+rc\\'" . sh-mode))
  )

(use-package json
  :mode (("\\.sublime-settings\\'" . js-mode)
         ("\\.sublime-macro\\'"    . js-mode)
         ("\\.sublime-keymap\\'"   . js-mode))
  )

(use-package conf-mode
  :mode ("\\.ini\\'" "\\.fdf\\'" "\\.inf\\'" "\\.dec\\'" "build_rule.txt" "tools_def.txt" "target.txt" "\\.dsc\\'" "\\.template\\'")
  )

(use-package nhexl-mode
  :mode ("\\.o\\'" "\\.so\\'" "\\.dll\\'" "\\.exe\\'" "\\.macho\\'" "\\.efi\\'" "\\.pecoff\\'" "\\.hex\\'" "\\.bin\\'" "\\.fd\\'")
  )

(use-package cc-mode
  :init (setq c-default-style "stroustrup"
              c-basic-offset 4
              c-report-syntactic-errors t)
  :mode (("\\.mm\\'" . objc-mode))
  :config
  (setq ws-major-mode-exceptions (nconc ws-major-mode-exceptions '(c-mode)))
  (setq ws-major-mode-exceptions (nconc ws-major-mode-exceptions '(objc-mode)))
  (defun fix-new-brace ()
    (c-set-offset 'inline-open '0))
  (add-hook 'java-mode-hook 'fix-new-brace nil 'local)
  )

(use-package make-mode
  :mode (("\\.inc\\'" . makefile-mode)
         ("\\.mk\\'"  . makefile-mode)
         ("makefile'" . makefile-mode)
         ("Makefile"  . makefile-mode))
  )

(use-package asm-mode
  :mode ("\\.S\\'" "\\.s\\'")
  :config
  (add-hook 'asm-mode-hook (lambda()
                             (setq tab-width 2)
                             (setq asm-indent-level 2)))
  )

;; Allow editing of binary .plist files.
(add-to-list 'jka-compr-compression-info-list
             ["\\.plist$"
              "converting text XML to binary plist"
              "plutil"
              ("-convert" "binary1" "-o" "-" "-")
              "converting binary plist to text XML"
              "plutil"
              ("-convert" "xml1" "-o" "-" "-")
              nil nil "bplist"])
(jka-compr-update)

;; Org mode settings
(use-package org-mode
  :no-require t
  :defer t
  :init (setq org-hide-emphasis-markers t
              org-replace-disputed-keys t)
  :config (add-hook 'org-mode-hook
                    (lambda ()
                      (local-set-key [(meta left)] 'backward-word)
                      (local-set-key [(meta right)] 'forward-word)))
  )

;; TAG file settings
(setq large-file-warning-threshold (eval-when-compile (* 256 1024 1024))
      tags-revert-without-query t)

(use-package ag :ensure t )

;; (use-package ggtags
;;   :after projectile
;;   :delight ggtags-mode
;;   :commands ggtags-mode
;;   :ensure t
;;   :init (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
;;               (ggtags-mode 1))))
;;   )

;; (use-package xref
;;   :config
;;   (define-key xref--xref-buffer-mode-map (kbd "<return>") 'xref-quit-and-goto-xref)
;;   )

(use-package dumb-jump
  :ensure t
  :after ag
  :init (dumb-jump-mode)
  (setq dumb-jump-force-searcher 'ag)
  :bind (("M-." . dumb-jump-go)
         ("M-/" . dumb-jump-back)
         ("M-'" . dumb-jump-quick-look))
  )

(use-package projectile
  :ensure t
  :after ag
  :init
  (setq tags-add-tables nil)
  (define-advice projectile-grep (:override (&optional dir) ag)
    (projectile-ag (or dir (projectile-project-root))))
  ;; (setq projectile-mode-line-function '(lambda () (format " [%s]" (projectile-project-name))))
  (setq projectile-dynamic-mode-line nil
        projectile-mode-line-prefix nil)
  :config
  (projectile-mode +1)
  )
(global-set-key [remap xref-find-definitions] 'xref-find-definitions-other-frame)

;; Misc
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; Move custom-set variables out of this file
(setq custom-file (concat user-emacs-directory "custom.emacs"))
(load custom-file)
