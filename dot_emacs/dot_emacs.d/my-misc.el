;;; my-misc.el --- misc functionnalities for my .emacs

;; Copyright (C) 2009, 2010  Guillaume SADEGH

(defvar my-misc-directory (concat user-emacs-directory "/misc/"))
(add-to-list 'load-path my-misc-directory)
(defvar epita-login "sadegh_g")

;; General behavior
(partial-completion-mode t) ;; M-x p-c-m TAB => partial-completion-mode
(defvar current-fill-column 72)
(setq inhibit-startup-message t)    ; don't show the GNU splash screen
(setq initial-scratch-message "")
(scroll-bar-mode -1)		    ; no scroll bar
(menu-bar-mode -1)		    ; no menu bar
(tool-bar-mode -1)		    ; no tool bar
(setq frame-title-format "%b")	    ; titlebar shows buffer's name
(global-font-lock-mode t)	    ; syntax highlighting
(setq font-lock-maximum-decoration t) ; maximum decoration for all modes
(show-paren-mode t)		  ; show opposing paren while hovering
(setq scroll-step 1)		  ; smooth scrolling
(delete-selection-mode t)	  ; typing removes highlighted text
(column-number-mode t)		  ; display column number in modeline
(defvar display-time-24hr-format t)    ; european 24h format
(auto-compression-mode t)	     ; open compressed files
(mouse-wheel-mode t)		     ; enable mouse wheel
(fset 'yes-or-no-p 'y-or-n-p)	     ; y or n will do
(setq default-major-mode 'text-mode) ; change default major mode to text
(setq ring-bell-function 'ignore)    ; turn the alarm totally off
(setq-default indent-tabs-mode nil)   ; spaces instead of tabs
(setq make-backup-files nil)		; no backupfile
(setq delete-auto-save-files t)	   ; delete unnecessary autosave files
(setq delete-old-versions t)	   ; delete oldversion file
(setq next-line-add-newlines nil)  ; prevents new line after eof
(normal-erase-is-backspace-mode t)
(auto-insert-mode t)
(transient-mark-mode t)
(setq confirm-nonexistent-file-or-buffer nil) ; Do not ask before opening a
                                              ; new file. (E23.1)
(when (>= emacs-major-version 22)
  (ido-mode t)                     ; ido-mode
  (ido-everywhere t)
  (defvar ido-confirm-unique-completion t)
  (defvar ido-auto-merge-work-directories-length -1))

(require 'yic)                     ; change buffers

(require 'uniquify)                ; rename buffers with the same name
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)


;; Emacs appearance
(add-to-list 'load-path (concat my-misc-directory "/color-theme/"))
(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)
;;(set-frame-font "-adobe-courier-medium-R-normal--14-140-75-75-m-90-iso8859-1")
(set-frame-font "-adobe-courier-medium-R-normal--14-140-75-75-m-90-iso8859-1")


;; Key bindings
(global-set-key [f11] (lambda () (interactive) (manual-entry (current-word))))
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)


;; Netsoul
(add-to-list 'load-path (concat my-misc-directory "/enetsoul/"))
(require 'netsoul)
(global-set-key [f5] 'netsoul-show)
(setq netsoul-chat-mode-hook 'flyspell-mode)
(setq netsoul-beep-on-message t)
(setq netsoul-host "ns-server.epita.fr")
(setq netsoul-login epita-login)
(setq netsoul-port 4242)
(setq netsoul-user-data (concat "Using Emacs-" emacs-version))
(setq netsoul-location "Laptop")


;; Music player -- MPC
(require 'mpcel)



;; Change emacs font size
(defun big-size ()
  (interactive)
  (message "big size : 25")
  (set-default-font "-adobe-courier-medium-R-normal--25-180-100-100-m-150-iso8859-1"))

(defun medium-size ()
  (interactive)
  (message "medium size : 17")
  (set-default-font "-adobe-courier-medium-R-normal--17-120-100-100-m-100-iso8859-1"))

(defun normal-size ()
  (interactive)
  (message "normal size : 14")
  (set-default-font "-adobe-courier-medium-R-normal--14-140-75-75-m-90-iso8859-1"))

(global-set-key [(control c) (+)] 'big-size)
(global-set-key [(control c) (-)] 'normal-size)


;; Features to increment a number
(defun increment-number-at-point (&optional incr)
  "Increment the number under point by `incr'. If `incr' isn't
define, the number is incremented by 1"
  (interactive "p")
  (let ((initial-point (point)))
    (save-excursion
      (skip-chars-forward ".0123456789")
      (let ((p (point)))
	(skip-chars-backward "-.0123456789")
	(when (> (- p (point)) 0)
	  (let* ((nb-str (delete-and-extract-region (point) p))
		 (new-nb (+ (or incr 1) (string-to-number nb-str))))
	    (insert (number-to-string new-nb))))))
    (goto-char initial-point)))

(defun decrement-number-at-point (&optional incr)
  "Decrement the number under point by `incr'. If `incr' isn't
define, the number is decremented by 1"
  (interactive "p")
  (increment-number-at-point (- (or incr 1))))

(global-set-key [(control x) (a) (a)] 'increment-number-at-point)
(global-set-key [(control x) (a) (q)] 'decrement-number-at-point)


;; twitter-mode
(require 'twittering-mode)
(setq twittering-username "gium")



;; (require findr)

(provide 'my-misc)

;;; my-misc.el ends here
