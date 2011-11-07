#lang racket

(define in-file "temp.txt")

(define (find-line nuclide filename)
  (let ([input (open-input-file filename)])
    (define (counter i)
      (let ([line (read-line input)])
        (cond [(equal? eof line) (close-input-port input)]
              [(regexp-match nuclide line) (printf "~a\t~a\n" i line)]                 
              [else (counter (+ i 1))])))
    (counter 0)))

(find-line "Xe-123" in-file)

