(setq emybar-colors '())
(setq emybar-procs '())

(defun embybar-set (port color)
  "Set the COLOR of an emybar based on the PORT"
  (setf (cdr (assoc port emybar-colors)) color)
  (force-mode-line-update :all))

(defun emybar-filter (proc color)
  "Process filter

Listen to UDP process PROC for a given COLOR. "
  (let* ((port (cadr (process-contact proc))))
    (emybar-set port color)))

(defun emybar-add-dot (mode-line-format port)
  "Prepend the emybar dot to a modeline

Given a MODE_LINE_FORMAT and a PORT, add the dot in the current
color."
  (cons
   `(:eval
     `(:propertize " ●"
                   font-lock-face
                   (:foreground ,(map-elt emybar-colors ,port))))
   mode-line-format))

(defun emybar (port)
  "Start the emybar on a given PORT

Adds the dot to all new and existing buffers, and starts a UDP
server to listen for color updates."
  (setq-default mode-line-format
                (emybar-add-dot (default-value 'mode-line-format) port))

  (mapcar
   (lambda (buffer)
     (setf (buffer-local-value 'mode-line-format buffer)
           (emybar-add-dot (buffer-local-value 'mode-line-format buffer) port)))
   (buffer-list))

  (setq emybar-colors
        (map-insert emybar-colors port "white"))

  (setq emybar-procs
        (map-insert emybar-procs
                    port
                    (make-network-process
                     :name "emybar"
                     :type 'datagram
                     :server t
                     :family 'ipv4
                     :service port
                     :filter #'emybar-filter))))

;; (pop mode-line-format)
;; (mapcar #'delete-process (a-vals emybar-procs))
