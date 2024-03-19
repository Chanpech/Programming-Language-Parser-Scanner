#lang lazy

(define f-list
  (let f-helper ((n 0 ))
    (if (< n 3)
        (list 1 2 3)
        (let ((prev-list (f-helper (- n 1))))
          (cons (+ (* 3 (car prev-list))
                   (* 2 (car (cdr (cdr prev-list)))))
                (cdr prev-list))))))
