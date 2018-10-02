(defun plexus-clojure-extras/around-cider-find-file (cider-find-file-fn url)
  (let ((result (funcall cider-find-file-fn url)))
    ;;(clj-ns-name-rename-clj-buffer-to-namespace*)
    result))
