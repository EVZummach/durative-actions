(define
  (problem sequencia)
  (:domain fundicao)

  (:objects
    modelo1 modelo2 modelo3 modelo4 modelo5 modelo6 modelo7 - modelo
    A B C D E F G H I J - qtde-prod
    cap1 cap2 - vazamento
    moldagem - linha)

  (:init
    (= (l-empurrada moldagem) 6)

    (= (qtde-producao A) 1)
    (= (qtde-producao B) 2)
    (= (qtde-producao C) 5)
    (= (qtde-producao D) 10)
    (= (qtde-producao E) 15)
    (= (qtde-producao F) 20)
    (= (qtde-producao G) 25)
    (= (qtde-producao H) 30)
    (= (qtde-producao I) 50)
    (= (qtde-producao J) 100)

    (l-parada moldagem)
    (l-empurrar moldagem)

    (v-available cap1)
    (v-not-occupied cap1)
    (= (v-enchimento cap1) 1400) ; 16800 kg por hora - 280 kg por min
    (= (v-abastecimento cap1) 300)
    (= (v-metal cap1) 0)
    (= (v-taxa cap1) 9) ; kg/s

    ;(v-available cap2)
    ;(v-not-occupied cap2)
    ;(= (v-enchimento cap2) 200) ; 16800 kg por hora - 280 kg por min
    ;(= (v-metal cap2) 0)
    ;(= (v-taxa cap2) 9) ; kg/s

    (= (setup modelo1) 60) ; segundos
    (= (peso modelo1) 90) ; kg
    (= (produzido modelo1) 0)

    (= (setup modelo2) 83) ; segundos
    (= (peso modelo2) 130) ; kg
    (= (produzido modelo2) 0)

    (= (setup modelo3) 54) ; segundos
    (= (peso modelo3) 83) ; kg
    (= (produzido modelo3) 0)

    (= (setup modelo4) 45) ; segundos
    (= (peso modelo4) 163) ; kg
    (= (produzido modelo4) 0)

    (= (setup modelo5) 72) ; segundos
    (= (peso modelo5) 113) ; kg
    (= (produzido modelo5) 0)

    (= (setup modelo6) 90) ; segundos
    (= (peso modelo6) 50) ; kg
    (= (produzido modelo6) 0)

    (= (setup modelo7) 83) ; segundos
    (= (peso modelo7) 93) ; kg
    (= (produzido modelo7) 0)

    (produzindo modelo1)
  )

  (:goal (and
    (>= (produzido modelo1) 100)
    (>= (produzido modelo2) 150)
    (>= (produzido modelo3) 50)
    (>= (produzido modelo4) 10)
    (>= (produzido modelo5) 200)
    (>= (produzido modelo6) 100)
    ;(>= (produzido modelo7) 80)
    )
  )

  (:metric
    minimize(custo_tempo)
  )
)
