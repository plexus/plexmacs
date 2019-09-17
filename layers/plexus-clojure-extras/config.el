(setq nrepl-log-messages t)

(set-register ?k "(do (require 'kaocha.repl) (kaocha.repl/run))")
(set-register ?K "(do (require 'kaocha.repl) (kaocha.repl/run-all))")
(set-register ?r "(user/refresh)")
