(define (domain mail)

    (:requirements :strips :typing :fluents :equality :durative-actions)

    (:types mailman city)

    (:predicates
      (at ?mailman - mailman ?city - city)
      (neighbor ?city1 - city ?city2 - city)
      (stopped-at ?mailman - mailman ?city - city)
    )

    (:functions
        (distancia ?from - city ?to - city)
        (tempo ?from - city ?to - city)
        (custo_tempo)
        (custo_distancia)
    )

    (:action move
      :parameters
       (?from - city
        ?to - city
        ?mailman - mailman)

      :precondition (and
        (at ?mailman ?from)
        (neighbor ?from ?to)
        (not (= ?from ?to))
      )

      :effect (and
        (at ?mailman ?to)
        (not (at ?mailman ?from))
        (increase (custo_tempo) (tempo ?from ?to))
        (increase (custo_distancia) (distancia ?from ?to))
      )
    )

    (:action stop-at
      :parameters
        (?mailman - mailman
         ?city - city)
      :precondition (and
        (at ?mailman ?city)
      )
      :effect (and
          (stopped-at ?mailman ?city)
        )
    )
)
