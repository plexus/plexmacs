(defconst plexus-clojure-extras-packages
  '((parseclj :location (recipe
                         :fetcher github
                         :repo "clojure-emacs/parseclj"
                         :files ("*.el")))

    (treepy :location (recipe
                       :fetcher github
                       :repo "volrath/treepy.el"
                       :files ("*.el")))

    (walkclj :location (recipe
                       :fetcher github
                       :repo "plexus/walkclj"
                       :files ("*.el")))

    (clj-ns-name :location (recipe
                            :fetcher github
                            :repo "plexus/plexmacs"
                            :files ("clj-ns-name/*")))

    ;; aggressive-indent         ; provided by spacemacs-editing
    ))

(defun plexus-clojure-extras/init-parseclj ())
(defun plexus-clojure-extras/init-treepy ())
(defun plexus-clojure-extras/init-walkclj ())

(defun plexus-clojure-extras/init-clj-ns-name ()
  (use-package clj-ns-name
    :config
    (clj-ns-name-install)))

(defun plexus-clojure-extras/post-init-clojure-mode ()
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode))