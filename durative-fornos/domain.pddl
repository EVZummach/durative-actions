(define (domain fusao)

    (:requirements :strips :typing :fluents :equality :durative-actions)

    (:types forno)

    (:predicates
      (operating ?f - forno)
      (pronto ?f - forno)
      (empty ?f - forno)
    )

    (:functions
        (tempo-fusao ?f - forno)
        (capacidade-forno ?f - forno)
        (quantidade-metal ?f - forno)
    )

    (:durative-action fundir
      :parameters
       (?f - forno)

      :duration
        (= ?duration (tempo-fusao ?f))

      :condition (and
        (at start (empty ?f))
      )

      :effect (and
        (increase (quantidade-metal ?f) (* 2 #t))
        (at start (not (empty ?f)))
        (at end (pronto ?f))
        ;(at end (increase (quantidade-metal ?f) (capacidade-forno ?f)))
      )
    )
)
