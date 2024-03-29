(define (domain recycling_example)
(:requirements :strips :typing :durative-actions)


; Types definition
(:types
  location
  robot
  item
)

(:predicates
  (robot_at ?r - robot ?l - location)
  (item_at ?it - item ?l - location)
  (gripper_free ?r - robot)
  (robot_carry ?r - robot ?it - item)
)

; Move action. The robot moves from one location (A) to another (B).
; The only precondition is that the robot must be in the initial location.
; Consequence: The robot is now at B and not at A.
(:durative-action move
  :parameters (?r - robot ?from ?to - location)
  :duration (= ?duration 20)
  :condition
    (and 
      (at start (robot_at ?r ?from))
    )
  :effect
    (and
      (at end (robot_at ?r ?to))
      (at start (not (robot_at ?r ?from)))
    )
)

; Pick-up action. The robot picks an object at a location.
; Both the robot and the object must be in that location.
; The robot's gripper must be free.
; Consequences:
;     - The item is no longer at the given location.
;     - The robot is now carrying the object and its gripper is not free.
(:durative-action pick
  :parameters (?it - item ?l - location ?r - robot)
  :duration (= ?duration 10)
  :condition 
    (and
      (at start (item_at ?it ?l))
      (over all  (robot_at ?r ?l))
      (at start (gripper_free ?r))
    )
:effect
  (and
    (at end (robot_carry ?r ?it))
    (at start (not (item_at ?it ?l)))
    (at start (not (gripper_free ?r))))
  )

; Drop-off action. The robot drops an object at a location.
; The robot must be in that location and must be carrying that object.
; Consequences:
;     - The item is now at the given location.
;     - The robot is no longer carrying the object and its gripper is free.
(:durative-action drop
:parameters (?it - item ?l - location ?r - robot)
:duration (= ?duration 5)
:condition
  (and 
    (over all (robot_at ?r ?l))
    (at start (robot_carry ?r ?it))
  )
:effect 
  (and 
    (at end (item_at ?it ?l))
    (at end (gripper_free ?r))
    (at start (not (robot_carry ?r ?it)))
  )
)

)
