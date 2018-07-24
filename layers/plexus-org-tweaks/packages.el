(defconst plexus-org-tweaks-packages '(org))

(defun plexus-org-tweaks/post-init-org ()
  ;; don't sum 24 hours to a day, just total hours
  (setq org-time-clocksum-format '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))

  ;; post org-mode 9.1
  (setq org-duration-format 'h:mm)

  (add-hook 'org-mode-hook
            #'spacemacs/toggle-auto-completion-off
            'append))
