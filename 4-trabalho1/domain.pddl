(define (domain fundicao)

    (:requirements :strips :typing :fluents :equality :durative-actions)

    (:types modelo vazamento linha)

    (:predicates
      (produzindo ?m - modelo)
      (v-available ?v - vazamento)
      (v-operating ?v - vazamento)
    )

    (:functions
        (l-empurrada ?l - linha)

        (v-metal ?v - vazamento)
        (v-taxa ?v - vazamento)
        (v-enchimento ?v - vazamento)
        (v-capacidade ?v - vazamento)

        (setup ?m - modelo)
        (qtde ?m - modelo)
        (peso ?m - modelo)

        (produzido ?m - modelo)

        (custo_tempo)
    )

    (:durative-action produzir
      :parameters
       (?m - modelo
        ?v - vazamento
        ?l - linha)

      :duration
        (= ?duration (+ (/ (peso ?m) (v-taxa ?v)) (l-empurrada ?l)))

      :condition (and
        (at start (>= (v-metal ?v) (peso ?m)))
        (at start (v-operating ?v))
        (over all (produzindo ?m))
        (at end (produzindo ?m))
      )

      :effect (and
        (at start (not (v-operating ?v)))
        (at end (v-operating ?v))
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
        (at start (produzindo ?m_f))
      )

      :effect (and
        (at start (not (v-operating ?v)))
        (at end (v-operating ?v))

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
        ;(at end (increase (custo_tempo) 3600))
      )
    )

)
