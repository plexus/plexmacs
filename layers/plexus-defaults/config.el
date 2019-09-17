(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; Undo spacemacs's "Improvements"
(define-key global-map (kbd "C-x 1") 'delete-other-windows)
(define-key global-map (kbd "C-r") 'isearch-backward)

;; prevent emacs performance completely tanking in the case of a lot of line-wrapping output
(setq-default bidi-display-reordering nil)



;; TODO: give this a better home
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fix annoying vertical window splitting.
;; https://emacs.stackexchange.com/questions/39034/prefer-vertical-splits-over-horizontal-ones
;; https://lists.gnu.org/archive/html/help-gnu-emacs/2015-08/msg00339.html

(with-eval-after-load "window"
  (fmakunbound #'split-window-sensibly)

  (defun split-window-sensibly (&optional window)
    (setq window (or window (selected-window)))
    (or (and (window-splittable-p window t)
             ;; Split window horizontally.
             (split-window window nil 'right))
        (and (window-splittable-p window)
             ;; Split window vertically.
             (split-window window nil 'below))
        (and (eq window (frame-root-window (window-frame window)))
             (not (window-minibuffer-p window))
             ;; If WINDOW is the only window on its frame and is not the
             ;; minibuffer window, try to split it horizontally disregarding the
             ;; value of `split-width-threshold'.
             (let ((split-width-threshold 0))
               (when (window-splittable-p window t)
                 (split-window window nil 'right)))))))

(setq-default split-height-threshold  4
              split-width-threshold   160) ; the reasonable limit for horizontal splits
