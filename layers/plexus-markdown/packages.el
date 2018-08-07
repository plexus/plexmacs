(defconst plexus-markdown-packages '(markdown
                                     edit-indirect))

(defun plexus-markdown/post-init-markdown ()
  (add-hook 'markdown-mode-hook
            (lambda ()
              (interactive)
              (company-mode -1))
            'append))

(defun plexus-markdown/init-edit-indirect ()
  (use-package edit-indirect))
