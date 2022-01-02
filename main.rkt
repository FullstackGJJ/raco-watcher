#lang racket/base

(require (prefix-in fw: file-watchers))

(module+ main
  (require racket/format
           racket/list
           racket/string
           (prefix-in cmd: racket/cmdline)
           (prefix-in sys: racket/system)
           (prefix-in cname: raco/command-name))

  (define (format-paths paths)
    (string-join
      (map (lambda (p) (~a "-->  " p)) paths)
      (format "~n")))


  (define cmd (make-parameter "world"))
  (define paths
    (cmd:command-line
    #:program (cname:short-program+command-name)
    #:once-each
    [("-c" "--command") c "command to run" (cmd c)]
    #:args target-path*
    (if (empty? target-path*)
        (list (current-directory))
        (map string->path target-path*))))

  (define does-not-exist (filter (λ (p) (not (fw:path-on-disk? p))) paths))
  (define exists (filter fw:path-on-disk? paths))

  (when (> (length does-not-exist) 0)
    (printf
      "These paths do not exist on the system and will not be monitored:~n~a~n~n"
      (format-paths does-not-exist)))

  (if (> (length exists) 0)
    (begin
      (printf "Starting robust watch")
      (with-handlers
        ([exn:break? (lambda (e) (printf "~nStopping...~n"))])
        (thread-wait
          (fw:watch
            exists
            (lambda (lst) (sys:system (cmd)))
            displayln fw:robust-watch))
        (displayln "All watchers are done.")))
    (displayln "Nothing to watch. Exiting.")))

(module+ test
  (require rackunit))

(module+ test
  (check-equal? (+ 2 2) 4))
