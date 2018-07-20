(when (not (seq-some (lambda (a) (equal (car a) "plexmacs")) package-archives))
  (add-to-list 'package-archives
               '("plexmacs" .
                 "https://plexus.github.io/plexmacs-elpa/packages/")
               t))

(defconst plexus-clojure-extras-packages
  '(clj-ns-name
    clojure-mode
    sesman-table))

(defun plexus-clojure-extras/init-clj-ns-name ()
  (use-package clj-ns-name
    :config
    (clj-ns-name-install)
    (setq helm-buffer-max-length 40)))

(defun plexus-clojure-extras/init-sesman-table ()
  (use-package sesman-table))

(defun plexus-clojure-extras/post-init-clojure-mode ()
  ;; Make sure evil doesn't shadow `q' in CIDER popup buffers
  (evil-make-intercept-map cider-popup-buffer-mode-map 'normal)

  (add-hook 'clojure-mode-hook #'aggressive-indent-mode))

(macroexpand-1 '
 (evil-define-key 'normal cider-popup-buffer-mode-map
   "q" 'cider-popup-buffer-quit-function))
