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

    (:durative-action move
      :parameters
       (?from - city
        ?to - city
        ?mailman - mailman)

      :duration
        (= ?duration (tempo ?from ?to))

      :condition (and
        (at start (at ?mailman ?from))
        (over all (neighbor ?from ?to))
        (over all (not (= ?from ?to)))
      )

      :effect (and
        (at end (at ?mailman ?to))
        (at start (not (at ?mailman ?from)))
        (at end (increase (custo_tempo) (tempo ?from ?to)))
        (at end (increase (custo_distancia) (distancia ?from ?to)))
      )
    )

    (:durative-action stop-at
      :parameters
        (?mailman - mailman
         ?city - city)
      :duration
        (= ?duration 3)
      :condition (and
        (over all (at ?mailman ?city))
      )
      :effect (and
          (at end (stopped-at ?mailman ?city))
        )
    )
)
