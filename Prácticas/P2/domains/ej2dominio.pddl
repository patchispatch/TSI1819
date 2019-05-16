; *****************************************************************************
; TÉCNICAS DE LOS SISTEMAS INTELIGENTES
; Práctica 2 - Planificación clásica en PDDL.
; Autor: Juan Ocaña Valenzuela
;
; ej1dominio.pddl
; Definición del dominio para los problemas del ejercicio 1.
; *****************************************************************************

(define (domain e2-domain)
  ; Requisitos:
  (:requirements
    :strips
    :equality
    :typing
  )

  ; Tipos:
  (:types
    object character - locatable  ; Tiene posición
    player npc - character        ; Tipos de personaje
    Bruja Principe Princesa Profesor Leonardo - npc
    orientation                   ; Orientación
    terrain                       ; Tipo de terreno
    room                          ; Zona del dominio
  )

  ; Predicados:
  (:predicates
    (at ?r - room ?l - locatable)           ; Habitación en la que se encuentra un locatable
    (on_floor ?o - object)                  ; Objeto se encuentra en el suelo

    (on_hand ?o - object)                   ; Objeto se encuentra en las manos del jugador
    (has_object ?c - character)             ; El personaje tiene un objeto

    (compass ?o - orientation)              ; Orientación del jugador

    (path ?r1 ?r2 - room ?o - orientation)  ; Hay un camino entre r1 y r2 con orientación o
  )

  ; Funciones:
  (:functions
    (total_cost)                ; Coste total del plan calculado.
    (distance ?r1 ?r2 - room)   ; Distancia entre dos zonas.
  )

  ; Acciones:
  ; Coger un objeto:
  (:action PICK
    :parameters (?p - player ?o - object ?r - room)
    :precondition (AND
      (on_floor ?o)         ; El objeto está en el suelo
      (at ?r ?p)            ; El jugador está en la sala r
      (at ?r ?o)            ; El objeto está en la sala r
      (NOT(has_object ?p))  ; El jugador no tiene ningún objeto
    )

    :effect (AND
      (has_object ?p)       ; El jugador tiene un objeto
      (on_hand ?o)
      (NOT(at ?r ?o))       ; El objeto ya no está en la sala
      (NOT(on_floor ?o))    ; El objeto ya no está en el suelo
    )
  )

  ; Dejar un objeto en el suelo:
  (:action DROP
    :parameters (?p - player ?o - object ?r - room)
    :precondition (AND
      (has_object ?p)       ; El jugador tiene un objeto
      (on_hand ?o)
      (at ?r ?p)            ; El jugador está en una sala
    )

    :effect (AND
      (NOT(has_object ?p))  ; El jugador ya no tiene un objeto
      (NOT(on_hand ?o))
      (at ?r ?o)            ; El objeto está en la sala
      (on_floor ?o)         ; El objeto está en el suelo
    )
  )

  ; Darle un objeto a un personaje:
  (:action GIVE
    :parameters (?p - player ?o - object ?r - room ?n - npc)
    :precondition (AND
      (at ?r ?p)            ; El NPC está en la sala r
      (at ?r ?n)            ; El NPC está en la sala r
      (has_object ?p)       ; El jugador tiene un objeto
      (on_hand ?o)          ; El jugador tiene el objeto en la mano
      (NOT(has_object ?n))  ; El NPC no tiene un objeto
    )

    :effect (AND
      (not(has_object ?p))  ; El jugador ya no tiene un objeto
      (not(on_hand ?o))
      (has_object ?n)       ; El NPC tiene un objeto
    )
  )

  ; Moverse a la casilla enfrente del jugador:
  (:action GO
    :parameters (?p - player ?r1 ?r2 - room ?o - orientation)
    :precondition (AND
      (at ?r1 ?p)
      (path ?r1 ?r2 ?o)
      (compass ?o)
    )

    :effect (AND
      (not(at ?r1 ?p))
      (at ?r2 ?p)
      (increase (total_cost)(distance ?r1 ?r2))
    )
  )

  ; Girar 180 grados:
  (:action TURN_180
    :parameters (?o - orientation)
    :precondition (AND (compass ?o))
    :effect (AND
      (WHEN (= ?o n)
        (AND
          (compass s)
          (NOT(compass n))
        )
      )
      (WHEN (= ?o e)
        (AND
          (compass w)
          (NOT(compass e))
        )
      )
      (WHEN (= ?o s)
        (AND
          (compass n)
          (NOT(compass s))
        )
      )
      (WHEN (= ?o w)
        (AND
          (compass e)
          (NOT(compass w))
        )
      )
    )
  )

  ; Girar a la izquierda:
  (:action TURN_LEFT
    :parameters (?o - orientation)
    :precondition (AND
      (compass ?o)
    )

    :effect (AND
      (WHEN (= ?o n)
        (AND
          (compass w)
          (NOT(compass n))
        )
      )
      (WHEN (= ?o e)
        (AND
          (compass n)
          (NOT(compass e))
        )
      )
      (WHEN (= ?o s)
        (AND
          (compass e)
          (NOT(compass s))
        )
      )
      (WHEN (= ?o w)
        (AND
          (compass s)
          (NOT(compass w))
        )
      )
    )
  )

  ; Girar a la izquierda:
  (:action TURN_RIGHT
    :parameters (?o - orientation)
    :precondition (AND
      (compass ?o)
    )

    :effect (AND
      (WHEN (= ?o n)
        (AND
          (compass e)
          (NOT(compass n))
        )
      )
      (WHEN (= ?o e)
        (AND
          (compass s)
          (NOT(compass e))
        )
      )
      (WHEN (= ?o s)
        (AND
          (compass w)
          (NOT(compass s))
        )
      )
      (WHEN (= ?o w)
        (AND
          (compass n)
          (NOT(compass w))
        )
      )
    )
  )
)
