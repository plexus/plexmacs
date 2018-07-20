(defconst plexus-defaults-packages '(org
                                     projectile))

(defun plexus-defaults/post-init-org ()
  ;; don't sum 24 hours to a day, just total hours
  (setq org-time-clocksum-format '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))

  ;; post org-mode 9.1
  (setq org-duration-format 'h:mm))

(defun plexus-defaults/post-init-projectile ()
  (setq projectile-create-missing-test-files t))
