(defconst plexus-defaults-packages '(projectile
                                     auto-package-update))

(defun plexus-defaults/post-init-projectile ()
  (setq projectile-create-missing-test-files t))
