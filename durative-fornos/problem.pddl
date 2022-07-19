(define
  (problem fundicao)
  (:domain fusao)

  (:objects
    f1 - forno
    p1 p2 - panela)

  (:init
    (f-available f1)
    (p-available p1)
    (p-available p2)

    (= (f-metal f1) 0)
    (= (f-capacidade f1) 10)

    (= (p-metal p1) 0)
    (= (p-capacidade p1) 2.5)
    (= (p-metal p2) 0)
    (= (p-capacidade p2) 2.5)

    (= (taxa-fusao f1) 4.67)
  )

  (:goal (and
    (>= (f-metal f1) 15)
    (>= (p-metal p1) 2)
    (>= (p-metal p2) 2)
    )
  )
)
