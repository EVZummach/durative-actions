(define (domain fusao)

    (:requirements :strips :typing :fluents :equality :durative-actions)

    (:types forno panela)

    (:predicates
      (f-available ?f - forno)
      (p-available ?p - panela)
    )

    (:functions
        (taxa-fusao ?f - forno)
        (f-capacidade ?f - forno)
        (f-metal ?f - forno)

        (p-capacidade ?p - panela)
        (p-metal ?p - panela)
    )

    (:durative-action fundir
      :parameters
       (?f - forno)

      :duration
        (= ?duration 1)

      :condition (and
        (at start (f-available ?f))
      )

      :effect (and
        (at start (not (f-available ?f)))
        (at end (f-available ?f))
        ;(increase (f-metal ?f) (* 2 #t))
        (at end (increase (f-metal ?f) (taxa-fusao ?f)))
      )
    )

    (:durative-action vazar
      :parameters
       (?f - forno
        ?p - panela)

      :duration
        (= ?duration 10)

      :condition (and
        (at start (f-available ?f))
        (at start (p-available ?p))
        (at start (>= (f-metal ?f) (p-capacidade ?p)))
      )

      :effect (and
        (at start (not (f-available ?f)))
        (at end (f-available ?f))
        (at start (not (p-available ?p)))
        (at end (p-available ?p))
        ;(increase (quantidade-metal ?f) (* 2 #t))
        (at end (decrease (f-metal ?f) (p-capacidade ?p)))
        (at end (increase (p-metal ?p) (p-capacidade ?p)))
      )
    )
)
