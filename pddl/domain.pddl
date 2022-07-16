(define (domain mail)

    (:requirements :strips :typing :fluents :equality :durative-actions)

    (:types mailman city)

    (:predicates
      (at ?mailman - mailman ?city - city)
      (neighbor ?city1 - city1 ?city2 - city)
      (stopped-at ?mailman - mailman ?city - city)
    )

    (:functions
        (distancia ?city1 - city ?city2 - city)
        (tempo ?city1 - city ?city2 - city)
        (custo_tempo)
        (custo_distancia)
    )

    (:durative-action move
      :parameters
       (?from - city
        ?to - city
        ?mailman - mailman)

      :duration
        (= ?duration (tempo ?from ?to))
        
      :condition (and
        (at start (at ?mailman ?from))
        (at start (neighbor ?from ?to))
        (at start (not (= ?from ?to)))
        )
      :effect (and
        (at end (at ?mailman ?to))
        (at end (not (at ?mailman ?from)))
        (at end (increase (custo_tempo) (tempo ?from ?to)))
        (at end (increase (custo_distancia) (distancia ?from ?to)))
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
