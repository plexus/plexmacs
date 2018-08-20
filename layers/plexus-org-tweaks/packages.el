(defconst plexus-org-tweaks-packages '(org
                                       ox-gfm))

(defun plexus-org-tweaks/post-init-org ()
  (spacemacs|use-package-add-hook org
    :post-config
    ;; don't sum 24 hours to a day, just total hours
    (setq org-time-clocksum-format '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))

    ;; post org-mode 9.1
    (setq org-duration-format 'h:mm)

    ;; Please no auto complete when I'm writing text
    (add-hook 'org-mode-hook
              #'spacemacs/toggle-auto-completion-off
              'append)))

(defun plexus-org-tweaks/init-ox-gfm ()
  (use-package ox-gfm))
