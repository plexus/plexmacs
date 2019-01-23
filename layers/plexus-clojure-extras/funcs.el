(defun plexus-clojure-extras/around-cider-find-file (cider-find-file-fn url)
  (let ((result (funcall cider-find-file-fn url)))
    ;;(clj-ns-name-rename-clj-buffer-to-namespace*)
    result))

(defun plexus-clojure-extras/cider-pprint-register (register)
  (interactive (list (register-read-with-preview "Eval register: ")))
  (cider--pprint-eval-form (get-register register)))
