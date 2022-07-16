(define (domain jugs)

    (:requirements :strips :typing :fluents :equality)

    (:types jug)

    (:functions
        (capacity ?jug - jug)
        (actual_vol ?jug - jug)
    )

    (:action empty
      :parameters
        (?j - jug)
      :precondition
        (> (actual_vol ?j) 0)
      :effect (and
          (assign (actual_vol ?j) 0)
      )
    )

    (:action fill
      :parameters
        (?j - jug)
      :precondition
        (< (actual_vol ?j) (capacity ?j))
      :effect (and
        (assign (actual_vol ?j) (capacity ?j))
      )
    )

    (:action pouron-fill
      :parameters
        (?j1 - jug
         ?j2 - jug)
      :precondition (and
        (not (= ?j1 ?j2))
        (> (actual_vol ?j1) 0)
        (< (actual_vol ?j2) (capacity ?j2))
        (> (actual_vol ?j1) (-(capacity ?j2) (actual_vol ?j2)))
      )
      :effect (and
        (decrease (actual_vol ?j1) (-(capacity ?j2) (actual_vol ?j2)))
        (assign (actual_vol ?j2) (capacity ?j2))
      )
    )

    (:action pouron-empty
      :parameters
        (?j1 - jug
         ?j2 - jug)
      :precondition (and
        (not (= ?j1 ?j2))
        (> (actual_vol ?j1) 0)
        (< (actual_vol ?j2) (capacity ?j2))
        (<= (actual_vol ?j1) (-(capacity ?j2) (actual_vol ?j2)))
      )
      :effect (and
        (increase (actual_vol ?j2) (actual_vol ?j1))
        (assign (actual_vol ?j1) 0)
      )
    )

)
