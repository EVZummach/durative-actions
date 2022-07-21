(define (domain fundicao)

    (:requirements :typing :fluents :durative-actions)

    (:types modelo qtde-prod vazamento linha)

    (:predicates
      (produzindo ?m - modelo)

      (v-available ?v - vazamento)
      (v-not-occupied ?v - vazamento)

      (l-parada ?l - linha)
      (l-pronta ?l - linha)
      (l-empurrar ?l - linha)
    )

    (:functions
        (qtde-producao ?q - qtde-prod)

        (l-empurrada ?l - linha)

        (v-metal ?v - vazamento)
        (v-taxa ?v - vazamento)
        (v-enchimento ?v - vazamento)
        (v-capacidade ?v - vazamento)
        (v-abastecimento ?v - vazamento)

        (setup ?m - modelo)
        (peso ?m - modelo)

        (produzido ?m - modelo)

        (custo_tempo)
    )

    (:action empurrar
      :parameters
      (?l - linha)

      :precondition(and
        (l-empurrar ?l)
        (l-parada ?l)
      )

      :effect (and
        (not (l-empurrar ?l))
        (not (l-parada ?l))
        (l-parada ?l)
        (l-pronta ?l)
      )
     )


    (:durative-action produzir
      :parameters
       (?m - modelo
        ?q - qtde-prod
        ?v - vazamento
        ?l - linha)

      :duration
        (= ?duration (*(+ (/ (peso ?m) (v-taxa ?v)) (l-empurrada ?l)) (qtde-producao ?q)))

      :condition (and
        (at start (>= (v-metal ?v) (* (peso ?m) (qtde-producao ?q))))
        (at start (v-not-occupied ?v))

        (at start (produzindo ?m))
        (at end (produzindo ?m))

        (at start (l-pronta ?l))
        (at end (l-parada ?l))
      )

      :effect (and
        (at end (not (l-pronta ?l)))
        (at end (l-empurrar ?l))
        (at start (not (v-not-occupied ?v)))
        (at end (v-not-occupied ?v))

        (at end (increase (produzido ?m) (qtde-producao ?q)))
        (at end (decrease (v-metal ?v) (* (peso ?m) (qtde-producao ?q))))
        (at end (increase (custo_tempo) (* (+ (/ (peso ?m) (v-taxa ?v)) (l-empurrada ?l)) (qtde-producao ?q))))
      )
    )

    (:durative-action trocar
      :parameters
       (?m_f - modelo
        ?m_t - modelo
        ?v - vazamento
        ?l - linha)

      :duration
        (= ?duration (setup ?m_t))

      :condition (and
        (at start (l-pronta ?l))
        (at start (produzindo ?m_f))
        (over all (l-parada ?l))
        (at end (l-parada ?l))
      )

      :effect (and
        (at end (l-empurrar ?l))
        (at end (not (l-pronta ?l)))

        ;(at start (not (v-not-occupied ?v)))
        ;(at end (v-not-occupied ?v))

        (at start (not (produzindo ?m_f)))
        (at end (produzindo ?m_t))
        (at end (increase (custo_tempo) (setup ?m_t)))
        ;(at end (increase (setups) 1))
      )
    )

    (:durative-action fundir
      :parameters
       (?v - vazamento)

      :duration
        (= ?duration (v-abastecimento ?v))

      :condition (and
        (at start (v-available ?v))
      )

      :effect (and
        (at start (not (v-available ?v)))
        (at end (v-available ?v))
        ;(increase (f-metal ?f) (* 2 #t)) ;Causou core dumped
        (at end (increase (v-metal ?v) (v-enchimento ?v)))
      )
    )

)
