;;; init-lite.el --- customizations     -*- lexical-binding: t; -*-

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

;; GUI stuff, remove line-break character and auto-wrap, highlight parens
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode) (horizontal-scroll-bar-mode -1))
(when (fboundp 'tooltip-mode) (tooltip-mode -1))
(fset 'yes-or-no-p 'y-or-n-p)
(setq-default inhibit-startup-message t
              inhibit-startup-echo-area-message t
              initial-scratch-message nil
              visible-bell nil
              initial-scratch-message nil
              auto-window-vscroll nil
              column-number-mode t
              indicate-empty-lines t
              initial-scratch-message ""
              nobreak-char-display t
              jit-lock-defer-time 0.075
              bidi-display-reordering nil
              )
(setq show-paren-delay 0.05)
(show-paren-mode 1)

;; Goto-line
(define-key global-map (kbd "C-l") 'goto-line)

;; Prevent autosave in directory
(setq auto-save-default nil
      make-backup-files nil
      create-lockfiles nil)

;; Whitespace Manipulation
(setq-default indent-tabs-mode nil)
(setq tab-width 4
      default-tab-width 4)
(fmakunbound 'backward-delete-char-untabify)
(fset 'backward-delete-char-untabify 'backward-delete-char)
(global-set-key (kbd "<backspace>") 'backward-delete-char)
(setq require-final-newline t)

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
      scroll-conservatively 10000)

;; Clipboard control
(defun cut-line-or-region () (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end) t)
    (kill-region (line-beginning-position) (line-beginning-position 2))
    )
  )
(global-set-key [(control w)] 'cut-line-or-region)

;; Sublime-style commenting
(defun comment-or-uncomment-region-or-line () (interactive)
  (let (beg end was-highlighted)
    (setq was-highlighted (region-active-p))
    (if was-highlighted (progn
                          (setq beg (save-excursion
                                      (goto-char (region-beginning))
                                      (beginning-of-line)
                                      (point))
                                end (save-excursion
                                      (goto-char (region-end))
                                      (backward-char 1)
                                      (end-of-line)
                                      (point))))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)
    (unless was-highlighted (forward-line))
    ))
(global-set-key (kbd "M-/") 'comment-or-uncomment-region-or-line)

;; Search forward for highlighted selection, or normal forward search
(defun isearch-forward-selection () (interactive)
       (if (region-active-p)
           (when (not (eq (region-beginning) (region-end)))
             (progn
               (setq isearch-string-selection (buffer-substring (region-beginning) (region-end)))
               (deactivate-mark)
               (isearch-mode t nil nil nil)
               (isearch-yank-string isearch-string-selection)))
         (call-interactively 'isearch-forward)
         )
       )
(defun isearch-backward-selection () (interactive)
       (if (region-active-p)
           (when (not (eq (region-beginning) (region-end)))
             (progn
               (setq isearch-string-selection (buffer-substring (region-beginning) (region-end)))
               (deactivate-mark)
               (isearch-mode nil nil nil nil)
               (isearch-yank-string isearch-string-selection)))
         (call-interactively 'isearch-backward)
         )
       )
(global-set-key (kbd "C-s") 'isearch-forward-selection)
(global-set-key (kbd "C-r") 'isearch-backward-selection)

;; Highlight region after isearch
(defun select-matching-search ()
  (unless (string= isearch-string "")
    (progn
      (set-mark isearch-other-end)
      (if isearch-forward
          (goto-char (+ isearch-other-end (length isearch-string)))
        (goto-char (- isearch-other-end (length isearch-string))))
      (mark))
    )
  )
(add-hook 'isearch-mode-end-hook 'select-matching-search)

;; Syntax Highlighting and Auto style
(defun fix-new-brace ()
  (c-set-offset 'inline-open '0))
(add-hook 'java-mode-hook 'fix-new-brace)
(setq c-default-style "stroustrup"
      c-basic-offset 4)

(setq lua-indent-level 4)

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
