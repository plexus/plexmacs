(defconst plexus-defaults-packages '(projectile
                                     auto-package-update))

(defun plexus-defaults/post-init-projectile ()
  (setq projectile-create-missing-test-files t))

(defun plexus-defaults/init-auto-package-update ()
  (use-package auto-package-update
    :ensure t
    :config
    (setq auto-package-update-delete-old-versions t)
    (setq auto-package-update-prompt-before-update t)
    (setq auto-package-update-interval 2)
    (auto-package-update-maybe)))
