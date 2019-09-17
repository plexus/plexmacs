(defun plexus/enable-recording-modeline ()
  (interactive)
  (add-to-list #'mode-line-format '(:eval (plexus/recording-modeline))))

(defun plexus/set-record-counter (i)
  (setq plexus/record-counter (number-to-string i))
  (force-mode-line-update t))

(defun plexus/recording-modeline ()
  `((:propertize " ⚫ " font-lock-face (:foreground ,(case plexus/record-state
                                                       ('recording "red")
                                                       (t "gray"))
                                                    :background "black"))
    ;;(:propertize " 🎥 " font-lock-face (:background ,(if plexus/record-video "green" "black") :foreground "white"))
    ;;(:propertize " 🔊 " font-lock-face (:background ,(if plexus/record-audio "red" "black") :foreground "white"))
    (:propertize " V " font-lock-face (:background ,(if plexus/record-video "green" "black") :foreground "white"))
    (:propertize " A " font-lock-face (:background ,(if plexus/record-audio "red" "black") :foreground "white"))
    (:propertize " " font-lock-face (:background "white" :foreground "black"))
    (:propertize (:eval plexus/record-counter) font-lock-face (:background "white" :foreground "black"))
    (:propertize " " font-lock-face (:background "white" :foreground "black"))
    (:propertize (:eval (if plexus/record-clipped "---CLIPPED---")) font-lock-face (:background "red" :foreground "white"))
    " "))

(defun plexus/lambdaisland-recording-setup ()
  (interactive)
  (set-frame-font "Inconsolata-17" t
                  (list (make-frame '((name . "islandmacs"))))))

(defun plexus/resize-for-lambda-island ()
  (interactive)
  (setq frame-resize-pixelwise t)
  ;; while true; do xdotool getactivewindow ; sleep 1; done
  ;; watch "xwininfo -id 12583570 | egrep '(Width|Height)'"
  (set-frame-width (selected-frame) 1262 nil t)
  (set-frame-height (selected-frame) 720 nil t))

(defun plexus/ffmpeg-position ()
  (let* ((f (frame-position))
         (x (car f))
         (y (cdr f)))
    ;; these offsets have been carefully, experimentally verified. They
    ;; compensate for the drop shadow and title bar that is somehow considered
    ;; part of the frame
    (format "%d,%d" (mod (+ x 10) 1920) (+ y 35))))


(defun plexus/minimal-decorations ()
  (interactive)
  (when (and (boundp 'linum-mode) linum-mode)
    (linum-mode))
  (setq mode-line-format '("%e"
                           mode-line-front-space
                           mode-line-frame-identification
                           mode-line-buffer-identification
                           "   "
                           mode-line-position)))

;; also disable blinking in gnome-terminal:
;; gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$(gsettings get org.gnome.Terminal.ProfilesList default|tr -d \')/ cursor-blink-mode off
(defun plexus/screencast-mode ()
  (interactive)
  (plexus/minimal-decorations)
  (set-frame-parameter nil 'left-fringe 10)
  (spacemacs/toggle-vi-tilde-fringe-off)
  (centered-cursor-mode)

  (setq cider-use-fringe-indicators nil)
  (setq dotspacemacs-highlight-delimiters nil)
  (setq indicate-empty-lines nil)
  (setq ccm-vpos-init 19)

  (blink-cursor-mode -1)
  (global-git-gutter+-mode -1)
  ;;(git-gutter+-in-all-buffers (git-gutter+-turn-off))
  (highlight-parentheses-mode -1)
  (show-paren-mode -1)
  (show-smartparens-mode -1)
  (which-key-mode -1)
  (company-mode -1)

  (remove-hook 'before-save-hook #'delete-trailing-whitespace)
  )

;;(setq mode-line-format '("%e" (:propertize "    Lambda Island | 37. Transducers" font-lock-face (:foreground "#b294bb"))))

(defun lambdaisland/export-guides ()
  (interactive)
  (with-current-buffer (find-file-noselect "/home/arne/github/lambdaisland-guides/repls.org")
    (org-html-export-to-html)
    (org-latex-export-to-pdf)
    (shell-command-to-string "ebook-convert /home/arne/github/lambdaisland-guides/repls.html /home/arne/github/lambdaisland-guides/repls.mobi")
    (shell-command-to-string "ebook-convert /home/arne/github/lambdaisland-guides/repls.html /home/arne/github/lambdaisland-guides/repls.epub")
    (shell-command-to-string "cp /home/arne/github/lambdaisland-guides/repls.{html,pdf,epub,mobi} /home/arne/LambdaIsland/App/resources/guides"))

  (with-current-buffer (find-file-noselect "/home/arne/github/lambdaisland-docs/lambdaisland-docs.org")
    (org-html-export-to-html)
    (org-latex-export-to-pdf)
    (shell-command-to-string "ebook-convert /home/arne/github/lambdaisland-docs/lambdaisland-docs.html /home/arne/github/lambdaisland-docs/lambdaisland-docs.mobi")
    (shell-command-to-string "ebook-convert /home/arne/github/lambdaisland-docs/lambdaisland-docs.html /home/arne/github/lambdaisland-docs/lambdaisland-docs.epub")
    (shell-command-to-string "cp /home/arne/github/lambdaisland-docs/lambdaisland-docs.{html,pdf,epub,mobi} /home/arne/LambdaIsland/App/resources/guides")))
