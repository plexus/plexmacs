(defconst lambdaisland-packages
  '(color-theme-sanityinc-tomorrow
    centered-cursor-mode))

(defun lambdaisland/init-centered-cursor-mode ()
  (use-package centered-cursor-mode :ensure t))

(defun lambdaisland/init-color-theme-sanityinc-tomorrow ()
  (use-package color-theme-sanityinc-tomorrow
    :config
    (setq custom-safe-themes t)
    (color-theme-sanityinc-tomorrow-night)))
