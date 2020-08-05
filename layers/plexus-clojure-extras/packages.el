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

  (add-hook 'clojure-mode-hook #'aggressive-indent-mode)

  (require 'clojure-mode)

  (setq clojure-toplevel-inside-comment-form t)

  (define-clojure-indent
    (DELETE 2)
    (GET 2)
    (POST 2)
    (PUT 2)
    (assoc 0)
    (async nil)
    (at 1)
    (await 1)
    (case-of 2)
    (catch-pg-key-error 1)
    (context 2)
    (defplugin '(1 :form (1)))
    (element 2)
    (ex-info 0)
    (filter-routes 1)
    (handle-pg-key-error 2)
    (js/React.createElement 2)
    (match 1)
    (promise 1)
    (prop/for-all 1)
    (s/fdef 1)))

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
      "ll" 'sesman-link-with-least-specific
      "ss" (if (eq m 'cider-repl-mode)
               'cider-switch-to-last-clojure-buffer
             'cider-switch-to-repl-buffer)
      "'"  'cider-jack-in-clj
      "\"" 'cider-jack-in-cljs
      "\&" 'cider-jack-in-clj&cljs
      "sq" 'cider-quit
      ))

  (require 'cider)

  (setq cider-redirect-server-output-to-repl t)
  (setq cider-repl-display-help-banner nil)
  (setq cider-repl-pop-to-buffer-on-connect nil)

  (require 'clj-refactor)

  (setq cljr-cljc-clojure-test-declaration "[clojure.test :refer [deftest testing is are use-fixtures run-tests join-fixtures]]")
  (setq cljr-cljs-clojure-test-declaration "[clojure.test :refer [deftest testing is are use-fixtures run-tests join-fixtures]]")
  (setq cljr-clojure-test-declaration "[clojure.test :refer [deftest testing is are use-fixtures run-tests join-fixtures]]")
  (setq cljr-eagerly-build-asts-on-startup nil)
  (setq cljr-warn-on-eval nil)

  (put 'cider-jack-in-lein-plugins 'safe-local-variable #'listp)
  (put 'cider-latest-middleware-version 'safe-local-variable #'stringp)

  (defun cljr--add-test-declarations ()
    (save-excursion
      (let* ((ns (clojure-find-ns))
             (source-ns (cljr--find-source-ns-of-test-ns ns (buffer-file-name))))
        (cljr--insert-in-ns ":require")

        ;; This bit is different, pick an alias based on the ns name
        (when source-ns
          (insert "[" source-ns " :as " (replace-regexp-in-string ".*\\." "" source-ns) "]"))

        (cljr--insert-in-ns ":require")
        (insert (cond
                 ((cljr--project-depends-on-p "midje")
                  cljr-midje-test-declaration)
                 ((cljr--project-depends-on-p "expectations")
                  cljr-expectations-test-declaration)
                 ((cljr--cljs-file-p)
                  cljr-cljs-clojure-test-declaration)
                 ((cljr--cljc-file-p)
                  cljr-cljc-clojure-test-declaration)
                 (t cljr-clojure-test-declaration))))
      (indent-region (point-min) (point-max))))

  ;; automatically reuse cider repl buffers without prompting
  ;; Thanks @kommen
  (defadvice cider--choose-reusable-repl-buffer (around auto-confirm compile activate)
    (cl-letf (((symbol-function 'y-or-n-p) (lambda (&rest args) t))
              ((symbol-function 'completing-read) (lambda (prompt collection &rest args) (car collection))))
      ad-do-it)))

(defun plexus-clojure-extras/init-html-to-hiccup ()
  (use-package html-to-hiccup))
