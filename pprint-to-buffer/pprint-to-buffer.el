;;; pprint-to-buffer.el --- pprint elisp expressions, just like in CIDER
;;
;; Filename: pprint-to-buffer.el
;; Description:
;; Author: Arne Brasseur
;; Maintainer:
;; Created: Do Jul 19 17:10:31 2018 (+0200)
;; Version: 0.1.1
;; Package-Requires: ((cider "0.17.0"))
;; URL:
;; Doc URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;  C-c C-p evaluates sexp before point and pops up a buffer with the result
;;  pretty printed.
;;
;;  Add a prefix argument to insert at point instead.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(require 'cider-popup)

(defun pprint-to-buffer--pop-to-buffer (form)
  "Pretty print FORM in popup buffer."
  (let* ((result-buffer (cider-popup-buffer "*pprint*" nil 'emacs-lisp-mode)))
    (with-current-buffer result-buffer
      (read-only-mode -1)
      (insert (format "%S" (eval form)))
      (goto-char 1)
      (cl--do-prettyprint))))

(defun pprint-to-buffer--eval-and-insert (form)
  "Pretty print FORM and insert at point."
  (lisp-indent-line)
  (let ((pos (point)))
    (insert (format "%S" (eval form)))
    (goto-char pos)
    (cl--do-prettyprint)))

(defun pprint-to-buffer-last-sexp-to-current-buffer ()
  "Evaluate the sexp preceding point and pprint its value into the current buffer."
  (interactive)
  (pprint-to-buffer--eval-and-insert (elisp--preceding-sexp)))

(defun pprint-to-buffer-last-sexp (&optional output-to-current-buffer)
  "Evaluate the sexp preceding point and pprint its value.
  If invoked with OUTPUT-TO-CURRENT-BUFFER, insert as comment in the current
  buffer, else display in a popup buffer."
  (interactive "P")
  (if output-to-current-buffer
      (pprint-to-buffer-last-sexp-to-current-buffer)
    (pprint-to-buffer--pop-to-buffer (elisp--preceding-sexp))))

;; (define-key emacs-lisp-mode-map (kbd "C-c C-p") 'pprint-to-buffer-last-sexp)

(provide 'pprint-to-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; pprint-to-buffer.el ends here
