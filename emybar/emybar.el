;;; emybar.el --- -*- lexical-binding: t; -*-

;; Filename: emybar.el
;; Author: Arne Brasseur <arne@arnebrasseur.net>
;; Maintainer: Arne Brasseur <arne@arnebrasseur.net>
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Copyright (C) 2019  Arne Brasseur
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

(setq emybar-colors '())
(setq emybar-procs '())

(defun embybar-set (port color)
  "Set the COLOR of an emybar based on the PORT"
  (setf (cdr (assoc port emybar-colors)) color)
  (force-mode-line-update :all))

;; TODO: question, exclamation, quit
(defun emybar-filter (proc color)
  "Process filter

Listen to UDP process PROC for a given COLOR. "
  (let* ((port (cadr (process-contact proc))))
    (emybar-set port color)))

(defun emybar-add-dot (mode-line-format port)
  "Prepend the emybar dot to a modeline

Given a MODE_LINE_FORMAT and a PORT, add the dot in the current
color."
  (cons
   `(:eval
     `(:propertize " ●"
                   font-lock-face
                   (:foreground ,(map-elt emybar-colors ,port))))
   mode-line-format))

(defun emybar (port)
  "Start the emybar on a given PORT

Adds the dot to all new and existing buffers, and starts a UDP
server to listen for color updates."
  (setq-default mode-line-format
                (emybar-add-dot (default-value 'mode-line-format) port))

  (mapcar
   (lambda (buffer)
     (setf (buffer-local-value 'mode-line-format buffer)
           (emybar-add-dot (buffer-local-value 'mode-line-format buffer) port)))
   (buffer-list))

  (setq emybar-colors
        (map-insert emybar-colors port "white"))

  (setq emybar-procs
        (map-insert emybar-procs
                    port
                    (make-network-process
                     :name "emybar"
                     :type 'datagram
                     :server t
                     :family 'ipv4
                     :service port
                     :filter #'emybar-filter))))

;; (pop mode-line-format)
;; (mapcar #'delete-process (a-vals emybar-procs))

(provide 'emybar)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; emybar.el ends here
