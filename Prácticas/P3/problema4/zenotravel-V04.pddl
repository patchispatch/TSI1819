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

(:task transport-person
	:parameters (?p - person ?c - city)
	
    (:method PersonaEnCiudadDestino ; si la persona est� en la ciudad no se hace nada
        :precondition 
            (at ?p ?c)
        
        :tasks 
            ()
    )

    ;si no está en la ciudad destino, pero avion y persona est�n en la misma ciudad 
    (:method PersonaEnCiudadAvion
        :precondition (and 
            (at ?p - person ?c1 - city)
            (at ?a - aircraft ?c1 - city)
        )

        :tasks ( 
            (board ?p ?a ?c1)
            (mover-avion ?a ?c1 ?c)
            (debark ?p ?a ?c )
        )
    )

    ; Si la persona está en una ciudad distinta, se viaja hasta allí:
    (:method PersonaEnOtraCiudad
        :precondition (and
            (at ?p - person ?cp - city) 
            (at ?a - aircraft ?ca - city)
            (different ?cp ?ca)
        )
        
        :tasks ( 
            (mover-avion ?a ?ca ?cp)
            (board ?p ?a ?cp)
            (mover-avion ?a ?cp ?c)
            (debark ?p ?a ?c)
        )
    )
)
    

(:task mover-avion
    :parameters (?a - aircraft ?c1 - city ?c2 - city)
    (:method NoNecesitaRepostar
        :precondition 
            (hay-fuel ?a ?c1 ?c2)
        
        :tasks (
            (viajar ?a ?c1 ?c2)
        )
    )

    (:method NecesitaRepostar
        :precondition
            (not(hay-fuel ?a ?c1 ?c2))
        
        :tasks (
            (refuel ?a ?c1)
            (viajar ?a ?c1 ?c2)
        )
    )
)

(:task viajar
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
    :parameters (?p - person ?a - aircraft ?c - city)

    (:method embarque
        :precondition ()

        :tasks (
            (board ?p ?a ?c)
            (embarcar)
        )
    )
    
)

(:import "Primitivas-Zenotravel.pddl") 
)
