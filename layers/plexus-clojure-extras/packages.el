(when (not (seq-some (lambda (a) (equal (car a) "plexmacs")) package-archives))
  (add-to-list 'package-archives
               '("plexmacs" .
                 "https://plexus.github.io/plexmacs-elpa/packages/")
               t))

(defconst plexus-clojure-extras-packages
  '(clj-ns-name
    clojure-mode
    sesman-table
    cider
    html-to-hiccup))

(defun plexus-clojure-extras-around-cider-find-file (cider-find-file-fn url)
  (let ((result (funcall cider-find-file-fn url)))
    ;;(clj-ns-name-rename-clj-buffer-to-namespace*)
    result))

(defun plexus-clojure-extras/init-clj-ns-name ()
  (use-package clj-ns-name
    :config
    (clj-ns-name-install)
    (setq helm-buffer-max-length 40)

    (advice-add 'cider-find-file :around #'plexus-clojure-extras-around-cider-find-file)
    ))

(defun plexus-clojure-extras/init-sesman-table ()
  (use-package sesman-table))

(defun plexus-clojure-extras/post-init-clojure-mode ()
  ;; Make sure evil doesn't shadow `q' in CIDER popup buffers
  (add-hook 'cider-popup-buffer-mode-hook
            (lambda ()
              (evil-local-set-key 'normal "q" 'cider-popup-buffer-quit-function)))

  (setq cider-repl-pop-to-buffer-on-connect nil)
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode))

(defun plexus-clojure-extras/post-init-cider ()
  (dolist (m '(clojure-mode
               clojurec-mode
               clojurescript-mode
               clojurex-mode
               cider-repl-mode
               cider-clojure-interaction-mode))

    (spacemacs/set-leader-keys-for-major-mode m
      "ep" 'cider-pprint-eval-last-sexp
      "eP" 'cider-pprint-eval-last-sexp-to-comment)))

(defun plexus-clojure-extras/init-html-to-hiccup ()
  (use-package html-to-hiccup))
