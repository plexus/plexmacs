(defconst plexus-editing-packages
  '(string-edit
    smartparens))

(defun plexus-editing/init-string-edit ()
  (use-package string-edit :ensure t))

(defun plexus-editing/post-init-smartparens ()
  (define-key evil-normal-state-map ">" 'sp-forward-slurp-sexp)
  (define-key evil-normal-state-map "<" 'sp-forward-barf-sexp))
