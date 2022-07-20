(define
  (problem sequencia)
  (:domain fundicao)

  (:objects
    modelo1 modelo2 - modelo
    cap - vazamento
    moldagem - linha)

  (:init
    (= (l-empurrada moldagem) 6)

    (v-available cap)
    (v-operating cap)
    (= (v-enchimento cap) 280) ; 16800 kg por hora - 280 kg por min
    (= (v-metal cap) 0)
    (= (v-taxa cap) 9) ; 9kg/s

    (produzindo modelo1)
    (= (setup modelo1) 180)
    (= (qtde modelo1) 0)
    (= (peso modelo1) 100)
    (= (produzido modelo1) 0)

    (= (setup modelo2) 120)
    (= (qtde modelo2) 0)
    (= (peso modelo2) 150)
    (= (produzido modelo2) 0)
  )

  (:goal (and
    (>= (produzido modelo1) 20)
    (>= (produzido modelo2) 18)
    )
  )

  (:metric
    minimize(custo_tempo)
  )
)
