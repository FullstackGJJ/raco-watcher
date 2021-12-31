#lang racket/base

(require file-watchers)

(module+ main
  (require racket/cmdline
           racket/list
           racket/system
           raco/command-name)

  (define cmd (make-parameter "world"))
  (define path*
    (command-line
    #:program (short-program+command-name)
    #:once-each
    [("-c" "--command") c "command to run" (cmd c)]
    #:args target-path*
    (if (empty? target-path*)
        (list (current-directory))
        (map string->path target-path*))))

  (begin
    (printf "Starting robust watch")
    (with-handlers 
      ([exn:break? (lambda (e) (printf "~nStopping...~n"))])
      (thread-wait (watch path* (lambda (lst) (system (cmd)) displayln robust-watch)))
      (displayln "All watchers are done."))))

(module+ test
  (require rackunit))

(module+ test
  (check-equal? (+ 2 2) 4))
