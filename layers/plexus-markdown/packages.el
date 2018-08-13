(defconst plexus-markdown-packages '(markdown-mode
                                     edit-indirect))

(defun plexus-markdown/post-init-markdown-mode ()
  (spacemacs|use-package-add-hook markdown-mode
      :post-config
  
      (add-hook 'markdown-mode-hook
                #'spacemacs/toggle-auto-completion-off
                'append)))

(defun plexus-markdown/init-edit-indirect ()
  (use-package edit-indirect))
