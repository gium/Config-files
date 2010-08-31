;;; my-gnus.el --- My configuration for Gnus

;; Copyright (C) 2009  Guillaume SADEGH

(defvar my-gnus-directory (concat user-emacs-directory "/gnus/"))
(add-to-list 'load-path my-gnus-directory)

(defvar epita-login "sadegh_g")
(defvar organization "ÉPITA")

;; General configuration
(require 'smtpmail)

(setq gnus-local-organization organization)
(defvar message-default-headers (concat "X-login: " epita-login))
(setq smtpmail-default-smtp-server "smtp.free.fr")
(defvar message-cite-function 'message-cite-original-without-signature) ;; Signature
(setq send-mail-function 'smtpmail-send-it)
(defvar gnus-ignored-mime-types '("text/x-vcard")) ; On ignore les types v-card
(defvar gnus-visible-headers "^\\(From:\\|Subject:\\|Date:\\|Followup-To:\\|Newsgroups:\\|To:\\|Cc:\\|X-Newsreader:\\|User-Agent:\\|X-Mailer:\\)")
(defvar gnus-article-decode-charset 1)
;; (setq message-default-headers
;;       (concat "X-login: " epita-login "\n"
;; 	      (with-temp-buffer
;; 		(insert "Face: ")
;; 		(insert (gnus-face-from-file "~/face.jpg"))
;; 		(buffer-string)
;; 		)
;; 	      )
;;       )


;; Servers
(setq gnus-select-method '(nntp "news.epita.fr")
      gnus-secondary-select-methods '((nnml "")))
(add-to-list 'gnus-secondary-select-methods
	     '(nntp "news.lrde.epita.fr"
		    (nntp-open-connection-function nntp-open-tls-stream)
		    (nntp-port-number 563)
                    (nntp-address "news.lrde.epita.fr")))


;; Hooks
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode) ;; Topic mode
(add-hook 'gnus-article-display-hook 'gnus-article-highlight)
(add-hook 'gnus-article-display-hook 'gnus-article-hide-boring-headers)
(add-hook 'gnus-article-display-hook 'gnus-article-strip-leading-blank-lines)
(add-hook 'gnus-article-display-hook 'gnus-article-remove-trailing-blank-lines)
(add-hook 'gnus-article-display-hook 'gnus-article-strip-multiple-blank-lines)
(add-hook 'message-mode-hook 'turn-on-font-lock)
(add-hook 'gnus-article-display-hook 'gnus-article-emphasize)
(add-hook 'gnus-message-setup-hook 'font-lock-fontify-buffer)


;; Gnus modules
(require 'gnus-stat)
(require 'cersti-photo)


;; Web functionnalities
(add-to-list 'load-path (concat my-gnus-directory "/emacsURL/emacs/site-lisp"))
(add-to-list 'load-path (concat my-gnus-directory "/emacsW3/share/emacs/site-lisp"))

;; Functions and keys.
(defun my-gnus-summary-show-thread ()
  "Show thread without changing cursor positon."
  (interactive)
  (gnus-summary-show-thread)
  (beginning-of-line)
  (forward-char 1))
(define-key gnus-summary-mode-map [(right)] 'my-gnus-summary-show-thread)
(define-key gnus-summary-mode-map [(left)]  'gnus-summary-hide-thread)


(provide 'my-gnus)
;;; my-gnus.el ends here
