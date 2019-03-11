;; Speed up startup by running gc later and not running regex on plugins
(let ((file-name-handler-alist nil))
(setq gc-cons-threshold 268435456)

;; Include package repos for updates
(setq package-enable-at-startup nil)

;; GUI stuff, remove line-break character and auto-wrap, highlight parens
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode) (horizontal-scroll-bar-mode -1))
(setq auto-window-vscroll nil)
(fset 'yes-or-no-p 'y-or-n-p)
(setq-default inhibit-startup-message t
              visible-bell nil
              initial-scratch-message nil
              column-number-mode t
              indicate-empty-lines t
              initial-scratch-message ""
              jit-lock-defer-time 0.075
              bidi-display-reordering nil
              )
;; (set-display-table-slot standard-display-table 'wrap ?\ )

;; Prevent autosave and writing in directory
(add-hook 'find-file-hook (lambda () (setq buffer-read-only t)))
(buffer-disable-undo)
(setq auto-save-default nil
      make-backup-files nil
      create-lockfiles nil)

;; Cursor control
(global-set-key [(control left)] 'backward-word)
(global-set-key [(control right)] 'forward-word)
(setq shift-select-mode t)
(setq transient-mark-mode t)
(unless (fboundp 'region-active-p) (defun region-active-p () (and transient-mark-mode mark-active)))

;; Better scroll
(setq mouse-wheel-progressive-speed nil
      scroll-step 3
      scroll-conservatively 10000)

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

;; Syntax Highlighting and Auto style
(add-to-list 'auto-mode-alist '("\\.emacs-lite\\'" . emacs-lisp-mode))
(add-to-list 'auto-mode-alist '("\\.emacs-ev\\'" . emacs-lisp-mode))

(add-to-list 'auto-mode-alist '("\\.sublime-macro\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.sublime-keymap\\'" . js-mode))
(add-to-list 'auto-mode-alist '("\\.sublime-settings\\'" . js-mode))
(setq c-default-style "stroustrup"
      c-basic-offset 4)

)
