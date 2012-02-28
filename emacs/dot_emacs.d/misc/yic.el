;;; yic.el ---
(defun yic-ignore (str)
  (or
   (string-match "\\*Buffer List\\*" str)
   (string-match "\\*scratch\\*" str)
   (string-match "^TAGS" str)
   (string-match "^\\*Messages\\*$" str)
   (string-match "^\\*Completions\\*$" str)
   (string-match "^ " str)
   (memq str
         (mapcar
          (lambda (x)
            (buffer-name
             (window-buffer
              (frame-selected-window x))))
          (visible-frame-list)))
   ))

(defun yic-next (ls)
  (let* ((ptr ls)
	 bf bn go
	 )
    (while (and ptr (null go))
      (setq bf (car ptr)  bn (buffer-name bf))
      (if (null (yic-ignore bn))
	  (setq go bf)
	(setq ptr (cdr ptr))
	)
      )
    (if go
	(switch-to-buffer go))))

(defun yic-prev-buffer ()
  (interactive)
  (yic-next (reverse (buffer-list))))

(defun yic-next-buffer ()
  (interactive)
  (bury-buffer (current-buffer))
  (yic-next (buffer-list)))
(global-set-key [S-left] 'yic-prev-buffer) ; shift-left = previous buffer
(global-set-key [S-right] 'yic-next-buffer) ; shift-right = next buffer


(provide 'yic)
;;; yic.el ends here
