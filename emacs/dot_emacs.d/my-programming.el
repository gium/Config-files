;;; my-programming.el --- programming functionnalities for my .emacs

;; Copyright (C) 2009, 2012  Guillaume SADEGH

(defvar my-programming-directory (concat user-emacs-directory "/programming/"))
(add-to-list 'load-path my-programming-directory)

;; Comment boxes
(autoload 'rebox "rebox" 1)
(defun fp-c-mode-routine ()
  (local-set-key "\M-q" (lambda () (interactive) (rebox-comment 223))))


;; GDB
(setq-default gdb-many-windows t) ;; GDB


;; compile / recompile bindings
(global-set-key [f7] 'compile)
(global-set-key [f8] 'recompile)
(global-set-key [(control c)(control c)] 'compile)
(global-set-key [(control c)(control p)] 'compilation-previous-error)
(global-set-key [(control c)(control n)] 'compilation-next-error)


;; Customize the compilation window
(setq compilation-window-height 10)
(setq compilation-scroll-output t)
(setq compilation-auto-jump-to-first-error t) ;; Since emacs23 (CVS / git)


;; Set files beginning with #! executable.
(add-hook 'after-save-hook
   '(lambda ()
    	     (progn
	       (and (save-excursion
		      (save-restriction
			(widen)
			(goto-char (point-min))
			(save-match-data
			  (looking-at "^#!"))))
		    (shell-command (concat "chmod u+x " buffer-file-name))
		    (message (concat "Saved as script: " buffer-file-name))
		    ))))


;; Autoinsert a shell shebang
(defun insert-shell-shebang ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (when (not (looking-at "^#!"))
      (insert "#! /bin/sh\n\n"))))


;; Doxygen
(autoload 'doxymacs "doxymacs" 1)
(setq doxymacs-doxygen-style "C++")
(defun my-doxymacs-font-lock-hook ()
  (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode))
      (doxymacs-font-lock)))
(add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)
(add-hook 'c-mode-common-hook 'doxymacs-mode)


;; Bison mode
(autoload 'bison-mode "bison-mode" 1)
(add-to-list 'auto-mode-alist '("\\.y$" . bison-mode))
(add-to-list 'auto-mode-alist '("\\.yy$" . bison-mode))


;; C mode
(add-hook 'c-mode-common-hook 'flyspell-prog-mode)
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-hook 'fp-c-mode-routine)
(c-set-offset 'substatement-open 0)	; change '{' indentation
(c-set-offset 'case-label '+) ; make each case line indent from switch

;; C++ shortcuts.
(defun c++-insert-content (start end content-start content-end)
  (interactive)
  (progn
    (goto-char end)
    (insert content-end)
    (goto-char start)
    (insert content-start)))

(defun c++-insert-namespace ()
  (interactive)
  (let* ((name (read-from-minibuffer "Namespace name: "))
         (content-start (concat "namespace " name "\n{\n"))
         (content-end (concat "} // end namespace " name ".\n")))
    (if (use-region-p)
        (save-excursion
          (let ((region-beginning (region-beginning))
                (region-end (region-end)))
            (c++-insert-content region-beginning region-end
                                content-start content-end)
            (indent-region region-beginning region-end)))
      (c++-insert-content (point) (point)
                          content-start content-end))))

(require 'cc-mode)
(define-key c-mode-base-map (kbd "C-c n")
  'c++-insert-namespace)

(defun c++-insert-struct ()
  (interactive)
  (let* ((name (read-from-minibuffer "Struct name: "))
         (content-start (concat "struct " name "\n{\n"))
         (content-end (concat "}; // end struct " name ".\n")))
    (if (use-region-p)
        (save-excursion
          (let ((region-beginning (region-beginning))
                (region-end (region-end)))
            (c++-insert-content region-beginning region-end
                                content-start content-end)
            (indent-region region-beginning region-end)))
      (c++-insert-content (point) (point)
                          content-start content-end))))

(define-key c-mode-base-map (kbd "C-c s")
  'c++-insert-struct)

(defun c++-insert-class ()
  (interactive)
  (let* ((name (read-from-minibuffer "Class name: "))
         (content-start (concat "class " name " {\n"))
         (content-end (concat "}; // end class " name ".\n")))
    (if (use-region-p)
        (save-excursion
          (let ((region-beginning (region-beginning))
                (region-end (region-end)))
            (c++-insert-content region-beginning region-end
                                content-start content-end)
            (indent-region region-beginning region-end)))
      (c++-insert-content (point) (point)
                          content-start content-end))))

(define-key c-mode-base-map (kbd "C-c c")
  'c++-insert-class)


;; (defun insert-guard ()
;;   (interactive)
;;   (beginning-of-buffer)
;;   (let ((define-name (replace-regexp-in-string "[\\./]" "_"
;; 					       (upcase (buffer-name)))))
;;     (insert "#ifndef " define-name "\n")
;;     (insert "# define " define-name "\n\n")
;;     (end-of-buffer)
;;     (insert "\n" "#endif // !" define-name "\n")))
;; 

;; C++ mode
(add-hook 'c++-mode-hook 'fp-c-mode-routine)


;; CSS mode
(autoload 'css-mode "css-mode" 1)
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))


;; D mode
(autoload 'd-mode "d-mode" 1)
(add-to-list 'auto-mode-alist '("\\.d$" . d-mode))


;; Flex mode
(autoload 'flex-mode "flex-mode" 1)
(add-to-list 'auto-mode-alist '("\\.l$" . flex-mode))
(add-to-list 'auto-mode-alist '("\\.ll$" . flex-mode))


;; Lua mode
(autoload 'lua-mode "lua-mode" 1)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))


;; Haskell mode
(add-to-list 'load-path (concat my-programming-directory "/haskell-mode/"))
(autoload 'haskell-mode "haskell-mode" 1)
(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . haskell-mode))


;; OCaml mode
(add-to-list 'load-path (concat my-programming-directory "/tuareg-mode/"))
(autoload 'tuareg "tuareg" 1)
(add-to-list 'auto-mode-alist '("\\.ml$" . tuareg-mode))
(add-to-list 'auto-mode-alist '("\\.mli$" . tuareg-mode))

;; Perl
;; (require 'cperl6-mode)


;; PHP mode
(autoload 'php-mode "php-mode" 1)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))


;; Promela mode
(autoload 'promela-mode "promela-mode" 1)
(add-to-list 'auto-mode-alist '("\\.pr$" . promela-mode))
(add-to-list 'auto-mode-alist '("\\.pml$" . promela-mode))


;; Python mode
(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))


;; Ruby mode
(require 'ruby-mode)
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))

(defun ruby-eval-buffer () (interactive)
  "Evaluate the buffer with ruby."
  (shell-command-on-region (point-min) (point-max) "ruby"))

(add-hook 'ruby-mode-hook
	  '(lambda () (define-key ruby-mode-map "\C-xe" 'ruby-eval-buffer)))


;; Scheme mode
(autoload 'quack "quack" 1)
(add-to-list 'auto-mode-alist '("\\.sc$" . quack))


;; Tiger mode
;; (require 'tiger-mode)
;; (add-to-list 'auto-mode-alist '("\\.tig$" . tiger-mode))
;; 

;; XML mode
(add-to-list 'auto-mode-alist '("\\.xml$" . sgml-mode))


;; YAML mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))


(provide 'my-programming)

;;; my-programming.el ends here
