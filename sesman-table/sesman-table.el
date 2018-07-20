;;; sesman-table.el ---
;;
;; Filename: sesman-table.el
;; Description:
;; Author: Arne Brasseur
;; Maintainer:
;; Created: Do Jul 19 16:41:25 2018 (+0200)
;; Version: 0.1.0
;; Package-Requires: ((ctable "0.1.2"))
;; Last-Updated:
;;           By:
;;     Update #: 0
;; URL:
;; Doc URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;
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

(make-variable-buffer-local '*sesman-component*)

(defun sesman-table--sessions ()
  (seq-map
   (lambda (k)
     (list* (car k) (a-get sesman-sessions-hashmap k)))
   (a-keys sesman-sessions-hashmap)))

(defun sesman-table--selected-session ()
  (let* ((row (ctbl:cp-get-selected-data-row *sesman-component*))
         (system (cl-first row))
         (session (cl-second row)))
    (a-get sesman-sessions-hashmap (cons system session))))

(defun sesman-table-kill-selected ()
  (interactive)
  (let* ((row (ctbl:cp-get-selected-data-row *sesman-component*))
         (system (cl-first row))
         (session (cl-third row)))
    (sesman-unregister system (sesman-table--selected-session))
    (sesman-quit-session system (sesman-table--selected-session))
    (ctbl:cp-set-model *sesman-component* (sesman-table-model))))

(defun sesman-table-next ()
  (interactive)
  (let ((cell (ctbl:cp-get-selected *sesman-component*)))
    (ctbl:cp-set-selected-cell *sesman-component* (cons (1+ (car cell)) (cdr cell)))))

(defun sesman-table-previous ()
  (interactive)
  (let ((cell (ctbl:cp-get-selected *sesman-component*)))
    (ctbl:cp-set-selected-cell *sesman-component* (cons (1- (car cell)) (cdr cell)))))

(setq sesman-table-keymap
      (let ((map (make-sparse-keymap)))
        (define-key map (kbd "<up>") 'sesman-table-previous)
        (define-key map (kbd "<down>") 'sesman-table-next)
        (define-key map (kbd "k") 'sesman-table-kill-selected)
        (define-key map (kbd "q") 'kill-buffer)
        map))

(defun sesman-table-column-model ()
  (list (make-ctbl:cmodel
         :title "Type"
         :min-width 15
         :align 'left)
        (make-ctbl:cmodel
         :title "Name"
         :min-width 20
         :align 'left)
        (make-ctbl:cmodel
         :title "Buffer"
         :align 'left)))

(defun sesman-table-model ()
  (make-ctbl:model :column-model (sesman-table-column-model)
                   :data (sesman-table--sessions)))

(defun sesman-table-show ()
  (interactive)
  (let* ((component (ctbl:create-table-component-buffer :model (sesman-table-model)
                                                        :custom-map sesman-table-keymap))
         (buffer (ctbl:cp-get-buffer component)))
    (with-current-buffer buffer
      (setq *sesman-component* component))
    (pop-to-buffer buffer)))

(provide 'sesman-table)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sesman-table.el ends here
