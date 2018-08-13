

(defun plexus-next-image-overlay (&optional limit)
  (interactive)
  (when (re-search-forward "\\[\\[file:\\([^][]+\\)\\]\\(\\[\\([^][]+\\)\\]\\)?\\]" limit t)
    (setq beg (match-beginning 0)
          end (match-end 0)
          imgfile (match-string 1))
    (when (file-exists-p imgfile)
      (setq img (create-image (expand-file-name imgfile)
                              'imagemagick nil))
      (setq ov (make-overlay beg end))
      (overlay-put ov 'display img)
      (overlay-put ov 'face 'default)
      (overlay-put ov 'org-image-overlay t)
      (overlay-put ov 'modification-hooks
                   (list 'org-display-inline-remove-overlay)))))

[[file:/tmp/ep43-data-science.graphs4285278982908516847.svg]]
