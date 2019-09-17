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

(defun plexus-clojure-extras/init-clj-ns-name ()
  (use-package clj-ns-name
    :config
    (clj-ns-name-install)
    ;; (clj-ns-name-uninstall)
    (setq helm-buffer-max-length 40)

    (advice-add #'cider-find-file :around #'plexus-clojure-extras/around-cider-find-file)))

(defun plexus-clojure-extras/init-sesman-table ()
  (use-package sesman-table))

(defun plexus-clojure-extras/post-init-clojure-mode ()
  ;; Make sure evil doesn't shadow `q' in CIDER popup buffers
  (add-hook 'cider-popup-buffer-mode-hook
            (lambda ()
              (evil-local-set-key 'normal "q" 'cider-popup-buffer-quit-function)))

  (setq cider-repl-pop-to-buffer-on-connect nil)
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode)

  (require 'clojure-mode)
  (define-clojure-indent
    (match 1)
    (defplugin '(1 :form (1)))))

(defun plexus-clojure-extras/post-init-cider ()
  (dolist (m '(clojure-mode
               clojurec-mode
               clojurescript-mode
               clojurex-mode
               cider-repl-mode
               cider-clojure-interaction-mode))

    (spacemacs/set-leader-keys-for-major-mode m
      "ep" 'cider-pprint-eval-last-sexp
      "eP" 'cider-pprint-eval-last-sexp-to-comment
      "en" 'cider-eval-ns-form
      "er" 'cider-eval-last-sexp-and-replace
      ","  'plexus-clojure-extras/cider-pprint-register
      "lp" 'sesman-link-with-project
      "lb" 'sesman-link-with-buffer
      "lb" 'sesman-link-with-directory
      "ll" 'sesman-link-with-least-specific))

  ;; todo, move to a clj-refactor stanza
  (setq cljr-warn-on-eval nil)
  (setq cljr-eagerly-build-asts-on-startup nil)

  (require 'cider)

  (define-clojure-indent
    (GET 2)
    (POST 2)
    (PUT 2)
    (DELETE 2)
    (context 2)
    (case-of 2)
    (js/React.createElement 2)
    (element 2)
    (s/fdef 1)
    (filter-routes 1)
    (catch-pg-key-error 1)
    (handle-pg-key-error 2)
    (prop/for-all 1)
    (at 1)
    (promise 1)
    (await 1)
    (async 0))

  (put 'cider-jack-in-lein-plugins 'safe-local-variable
       #'listp)

  (put 'cider-latest-middleware-version 'safe-local-variable
       #'stringp)

  (require 'clj-refactor)
  ;; (setq cider-jack-in-lein-plugins
  ;;       ;; https://clojars.org/refactor-nrepl
  ;;       ;; https://clojars.org/refactor-nrepl
  ;;       '(("refactor-nrepl" "2.4.1-SNAPSHOT" :predicate cljr--inject-middleware-p)
  ;;         ;;("cider/cider-nrepl" "0.20.1-SNAPSHOT")
  ;;         ))

  ;; (defun cljr--version (&optional remove-package-version)
  ;;   "2.4.1-SNAPSHOT")

  (defcustom cider-configured-cljs-init-form
    "(throw (Exception. \"set cider-configured-cljs-init-form in .dir-locals.el\"))"
    "The form to use to initialize a CLJS repl of type 'configured"
    :type 'string
    :group 'cider
    :safe #'stringp)

  (defun plexus/cider-configured-cljs-init-form ()
    cider-configured-cljs-init-form)

  (cider-register-cljs-repl-type 'configured
                                 #'plexus/cider-configured-cljs-init-form)
  )

(defun plexus-clojure-extras/init-html-to-hiccup ()
  (use-package html-to-hiccup))
