(defconst plexus-editing-packages
  '(string-edit
    smartparens
    multiple-cursors))

(defun plexus-editing/init-string-edit ()
  (use-package string-edit))

(defun plexus-editing/init-multiple-cursors ()
  (use-package multiple-cursors
    :config
    (global-set-key (kbd "C->") #'mc/mark-next-like-this)))

(defun plexus-editing/post-init-smartparens ()
  (define-key evil-normal-state-map ">" 'sp-forward-slurp-sexp)
  (define-key evil-normal-state-map "<" 'sp-forward-barf-sexp))
