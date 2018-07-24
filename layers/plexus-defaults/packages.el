(defconst plexus-defaults-packages '(projectile))

(defun plexus-defaults/post-init-projectile ()
  (setq projectile-create-missing-test-files t))
