(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; Undo spacemacs's "Improvements"
(define-key global-map (kbd "C-x 1") 'delete-other-windows)
(define-key global-map (kbd "C-r") 'isearch-backward)

;; prevent emacs performance completely tanking in the case of a lot of line-wrapping output
(setq-default bidi-display-reordering nil)
