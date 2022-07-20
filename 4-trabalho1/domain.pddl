(define (domain fundicao)

    (:requirements :strips :typing :fluents :equality :durative-actions)

    (:types modelo vazamento linha)

    (:predicates
      (produzindo ?m - modelo)

      (v-available ?v - vazamento)
      (v-not-occupied ?v - vazamento)

      (l-parada ?l - linha)
      (l-pronta ?l - linha)
      (l-empurrar ?l - linha)
    )

    (:functions
        (l-empurrada ?l - linha)

        (v-metal ?v - vazamento)
        (v-taxa ?v - vazamento)
        (v-enchimento ?v - vazamento)
        (v-capacidade ?v - vazamento)

        (setup ?m - modelo)
        (peso ?m - modelo)

        (produzido ?m - modelo)

        (custo_tempo)
    )

    (:durative-action empurrar
      :parameters
      (?l - linha)

      :duration
        (= ?duration (l-empurrada ?l))

      :condition(and
        (at start (l-empurrar ?l))
        (at start (l-parada ?l))
      )

      :effect (and
        (at end (not (l-empurrar ?l)))
        (at start (not (l-parada ?l)))
        (at end (l-parada ?l))
        (at end (l-pronta ?l))
      )

     )


    (:durative-action produzir
      :parameters
       (?m - modelo
        ?v - vazamento
        ?l - linha)

      :duration
        (= ?duration (/ (peso ?m) (v-taxa ?v)))

      :condition (and
        (at start (>= (v-metal ?v) (peso ?m)))
        (at start (v-not-occupied ?v))
        (over all (produzindo ?m))
        (at end (produzindo ?m))

        (at start (l-pronta ?l))
        (over all (l-parada ?l))
        (at end (l-parada ?l))
      )

      :effect (and
        (at end (not (l-pronta ?l)))
        (at end (l-empurrar ?l))
        (at start (not (v-not-occupied ?v)))
        (at end (v-not-occupied ?v))

        (at end (increase (produzido ?m) 1))
        (at end (decrease (v-metal ?v) (peso ?m)))
        (at end (increase (custo_tempo) (+ (/ (peso ?m) (v-taxa ?v)) (l-empurrada ?l))))
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
      )
    )

    (:durative-action fundir
      :parameters
       (?v - vazamento)

      :duration
        (= ?duration 60)

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
