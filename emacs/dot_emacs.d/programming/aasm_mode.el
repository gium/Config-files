;
;    This file is part of AASM.
;
;    AASM is free software; you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation; either version 2 of the License, or
;    (at your option) any later version.
;
;    AASM is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with AASM; if not, write to the Free Software
;    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
;
;    Copyright Alexandre Becoulet, 2002
;    contact : alexandre.becoulet@epita.fr
;

(defvar aasm-mode-hook nil)
(defvar aasm-mode-map nil
  "Keymap for AASM major mode")

(if aasm-mode-map nil
  (setq aasm-mode-map (make-keymap)))

(setq auto-mode-alist
          (append '(("\\.aam\\'" . aasm-mode))
           auto-mode-alist))

(defconst aasm-font-lock-keywords-1
  (list
   '(";.*" . font-lock-comment-face)
   '("^\\s-*\\w+" . font-lock-function-name-face)
   '("^\\s-*\\.\\w+" . font-lock-keyword-face)
   '("^\\s-*\\@\\w+" . font-lock-constant-face)
   )

  "Minimal highlighting expressions for AASM mode")

(defvar aasm-font-lock-keywords aasm-font-lock-keywords-1
  "Default highlighting expressions for AASM mode.")

(defun aasm-indent-line ()
  "Indent current line as AASM code."

  (interactive)
  (beginning-of-line)
  
  (if (bobp)
      (indent-line-to 0)
    (let ((not-indented t) cur-indent)

      (if (looking-at "^\\s-*\\.end")
	  (progn
	    
	    (save-excursion
	      (forward-line -1)
	      
	      (while (and (looking-at "^\\s-*$") (not (bobp)))
		(forward-line -1))
	      
	      (setq cur-indent (- (current-indentation) default-tab-width)))
	    
	    (if (< cur-indent 0)
		(setq cur-indent 0)))
	
	(save-excursion
	  
	  (while not-indented
	    (forward-line -1)

	    (while (and (looking-at "^\\s-*$") (not (bobp)))
	      (forward-line -1))
	      
	    (if (bobp)
		(setq not-indented nil)
	      		
	      (if (looking-at "^\\s-*\\.\\(section\\|proc\\|macro\\)")
		  (progn
		    
		    (setq cur-indent (+ (current-indentation) default-tab-width))
		    (setq not-indented nil)
		    )

 		    (progn
		    
		    (setq cur-indent (current-indentation))
		      (setq not-indented nil))
		  
		    )))))
	
      (if cur-indent (indent-line-to cur-indent) (indent-line-to 0))
      )
    )
  )

(defvar aasm-mode-syntax-table nil
  "Syntax table for aasm-mode.")


(defun aasm-create-syntax-table ()

  (if aasm-mode-syntax-table
        ()

    (setq aasm-mode-syntax-table (make-syntax-table))
    (set-syntax-table aasm-mode-syntax-table)

    (modify-syntax-entry ?_ "w" aasm-mode-syntax-table)))
  
(defun aasm-mode ()

  "Major mode for editing AASM source files."
  (interactive)

  (kill-all-local-variables)
  (aasm-create-syntax-table)

  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults

	'(aasm-font-lock-keywords))

  (make-local-variable 'indent-line-function)

  (setq indent-line-function 'aasm-indent-line)

  (setq major-mode 'aasm-mode)
  (setq mode-name "AASM")

  (run-hooks 'aasm-mode-hook))

(provide 'aasm-mode)

