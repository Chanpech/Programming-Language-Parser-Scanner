#lang racket
;Q1

(define (last a L)
  (local ((define (index-help a L i n)
            (cond
              [(null? L)i] 
              [(eq?(first L)a) (index-help a (rest L) n (add1 n))]
              [else (index-help a (rest L) i (add1 n))])))
     (index-help a L -1 0))

)

;Q2

(define (wrap M)
  (cond
    [(null? M) '()]
    [else (cons (if (atom? (first M))
                   (list (first M))
                   (wrap (first M)))
                (wrap (rest M)))]))
(define (atom? x)
  (not (pair? x)))


;Q3

(define (count-parens-all L)
  (local ((define (cpa-helper L n)
  (cond
    [(null? L) (+ n 2)]
    [(list? (first L) ) (cpa-helper (rest L) (+ n 2))]
    [else (cpa-helper (rest L) n)])))
  (cpa-helper L 0))
  )

;Q4
(define (insert-right-all n o M)
    (cond
      [(null? M) M]
      [(eq? (first M) o) (cons(cons(first M) o) (insert-right-all n o M))]
      [else (cons( (first M) (insert-right-all n o M)))])
  )

;Q5
(define (invert M)
  (map (lambda (pair) (reverse pair)) M))

;Q6
(define (filter-out pred L)
  (define (filter-helper i remaining)
    (cond
      [(null? remaining) (reverse i)]
      [(pred (first remaining)) (filter-helper i (cdr remaining))]
      [else (filter-helper (cons (car remaining) i) (cdr remaining))]))

  (filter-helper '() L))

;Q7
(define (summatrices M1 M2)
  (define (add-rows row1 row2)
    (map (lambda (x y) (+ x y)) row1 row2))

  (define (sum-rows matrix1 matrix2)
    (if (null? matrix1)
        '()
        (cons (add-rows (car matrix1) (car matrix2))
              (sum-rows (cdr matrix1) (cdr matrix2)))))

  (sum-rows M1 M2))

;Q8
(define (swapper a1 a2 M)
  (map (lambda(e)
    (cond
      [(equal? e a1) a2]
      [(equal? e a2) a1]
      [else e]))
       M))


;Q9
(define (flatten lst)
  (cond
    ((null? lst) '())            
    ((not (pair? (car lst)))      
     (cons (car lst) (flatten (cdr lst))))
    (else                           
     (append (flatten (car lst))     
             (flatten (cdr lst))))))  

;Q10 Didn't quite understand
#;
(define (binary-tree-insert T n)
  (cond
    ((null? T)
     '() n '())
    ((< n (cdr T))
     (list (binary-tree-insert (car T) n) (cdr T) (cdr (cdr(T)))))
    ((> n (cdr T))
     (list (car T) (cdr T) (binary-tree-insert (cdr(T) n))))
     (else T)))
;Gave up on this one
     

;Q11
#;
(define (abstraction a1 b1 M)
  (cond
    [(null? M) b1]
    [(not (pair? (car M))) (a1 (car M) (abstraction a1 b1 (cdr M)))]
    [else (cons (abstraction a1 b1 (car M))
                (abstraction a1 b1 (cdr M)))]))
#;   (define (rember* a M)
     (abstraction (lambda (e L)
                    (if (eq? a e) L (cons e L))) '() M))
#;   (define (depth M)
     (abstraction (lambda (e L)
                  (max (...)))))
        
;Partially work with some of my tests
;Was not able to get depth to work