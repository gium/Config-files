
;;; my-writing.el --- Configuration for writing for my .emacs

;; Copyright (C) 2009  Guillaume SADEGH

(defvar my-writing-directory (concat user-emacs-directory "/writing/"))
(add-to-list 'load-path my-writing-directory)

;; Français
(set-language-environment "utf-8")
(setq locale-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(defun active-french-flyspell()
  (interactive)
  (flyspell-mode)
  (ispell-change-dictionary "fr")
  (flyspell-buffer)
  )
(global-set-key "\M-s" 'active-french-flyspell)


;; caractère œ
(defun sk-oe (&optional arg) "Insère le e dans l'o."
  (interactive "*P")
  (insert (make-char 'latin-iso8859-15 #xBD)))
(global-set-key "\M-oe" 'sk-oe)
(global-set-key "\M-o\M-e" 'sk-oe)


;; AucTEX
(add-to-list 'load-path (concat my-writing-directory "/auctex/"))
(require 'auctex)
(setq TeX-PDF-mode 1)
(setq-default TeX-master nil) ; Query for master file.


;; Count words
(defun count-words-region (start end)
  (interactive "r")
  (save-excursion
    (let ((n 0))
      (goto-char start)
      (while (< (point) end)
	(if (forward-word 1)
	    (setq n (1+ n))))
      (message "Region has %d words" n)
      n)))

(defun count-lines-words-region (start end)
  "Print number of lines words and characters in the region."
  (interactive "r")
  (message "Region has %d lines, %d words, %d characters"
 	   (count-lines start end)
           (count-words-region start end)
           (- end start)))

(defun word-count-analysis (start end)
  "Count how many times each word is used in the region.
    Punctuation is ignored."
  (interactive "r")
  (let (words)
    (save-excursion
      (goto-char start)
      (while (re-search-forward "\\w+" end t)
	(let* ((word (intern (match-string 0)))
	       (cell (assq word words)))
	  (if cell
	      (setcdr cell (1+ (cdr cell)))
	    (setq words (cons (cons word 1) words))))))
    (when (interactive-p)
      (message "%S" words))
    words))

(global-set-key [(control c)(l)] 'count-lines-words-region)
(global-set-key [(control c)(w)] 'word-count-analysis)

(defun count-lines-non-empty (start end)
  "Return number of non-empty lines between START and END.
This is usually the number of newlines between them, but can be
one more if START is not equal to END and the greater of them is
not at the start of a line."
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (goto-char (point-min))
      (+ (- (- (buffer-size) (forward-line (buffer-size)))
	    (count-matches "^$" start end)) 1))))

(defun count-lines-region (start end)
  "Print number of lines and characters in the region."
  (interactive "r")
  (message "Region has %d lines (%d non empty), %d characters"
	   (count-lines start end) (count-lines-non-empty start end) (- end start)))


(provide 'my-writing)
;;; my-writing.el ends here
