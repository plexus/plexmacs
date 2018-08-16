;;; sesman-table.el --- A handy UI for sesman sessions and links
;;
;; Filename: sesman-table.el
;; Description:
;; Author: Arne Brasseur
;; Maintainer:
;; Created: Do Jul 19 16:41:25 2018 (+0200)
;; Version: 0.2.1
;; Package-Requires: ((ctable "0.1.2") (sesman "0.1.1"))
;; URL: https://github.com/plexus/plexmacs#sesman-table
;; Doc URL:
;; Keywords:
;; Compatibility:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; Show sesman sessions/links/buffers in a handy table.
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

(require 'sesman)
(require 'ctable)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; borrowed from CIDER

(defun sesman-table--cider-make-popup-buffer (name &optional mode ancillary)
  "Create a temporary buffer called NAME using major MODE (if specified)."
  (with-current-buffer (get-buffer-create name)
    (kill-all-local-variables)
    (setq buffer-read-only nil)
    (erase-buffer)
    (when mode
      (funcall mode))
    ;; (cider-popup-buffer-mode 1)
    ;; (setq cider-popup-output-marker (point-marker))
    (setq buffer-read-only t)
    ;; (when ancillary
    ;;   (add-to-list 'cider-ancillary-buffers name)
    ;;   (add-hook 'kill-buffer-hook
    ;;             (lambda ()
    ;;               (setq cider-ancillary-buffers
    ;;                     (remove name cider-ancillary-buffers)))
    ;;             nil 'local))
    (current-buffer)))

(defun sesman-table--cider-popup-buffer-display (buffer &optional select)
  "Display BUFFER.
If SELECT is non-nil, select the BUFFER."
  (let ((window (get-buffer-window buffer 'visible)))
    (when window
      (with-current-buffer buffer
        (set-window-point window (point))))
    ;; If the buffer we are popping up is already displayed in the selected
    ;; window, the below `inhibit-same-window' logic will cause it to be
    ;; displayed twice - so we early out in this case. Note that we must check
    ;; `selected-window', as async request handlers are executed in the context
    ;; of the current connection buffer (i.e. `current-buffer' is dynamically
    ;; bound to that).
    (unless (eq window (selected-window))
      ;; Non nil `inhibit-same-window' ensures that current window is not covered
      ;; Non nil `inhibit-switch-frame' ensures that the other frame is not selected
      ;; if that's where the buffer is being shown.
      (funcall (if select #'pop-to-buffer #'display-buffer)
               buffer `(nil . ((inhibit-same-window . ,pop-up-windows)
                               (reusable-frames . visible))))))
  buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; The ctable "component", needed in actions to look up the current selection.
(make-variable-buffer-local '*sesman-component*)

(defun sesman-table--sessions ()
  (seq-map
   (lambda (k)
     (list* (car k) (a-get sesman-sessions-hashmap k)))
   (a-keys sesman-sessions-hashmap)))

(defun sesman-table--links-table (links)
  (let* ((buffers     (map-elt links 'buffer))
         (directories (map-elt links 'directory))
         (projects    (map-elt links 'project)))

    (append
     (seq-map (lambda (p) (list "" "" 'PROJECT (concat
                                                ;;(symbol-name (car p))
                                                ;;": "
                                                (cdr p))) )
              projects)
     (seq-map (lambda (d) (list "" "" 'DIRECTORY d) ) directories)
     (seq-map (lambda (b) (list "" ""  'BUFFER (buffer-file-name b)) ) buffers))))

(defun sesman-table--repl-table (repls)
  (seq-map (lambda (r) (list "" "" 'REPL r)) repls))

(defun sesman-table--data ()
  (apply #'append
         (map-apply (lambda (name session)
                      (let ((system (car name))
                            (ses-name (cdr name)))

                        (append
                         `((,system ,ses-name SESSION ,(cider--connection-info (cadr session) t)))
                         (sesman-table--links-table (sesman-current-links system session))
                         (sesman-table--repl-table (cdr session)))))
                    sesman-sessions-hashmap)))

(defun sesman-table--selected-session ()
  (let* ((row (ctbl:cp-get-selected-data-row *sesman-component*))
         (system (cl-first row))
         (session (cl-second row)))
    (a-get sesman-sessions-hashmap (cons system session))))

(defun sesman-table-kill-selected ()
  (interactive)
  (let* ((row (ctbl:cp-get-selected-data-row *sesman-component*))
         (system (cl-first row))
         (session (cl-third row))
         (repl (cl-second (sesman-table--selected-session))))
    (sesman-unregister system (sesman-table--selected-session))
    (sesman-quit-session system (sesman-table--selected-session))
    (kill-buffer repl)
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
        map))

(defun sesman-table-column-model ()
  (list (make-ctbl:cmodel
         :title "System"
         ;; :min-width 15
         :align 'left)
        (make-ctbl:cmodel
         :title "Session"
         ;; :min-width 20
         :align 'left)
        (make-ctbl:cmodel
         :title "Type"
         :align 'left)
        (make-ctbl:cmodel
         :title "-"
         :align 'left)))

(defun sesman-table-model ()
  (make-ctbl:model :column-model (sesman-table-column-model)
                   :data (sesman-table--data)))

(defun sesman-table-show ()
  (interactive)
  (let* ((buffer ;;(sesman-table--cider-make-popup-buffer "*sesman-connections*")
          (cider-make-popup-buffer "*sesman-connections*"))
         (component (ctbl:create-table-component-buffer
                     :buffer buffer
                     :model (sesman-table-model)
                     :custom-map (copy-keymap sesman-table-keymap))))
    (with-current-buffer buffer
      (setq *sesman-component* component)
      ;; spacemacs hack
      (mapc (lambda (k)
              (evil-local-set-key 'normal `[,(car k)] (cdr k)))
            (cdr sesman-table-keymap)))
    ;; (sesman-table--cider-popup-buffer-display buffer t)
    (cider-popup-buffer-display buffer t)
    ))

(provide 'sesman-table)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sesman-table.el ends here
