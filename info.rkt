#lang info
(define collection "raco-watcher")
(define deps '("base" "file-watchers"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/raco-watcher.scrbl" ())))
(define pkg-desc "This package exposes functionality of file-watcher to allow polling re-running of commands upon file change")
(define version "0.0")
(define pkg-authors '(Hank Lin))
(define license '(Apache-2.0 OR MIT))
(define raco-commands
  '(("watcher" (submod raco-watcher/main main) "watcher with evaluating command" #f)))
