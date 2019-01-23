(defconst plexus-cucumber-packages
  '(feature-mode
    edit-indirect
    s))

(defun plexus-cucumber/init-feature-mode ()
  (use-package feature-mode
    :config
    (make-variable-buffer-local 'edit-indirect-after-creation-hook)
    (make-variable-buffer-local 'edit-indirect-before-commit-hook)

    (define-key feature-mode-map (kbd "C-c '") 'plexus-cucumber/edit-indirect)))

(defun plexus-cucumber/init-edit-indirect ()
  (use-package edit-indirect))

(defun plexus-cucumber/init-s ()
  (use-package s))
