(when (not (seq-some (lambda (a)
                       (equal (car a) "plexmacs"))
                     package-archives))
  (add-to-list 'package-archives '("plexmacs" . "https://plexus.github.io/plexmacs-elpa/packages") t))

(defconst plexus-clojure-extras-packages
  '(parseclj
    clj-ns-name
    clojure-mode
    smartparens))

(defun plexus-clojure-extras/init-clj-ns-name ()
  (use-package clj-ns-name
    :config
    (clj-ns-name-install)))

(defun plexus-clojure-extras/post-init-clojure-mode ()
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode))

(defun plexus-clojure-extras/post-init-smartparens ()
  (define-key evil-normal-state-map ">" 'sp-forward-slurp-sexp)
  (define-key evil-normal-state-map "<" 'sp-forward-barf-sexp))
