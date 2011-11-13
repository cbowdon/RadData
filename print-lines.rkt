#lang racket

(define in-file "temp.txt")

(define (find-line nuclide filename)
  (let ([input (open-input-file filename)])
    (define (counter i)
      (let ([line (read-line input)])
        (cond [(equal? eof line) 
               (close-input-port input)]
              [(regexp-match nuclide line) 
               (begin
                 (printf "~a\t~a\n" i line)
                 (close-input-port input))]                 
              [else (counter (+ i 1))])))
    (counter 0)))


(define (nuclides-count match-term filename)
  (let ([input (open-input-file filename)])
    (define (counter i)
      (let ([line (read-line input)])
        (cond [(equal? eof line) 
               (begin
                 (printf "~a\t~a\n" i match-term)
                 (close-input-port input))]
              [(regexp-match match-term line) 
               (counter (+ i 1))]                 
              [else (counter i)])))
    (counter 0)))


(find-line "Ac-227" in-file)

(nuclides-count "B" in-file)
