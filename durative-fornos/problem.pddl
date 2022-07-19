(define
  (problem fundicao)
  (:domain fusao)

  (:objects
    f1 f2 - forno)

  (:init
    (empty f1)
    (empty f2)

    (= (quantidade-metal f1) 0)
    (= (capacidade-forno f1) 10)
    (= (tempo-fusao f1) 10)

    (= (quantidade-metal f2) 0)
    (= (capacidade-forno f2) 20)
    (= (tempo-fusao f2) 20)
  )

  (:goal (and
    (>= (quantidade-metal f1) 10)
    (>= (quantidade-metal f2) 5)
    )
  )
)
