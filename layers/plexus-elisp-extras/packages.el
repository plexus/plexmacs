(defconst plexus-elisp-extras-packages
  '(header2
    pprint-to-buffer))

(defun plexus-elisp-extras/init-header2 ()
  (use-package header2))

(defun plexus-elisp-extras/init-pprint-to-buffer ()
  (use-package pprint-to-buffer
    :config
    (define-key emacs-lisp-mode-map (kbd "C-c C-p") 'pprint-to-buffer-last-sexp)
    (spacemacs/set-leader-keys-for-major-mode 'emacs-lisp-mode
      "ep" 'pprint-to-buffer-last-sexp
      "eP" (lambda () (interactive) (pprint-to-buffer-last-sexp t)))

    )



  (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode))
