(defconst plexus-elisp-extras-packages
  '(header2
    pprint-to-buffer))

(defun plexus-elisp-extras/init-header2 ()
  (use-package header2))

(defun plexus-elisp-extras/init-pprint-to-buffer ()
  (use-package pprint-to-buffer))
