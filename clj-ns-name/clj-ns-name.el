;;; clj-ns-name.el --- Rename Clojure buffers to their namespace name  -*- lexical-binding: t; -*-

;; Filename: clj-ns-name.el
;; Author: Arne Brasseur <arne@arnebrasseur.net>
;; Maintainer: Arne Brasseur <arne@arnebrasseur.net>
;; Created: Mi Jul 18 09:18:03 2018 (+0200)
;; Version: 0.1.1
;; Package-Requires: ((emacs "24.4") (walkclj "0.1.0"))
;; Last-Updated: Mi Jul 18 09:24:11 2018 (+0200)
;;           By: Arne Brasseur
;;     Update #: 1
;; URL: https://github.com/plexus/plexmacs
;; Keywords: languages
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; Give Clojure/ClojureScript buffers the name of the Clojure namespace, rather
;; than the filename.
;;
;; Run `(clj-ns-name-install)' to add function advice to activate this package.
;;
;; Note: since walkclj is not on MELPA yet it's not being listed as a dependency
;; here, look at the plexus-clojure-extras layer to see how to ensure all
;; dependencies are there.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Copyright (C) 2018  Arne Brasseur
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

(require 'walkclj)

(defun clj-ns-name-rename-clj-buffer-to-namespace* ()
  (when (derived-mode-p 'clojure-mode)
    (let* ((ns-name (walkclj-current-ns)))
      (when (and ns-name (not (equal (buffer-name) ns-name)))
        (rename-buffer ns-name t)))))

(defun clj-ns-name-rename-clj-buffer-to-namespace (buffer)
  (with-current-buffer buffer
    (clj-ns-name-rename-clj-buffer-to-namespace*)))

(defun clj-ns-name-clojure-file-p (filename)
  (and (or (and (file-exists-p filename)
                (not (file-directory-p filename)))
           (not (file-exists-p filename)))
       (string-match "\\.clj[cxs]?$" filename)))

(defun clj-ns-name-find-file-noselect-advice (ffn-fun filename &rest args)
  (let* ((buffer (apply ffn-fun filename args)))
    (when (clj-ns-name-clojure-file-p filename)
        (clj-ns-name-rename-clj-buffer-to-namespace buffer))
    buffer))

(defun clj-ns-name-create-file-buffer-advice (cfb-fun filename &rest args)
  (if (and (file-exists-p filename) (clj-ns-name-clojure-file-p filename))
      (let* ((ns-name (with-temp-buffer
                        (insert-file-contents filename)
                        (walkclj-current-ns))))
        (if (and ns-name (not (equal (buffer-name) ns-name)))
            (progn
              (generate-new-buffer ns-name)
              ns-name)
          (apply cfb-fun filename args)))
    (apply cfb-fun filename args)))

(defun clj-ns-name-install ()
  (advice-add 'find-file-noselect :around #'clj-ns-name-find-file-noselect-advice)
  (advice-add 'create-file-buffer :around #'clj-ns-name-create-file-buffer-advice)
  (add-hook 'after-save-hook #'clj-ns-name-rename-clj-buffer-to-namespace*))

(defun clj-ns-name-uninstall ()
  (advice-remove 'rename-buffer #'clj-ns-name-rename-buffer-advice)
  (advice-remove 'find-file-noselect #'clj-ns-name-find-file-noselect-advice)
  (advice-remove 'create-file-buffer #'clj-ns-name-create-file-buffer-advice)
  (remove-hook 'after-save-hook #'clj-ns-name-rename-clj-buffer-to-namespace*))

(provide 'clj-ns-name)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; clj-ns-name.el ends here
