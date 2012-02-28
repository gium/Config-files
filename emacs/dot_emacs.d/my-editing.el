;;; my-editing.el --- Configuration for editions for my .emacs

;; Copyright (C) 2009, 2012  Guillaume SADEGH

(defvar my-editing-directory (concat user-emacs-directory "/editing/"))
(add-to-list 'load-path my-editing-directory)

;; Adjust copyright when writing the file.
(add-hook 'write-file-hooks 'copyright-update)


;; Trailing whitespace
(defmacro get-current-line()
  "Current line string"
  (buffer-substring (save-excursion (beginning-of-line) (point))
                    (save-excursion (end-of-line) (point))))

(defun delete-trailing-whitespace ()
  "Delete all the trailing whitespace across the current buffer.
All whitespace after the last non-whitespace character in a line is
deleted.
This respects narrowing, created by \\[narrow-to-region] and friends.
A formfeed is not considered whitespace by this function.
News' signature compliant."
  (interactive "*")
  (save-match-data
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "\\s-$" nil t)
        (if (string-match "^-- $" (get-current-line))
            (end-of-line)
          (skip-syntax-backward "-" (save-excursion (forward-line 0)
						    (point)))
          ;; Don't delete formfeeds, even if they are considered whitespace.
          (save-match-data
            (if (looking-at ".*\f")
                (goto-char (match-end 0))))
          (delete-region (point) (match-end 0)))))))

(add-hook 'write-file-hooks 'delete-trailing-whitespace)


;; Hooks
(defun my-message-mode-setup ()
  (setq fill-column 72)
  (turn-on-auto-fill))
(add-hook 'message-mode-hook 'my-message-mode-setup)
(add-hook 'text-mode-hook 'my-message-mode-setup)
(add-hook 'mail-mode-hook 'my-message-mode-setup)
(add-hook 'TeX-mode-hook 'my-message-mode-setup)



;; Functions
(defun dos-unix ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))

(defun unix-dos ()
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\n" nil t) (replace-match "\r\n")))

(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%c")))
(global-set-key [(control c)(d)] 'insert-date)


;; Ascii


(provide 'my-editing)
;;; my-editing.el ends here
