(defvar plexus-cucumber/edit-indirect-left-margin 0)

(defun plexus-cucumber/compute-left-margin (code)
  "Compute left margin of a string of code."
  (let ((lines (seq-remove 's-blank-str? (s-lines code))))
    (when lines
      (cl-reduce #'min
                 (mapcar (lambda (line)
                           (save-match-data
                             (if (string-match "^\\s-+" line)
                                 (cadr (match-data))
                               0)))
                         lines)))))

(defun plexus-cucumber/after-indirect-edit-restore-left-margin ()
  "Restore left-margin before commiting."
  (aggressive-indent-mode -1)
  (indent-rigidly (point-min) (point-max) plexus-cucumber/edit-indirect-left-margin))

(defun plexus-cucumber/edit-indirect ()
  (interactive)
  (save-excursion
    (re-search-backward "\n +\"\"\"")
    (re-search-forward "\n +")
    (let ((indent (current-column)))
      (re-search-forward "\"\"\" *")
      (let ((lang (thing-at-point 'symbol))
            (md-buffer (current-buffer)))
        (forward-line)
        (let ((begin (point)))
          (re-search-forward "^ *\"\"\"")
          (forward-line -1)
          (end-of-line)
          (let* ((end (point))
                 (edit-indirect-guess-mode-function
                  (lambda (_parent-buffer _beg _end)
                    (if lang
                        (funcall (intern (concat lang "-mode")))
                      (fundamental-mode))))
                 (buffer (edit-indirect-region begin end 'display-buffer)))
            (with-current-buffer buffer
              (let ((margin (or (plexus-cucumber/compute-left-margin (buffer-substring (point-min)
                                                                                       (point-max)))
                                indent)))
                (indent-rigidly (point-min) (point-max) (* -1 margin))
                (setq-local plexus-cucumber/edit-indirect-left-margin margin))
              (add-hook 'edit-indirect-before-commit-hook
                        #'plexus-cucumber/after-indirect-edit-restore-left-margin))))))))
