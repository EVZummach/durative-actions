(define
  (problem sequencia)
  (:domain fundicao)

  (:objects
    modelo1 modelo2 modelo3 modelo4 - modelo
    cap1 cap2 - vazamento
    moldagem - linha)

  (:init
    (= (l-empurrada moldagem) 6)

    (l-parada moldagem)
    (l-empurrar moldagem)

    (v-available cap1)
    (v-not-occupied cap1)
    (= (v-enchimento cap1) 200) ; 16800 kg por hora - 280 kg por min
    (= (v-metal cap1) 0)
    (= (v-taxa cap1) 9) ; kg/s

    ;(v-available cap2)
    ;(v-not-occupied cap2)
    ;(= (v-enchimento cap2) 200) ; 16800 kg por hora - 280 kg por min
    ;(= (v-metal cap2) 0)
    ;(= (v-taxa cap2) 9) ; kg/s

    (= (setup modelo1) 50) ; segundos
    (= (peso modelo1) 90) ; kg
    (= (produzido modelo1) 0)

    (= (setup modelo2) 30) ; segundos
    (= (peso modelo2) 130) ; kg
    (= (produzido modelo2) 0)

    (= (setup modelo3) 50) ; segundos
    (= (peso modelo3) 60) ; kg
    (= (produzido modelo3) 0)

    (= (setup modelo4) 60) ; segundos
    (= (peso modelo4) 83) ; kg
    (= (produzido modelo4) 0)

    (produzindo modelo1)
  )

  (:goal (and
    (>= (produzido modelo1) 100)
    (>= (produzido modelo2) 250)
    (>= (produzido modelo3) 300)
    (>= (produzido modelo4) 200)
    )
  )

  (:metric
    minimize(custo_tempo)
  )
)
