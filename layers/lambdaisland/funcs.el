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
    (:propertize " 🎥 " font-lock-face (:background ,(if plexus/record-video "green" "black") :foreground "white"))
    (:propertize " 🔊 " font-lock-face (:background ,(if plexus/record-audio "red" "black") :foreground "white"))
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
  (setq frame-resize-pixelwise t)
  (set-frame-width (selected-frame) 1265 nil t)
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

(defun plexus/screencast-mode ()
  (interactive)
  (plexus/minimal-decorations)
  (blink-cursor-mode 0)
  (setq indicate-empty-lines nil)
  (set-frame-parameter nil 'left-fringe 18)
  (spacemacs/toggle-vi-tilde-fringe-off)
  (centered-cursor-mode)
  (git-gutter+-in-all-buffers (git-gutter+-turn-off))
  (when global-git-gutter+-mode
    (global-git-gutter+-mode))
  ;;(when highlight-parentheses-mode
  ;;  (highlight-parentheses-mode))
  ;;(when show-paren-mode
  ;;  (show-paren-mode))
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
