(define
  (problem mailing)
  (:domain mail)

  (:objects
    A B E F - city
    mailman - mailman)

  (:init
    (at mailman A)

    (neighbor A B)
    (= (distancia A B) 3)
    (= (tempo A B) 2)

    (neighbor A E)
    (= (distancia A E) 5)
    (= (tempo A E) 10)

    (neighbor A F)
    (= (distancia A F) 15)
    (= (tempo A F) 5)

    (neighbor E F)
    (= (distancia E F) 5)
    (= (tempo E F) 20)


    (neighbor B A)
    (= (distancia B A) 3)
    (= (tempo B A) 2)

    (neighbor E A)
    (= (distancia E A) 5)
    (= (tempo E A) 10)

    (neighbor F A)
    (= (distancia F A) 15)
    (= (tempo F A) 5)

    (neighbor F E)
    (= (distancia F E) 5)
    (= (tempo F E) 20)

  )

  (:goal (and
    (stopped-at mailman E)
    (at mailman F)
    )
  )

  (:metric
    minimize(custo_distancia)
  )
)
