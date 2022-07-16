(define
  ;Problem
  (problem jars)
  (:domain jugs)

  (:objects
    j1 j2 - jug)

  (:init
    (= (actual_vol j1) 0)
    (= (actual_vol j2) 0)

    (= (capacity j1) 1)
    (= (capacity j2) 4)
  )

  (:goal (and
    (= (actual_vol j1) 1)
    (= (actual_vol j2) 2)
    )
  )
)
