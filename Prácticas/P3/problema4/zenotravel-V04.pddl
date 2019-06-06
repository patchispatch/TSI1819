(define (domain zeno-travel)


(:requirements
  :typing
  :fluents
  :derived-predicates
  :negative-preconditions
  :universal-preconditions
  :disjuntive-preconditions
  :conditional-effects
  :htn-expansion

  ; Requisitos adicionales para el manejo del tiempo
  :durative-actions
  :metatags
)

(:types aircraft person city - object)
(:constants slow fast - object)
(:predicates (at ?x - (either person aircraft) ?c - city)
             (in ?p - person ?a - aircraft)
             (different ?x ?y) (igual ?x ?y)
             (hay-fuel ?a ?c1 ?c2)
             (quiere-viajar ?p - person)
             (en-avion ?a - aircraft ?p - person)
             (destino ?p - person ?c - city)
             )
(:functions (fuel ?a - aircraft)
            (distance ?c1 - city ?c2 - city)
            (slow-speed ?a - aircraft)
            (fast-speed ?a - aircraft)
            (slow-burn ?a - aircraft)
            (fast-burn ?a - aircraft)
            (capacity ?a - aircraft)
            (max-passengers ?a - aircraft)
            (passengers ?a - aircraft)
            (refuel-rate ?a - aircraft)
            (total-fuel-used)
            (fuel-limit)
            (boarding-time)
            (debarking-time)
            )

;; el consecuente "vacío" se representa como "()" y significa "siempre verdad"
(:derived
    (igual ?x ?x) ())

(:derived 
    (different ?x ?y) (not (igual ?x ?y)))

(:derived
    (destino ?p ?c)

(:derived
    (quiere-viajar ?p) (and (at ?p ?c) (not(destino ?p ?c)))
)


;; este literal derivado se utiliza para deducir, a partir de la información en el estado actual, 
;; si hay fuel suficiente para que el avión ?a vuele de la ciudad ?c1 a la ?c2
;; el antecedente de este literal derivado comprueba si el fuel actual de ?a es mayor que 1. 
;; En este caso es una forma de describir que no hay restricciones de fuel. Pueden introducirse una
;; restricción más copleja  si en lugar de 1 se representa una expresión más elaborada (esto es objeto de
;; los siguientes ejercicios).
(:derived   
  (hay-fuel ?a - aircraft ?c1 - city ?c2 - city)
  (> (fuel ?a) 1)
)

(:derived 
    (destino ?p ?c)
    (transport-person ?p ?c)
)

(:task mover-avion
    :parameters (?a - aircraft ?c1 - city ?c2 - city)
    (:method NoNecesitaRepostar
        :precondition 
            (hay-fuel ?a ?c1 ?c2)
        
        :tasks (
            (volar ?a ?c1 ?c2)
        )
    )

    (:method NecesitaRepostar
        :precondition
            (not(hay-fuel ?a ?c1 ?c2))
        
        :tasks (
            (refuel ?a ?c1)
            (volar ?a ?c1 ?c2)
        )
    )
)

(:task volar
    :parameters (?a - aircraft ?c1 - city ?c2 - city)
    
    (:method Rapido
        :precondition
            (>= 
                (- (fuel-limit) (total-fuel-used)) 
                (* (distance ?c1 ?c2) (fast-burn ?a))
            )

        :tasks (
            (zoom ?a ?c1 ?c2)
        )
    )

    (:method Lento
        :precondition
            (>= 
                (- (fuel-limit) (total-fuel-used)) 
                (* (distance ?c1 ?c2) (slow-burn ?a))
            )

        :tasks (
            (fly ?a ?c1 ?c2)
        )
    )
)

(:task embarcar
    :parameters (?a - aircraft ?c - city)

    (:method PasajerosListos
        :precondition (and
            (not(at ?p - person ?c))
            (at ?a ?c)
        )

        :tasks (
            (viajar ?a)
        )
    )

    (:method HayGenteEnCiudad
        :precondition (and
            (at ?p - person ?c)
            (at ?a ?c)
            (quiere-viajar ?p)
        )

        :tasks (
            (board ?p ?a ?c)
            (not(at ?p ?c))
            (en-avion ?p ?a)
            (embarcar ?a ?c)
        )
    )
)

(:tasks viajar
    :parameters (?a - aircraft)

    (:method NadieQuiereViajar
        :precondition (and
            (not(quiere-viajar ?p - person))
        )

        :tasks 
            ()
    )

    (:method NoHayPasajeros
        :precondition (and
            (at ?a ?ca)
            (quiere-viajar ?p - person)
            (not (en-avion ?p ?a))
            (destino ?p ?c - city)
            (different ?ca ?c)
        )

        :tasks (
            (mover-avion ?a ?ca ?c)
            (embarcar)
        )
    )

    (:method HayPasajeros
        :precondition (and
            (en-avion ?p - person ?a)
            (destino ?p ?c)
            (at ?a ?c2)
            (different ?c ?c2)
        )

        :tasks (
            (mover-avion ?a ?c ?c2)
            (desembarcar)
        )
    )
)



(:import "Primitivas-Zenotravel.pddl") 
)
