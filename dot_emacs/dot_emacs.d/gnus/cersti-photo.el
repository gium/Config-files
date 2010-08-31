;;; cersti-photo.el --- CERSTI photos in gnus.
;;
;; Copyright (C) 2007 Michaël Cadilhac

;; Author: Michaël Cadilhac <michael.cadilhac@lrde.org>
;; Keywords: CERSTI, Gnus, photos

;; This code is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This code is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
;; General Public License for more details.

;;; Code:

;;; User variables:

(require 'gnus-sum)
(require 'url)
(require 'gnus-art)

;; Integration in Gnus.
(add-to-list 'gnus-treatment-function-alist
	     '(gnus-treat-display-cersti-photos article-display-cersti-photo))

(defgroup gnus-cersti-photos nil
  "CERSTI photos in Gnus."
  :group 'gnus)

(defcustom gnus-treat-display-cersti-photos
  (and (not noninteractive)
       (gnus-image-type-available-p 'jpeg)
       (featurep 'url)
       'head)
  "If non-nil, display CERSTI photos in Gnus."
  :group 'gnus-article-treat
  :type gnus-article-treat-head-custom)

(defcustom gnus-cersti-photo-width 60
  "Width for the photo.
This works only with the default value of `gnus-cersti-photo-url'."
  :group 'gnus-cersti-photos
  :type '(integer))

(defcustom gnus-cersti-photo-height 72
  "Height for the photo.
This works only with the default value of `gnus-cersti-photo-url'."
  :group 'gnus-cersti-photos
  :type '(integer))

(defcustom gnus-cersti-photo-path "~/.emacs.d/cersti-photos"
  "Path to store photos once downloaded."
  :group 'gnus-cersti-photos
  :type '(string))

(defcustom gnus-cersti-photo-url
  "http://michael.cadilhac.name/photo.php?login=%s&width=%d&height=%d"
  "Url for photo retrieving.
`%s' will be replaced with the login, the following two `%d' by the
width and the height of the photo.
Note that the photo is not resized in Emacs."
  :group 'gnus-cersti-photos
  :type '(string))


;;; Functions:

(defun article-display-cersti-photo-retriever (state buffer &optional path)
  "Store the photo in PATH.
Thes display it with `article-display-cersti-photo-in-from' in BUFFER.
This function is to be called by `url-retrieve', thus STATE."
  ;; Prevent the use of old-fashioned url-retrieve.
  (unless login
    (setq login buffer
	  buffer state))
  (goto-char (point-min))
  ;; If the download is OK (ugly heuristic).
  (when (search-forward "g\n" nil t)
    (let ((data (substring (buffer-string) (point)))
	  (gnus-cersti-photo-path (expand-file-name gnus-cersti-photo-path)))
      (if (file-directory-p gnus-cersti-photo-path)
	  (unless (file-accessible-directory-p gnus-cersti-photo-path)
	    (error "Directory %s is not accesible" gnus-cersti-photo-path))
	(make-directory gnus-cersti-photo-path t))
      (erase-buffer)
      (setq buffer-file-coding-system 'binary)
      (insert data)
      (write-region (point-min) (point-max) path nil 'quiet)
      (kill-buffer (current-buffer))
      (when (and (bufferp buffer) (buffer-live-p buffer))
	(with-current-buffer buffer
	  ;; If this test fails, the user skipped between two messages
	  ;; too quickly.
	  (when (and (boundp 'cersti-photo-path) (string= path cersti-photo-path))
	    (let ((buffer-read-only))
	      (article-display-cersti-photo-in-from path))))))))


(defun article-display-cersti-photo-in-from (path)
  "Display the CERSTI photo PATH in the From header."
  (let ((default-enable-multibyte-characters nil))
    (when (gnus-image-type-available-p 'jpeg)
      (save-excursion
	(save-restriction
	  (article-narrow-to-head)
	  (gnus-article-goto-header "from")
	  (when (bobp)
	    (insert "From: [no `from' set]\n")
	    (forward-char -17))
	  (gnus-add-image
	   'cersti-photo
	   (gnus-put-image
	    (gnus-create-image path 'jpeg)
	    nil 'cersti-photo)))))))

(defun article-display-cersti-photo ()
  "Look if the mail is CERSTI-like, and use it to fetch a photo."
  (interactive)
  (gnus-with-article-headers
    ;; Display CERSTI photo.
    (let (from face)
      (save-current-buffer
	(save-restriction
	  (mail-narrow-to-head)
	  (unless (setq login (message-fetch-field "x-login"))
	    (if (string-match "\\([A-Za-z0-9_-]*\\)@\\(.*epi.*\\|cersti\\)"
			      (setq login (message-fetch-field "from")))
		(setq login (match-string 1 login))
	      (setq login)))))
      (when login
	(let ((photo-path (concat (expand-file-name gnus-cersti-photo-path)
				      "/" login ".jpg")))
	  (set (make-local-variable 'cersti-photo-path) photo-path)
	  (if (not (file-readable-p photo-path))
	      (url-retrieve (format gnus-cersti-photo-url login
				    gnus-cersti-photo-width
				    gnus-cersti-photo-height)
			    'article-display-cersti-photo-retriever
			    `(,(current-buffer) ,photo-path))
	    (article-display-cersti-photo-in-from photo-path)))))))


(provide 'cersti-photo)

;;; arch-tag: caeec4bd-7c76-4f20-b5d0-7635ba4dbd15
;;; cersti-photo.el ends here.
