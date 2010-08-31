;; Major mode for editing Promela source
;;
;; Author: Pat Tullmann
;; Last Edit: 18 Oct 1996
;;
;; LCD Archive Entry:
;; promela|Pat Tullmann|tullmann@cs.utah.edu|
;; Major mode for editing Promela source.|
;; 18-Oct-1996|||
;;
;; This file is not part of any Emacs
;;
;; This is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; promela.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with your Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
;;
;;; documentation
;;
;;; Acknowledgements
;;
;; Chris Maio's postscript-mode served as a template for my code.
;;
;;
;; The following two statements, placed in your .emacs file or site-init.el,
;; will cause this file to be autoloaded, and promela-mode invoked, when
;; visiting .pr files:
;;
;;	(autoload 'promela-mode "promela.el" "" t)
;;	(setq auto-mode-alist
;;	      (cons '("\\.pr$" . promela-mode) auto-mode-alist))
;;
;; Look for XXX's below for things to do...
;;

(provide 'promela)

;; XXX make buffer local ?
(defconst promela-indent-level 4
  "*Indentation to be used inside of Promela blocks")

(defvar promela-mode-syntax-table nil
  "Promela mode syntax table")

(defvar promela-mode-map nil
  "Keymap used in Promela mode buffers")

(defvar promela-font-lock-keywords nil
  "Font lock keywords used for font-lock mode")

(defun promela-mode nil
  "Major mode for editing Promela source.

In this mode, TAB and \\[indent-region] attempt to indent code
based on the position of if/fi, do/od, and {/} pairs.  The
variable promela-indent-level controls the amount of indentation
used inside each block type.

\\{promela-mode-map}

\\[promela-mode] calls the value of the variable promela-mode-hook
with no args, if that value is non-nil."
  (interactive)
  (kill-all-local-variables) ;; XXX Huh?!
  (use-local-map promela-mode-map)
  (if promela-mode-syntax-table
      (set-syntax-table promela-mode-syntax-table)
      (progn
	(setq promela-mode-syntax-table (make-syntax-table))
	(set-syntax-table promela-mode-syntax-table)
	;; sytanx mode info stolen from cc-mode
	(modify-syntax-entry ?_  "w"     promela-mode-syntax-table)
	(modify-syntax-entry ?\\ "\\"    promela-mode-syntax-table)
	(modify-syntax-entry ?+  "."     promela-mode-syntax-table)
	(modify-syntax-entry ?-  "."     promela-mode-syntax-table)
	(modify-syntax-entry ?=  "."     promela-mode-syntax-table)
	(modify-syntax-entry ?%  "."     promela-mode-syntax-table)
	(modify-syntax-entry ?<  "."     promela-mode-syntax-table)
	(modify-syntax-entry ?>  "."     promela-mode-syntax-table)
	(modify-syntax-entry ?&  "."     promela-mode-syntax-table)
	(modify-syntax-entry ?|  "."     promela-mode-syntax-table)
	(modify-syntax-entry ?\' "\""    promela-mode-syntax-table)
	;; C-style comments:
	(modify-syntax-entry ?/  ". 14"  promela-mode-syntax-table)
	(modify-syntax-entry ?*  ". 23"  promela-mode-syntax-table)
	))

  ;; define keys for promela mode
  (define-key promela-mode-map "\t" 'promela-tab)

  ;; XXX huh?
  (setq comment-column 45)

  ;; Setup font-lock keywords.  I've got a big machine and go all out.
  (setq promela-font-lock-keywords
	(list
	 ;; Fontify the basic keywords
	 (cons (concat
		"\\<\\(a\\(tomic\\|ssert\\)\\|"
		"b\\(it\\|yte\\|reak\\)\\|"
		"chan\\|d\\(_step\\|o\\)\\|else\\|fi\\|if\\|mtype\\|never"
		"\\|o\\(d\\|f\\)\\|"
		"proctype\\|run\\|skip\\)\\>")
		'font-lock-keyword-face)

	 ;; Fontify filenames in #include <...> preprocessor directives as strings.
	 '("^#[ \t]*include[ \t]+\\(<[^>\"\n]+>\\)" 1 font-lock-string-face)
	 ;;
	 ;; Fontify function macro names.
	 '("^#[ \t]*define[ \t]+\\(\\(\\sw+\\)(\\)" 2 font-lock-function-name-face)
	 ;;
	 ;; Fontify symbol names in #if ... defined preprocessor directives.
	 '("^#[ \t]*if\\>"
	   ("\\<\\(defined\\)\\>[ \t]*(?\\(\\sw+\\)?" nil nil
	    (1 font-lock-preprocessor-face) (2 font-lock-variable-name-face nil t)))
	 ;;
	 ;; Fontify symbol names in #elif ... defined preprocessor directives.
	 '("^#[ \t]*elif\\>"
	   ("\\<\\(defined\\)\\>[ \t]*(?\\(\\sw+\\)?" nil nil
	    (1 font-lock-preprocessor-face) (2 font-lock-variable-name-face nil t)))
	 ;;
	 ;; Fontify otherwise as symbol names, and the preprocessor directive names.
	 '("^\\(#[ \t]*[a-z]+\\)\\>[ \t]*\\(\\sw+\\)?"
	   (1 font-lock-preprocessor-face) (2 font-lock-variable-name-face nil t))
	 ))

  (setq font-lock-keywords promela-font-lock-keywords)

  (setq mode-name "Promela")
  (setq major-mode 'promela-mode)
  (run-hooks 'promela-mode-hook))

;;; --------
;;; Define callbacks for various keys we want to overload

(defun promela-tab nil
  "Command assigned to the TAB key in PostScript mode."
  (interactive)
  (indent-relative))

(defun promela-open nil
  (interactive)
  (insert last-command-char))

(defun promela-close nil
  "Inserts and indents a close delimiter."
  (interactive)
  (insert last-command-char)
  (backward-char 1)
  ;(promela-indent-close)
  (forward-char 1)
  (blink-matching-open))


;;; --------
;;; initialize the keymap if it doesn't already exist
(if (null promela-mode-map)
    (progn
      (setq promela-mode-map (make-sparse-keymap))
      (define-key promela-mode-map "{" 'promela-open)
      (define-key promela-mode-map "}" 'promela-close)
      (define-key promela-mode-map "[" 'promela-open)
      (define-key promela-mode-map "]" 'promela-close)
      (define-key promela-mode-map "\t" 'promela-tab)
      ))
