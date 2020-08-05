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
  (require 'evil-cleverparens)
  (require 'evil-cleverparens-text-objects)

  (define-key evil-normal-state-map ">" 'sp-forward-slurp-sexp)
  (define-key evil-normal-state-map "<" 'sp-forward-barf-sexp)
  (define-key evil-normal-state-map (kbd "C->") 'sp-backward-barf-sexp)
  (define-key evil-normal-state-map (kbd "C-<") 'sp-backward-slurp-sexp)

  (define-key evil-motion-state-map "H" 'evil-cp-backward-sexp)
  (define-key evil-motion-state-map "L" 'evil-cp-forward-sexp)
  )
