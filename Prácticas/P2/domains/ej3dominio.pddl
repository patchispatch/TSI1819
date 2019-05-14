; *****************************************************************************
; TÉCNICAS DE LOS SISTEMAS INTELIGENTES
; Práctica 2 - Planificación clásica en PDDL.
; Autor: Juan Ocaña Valenzuela
;
; ej1dominio.pddl
; Definición del dominio para los problemas del ejercicio 1.
; *****************************************************************************

(define (domain e1-domain)
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
    orientation                   ; Orientación
    terrain                       ; Tipo de terreno
    room                          ; Zona del dominio
  )

  ; Predicados:
  (:predicates
    (at ?r - room ?l - locatable)           ; Habitación en la que se encuentra un locatable
    (on_floor ?o - object)                  ; Objeto se encuentra en el suelo

    (hand_empty)                            ; La mano del jugador no tiene nada
    (bag_empty)                             ; La mochila del jugador está vacía
    (on_hand ?o - object)                   ; Objeto se encuentra en las manos del jugador
    (on_bag ?o - object)                    ; Objeto se encuentra en la mochila del jugador
    (has_object ?c - character)             ; El personaje tiene un objeto

    (compass ?o - orientation)              ; Orientación del jugador

    (path ?r1 ?r2 - room ?o - orientation)  ; Hay un camino entre r1 y r2 con orientación o
    (room_type ?r - room ?t - terrain)      ; Tipo de terreno de una sala

    (has_shoes)                             ; El personaje lleva los zapatos en la mano o en la mochila
    (has_bikini)                            ; El personaje lleva el bikini en la mano o en la mochila
    (clothes ?o - object)                   ; El objeto es ropa.
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
      (hand_empty)          ; El jugador tiene la mano vacía
    )

    :effect (AND
      (has_object ?p)       ; El jugador tiene un objeto
      (on_hand ?o)          ; El jugador tiene un objeto en la mano
      (NOT(at ?r ?o))       ; El objeto ya no está en la sala
      (NOT(on_floor ?o))    ; El objeto ya no está en el suelo
      (NOT(hand_empty))     ; El jugador tiene la mano ocupada

      (WHEN (= ?o bikini)
        (has_bikini)        ; Equipamos el bikini
      )
      (WHEN (= ?o shoes)
        (has_shoes)         ; Equipamos los zapatos
      )
    )
  )

  ; Dejar un objeto en el suelo:
  (:action DROP
    :parameters (?p - player ?o - object ?r - room)
    :precondition (OR
      (AND
        (has_object ?p)               ; El jugador tiene un objeto
        (on_hand ?o)                  ; El jugador lo tiene en la mano
        (at ?r ?p)                    ; El jugador está en una sala
        (NOT(hand_empty))             ; El jugador tiene la mano ocupada
        (NOT(room_type ?r cliff))     ; La siguiente sala no es acantilado
        (NOT(room_type ?r forest))    ; La siguiente sala no es bosque
        (NOT(room_type ?r lake))      ; La siguiente sala no es lago
      )

      (AND
        (has_object ?p)          ; El jugador tiene un objeto
        (on_hand ?o)             ; El jugador lo tiene en la mano
        (at ?r ?p)               ; El jugador está en una sala
        (NOT(hand_empty))        ; El jugador tiene la mano ocupada
        (room_type ?r forest)    ; La siguiente sala es bosque
        (NOT(= ?o shoes))        ; El objeto a soltar no son los zapatos
      )

      (AND
        (has_object ?p)          ; El jugador tiene un objeto
        (on_hand ?o)             ; El jugador lo tiene en la mano
        (at ?r ?p)               ; El jugador está en una sala
        (NOT(hand_empty))        ; El jugador tiene la mano ocupada
        (room_type ?r lake)      ; La siguiente sala es lago
        (NOT(= ?o bikini))       ; El objeto a soltar no es el bikini
      )

    )



    :effect (AND
      (NOT(has_object ?p))  ; El jugador ya no tiene un objeto
      (NOT(on_hand ?o))     ; El jugador no tiene el objeto en la mano
      (at ?r ?o)            ; El objeto está en la sala
      (on_floor ?o)         ; El objeto está en el suelo
      (hand_empty)          ; El jugador tiene la mano vacía
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
      (NOT(clothes ?o))     ; El objeto no es ropa
      (NOT(has_object ?n))  ; El NPC no tiene un objeto
      (NOT(hand_empty))     ; El jugador tiene la mano ocupada
    )

    :effect (AND
      (not(has_object ?p))  ; El jugador ya no tiene un objeto
      (not(on_hand ?o))     ; El jugador no tiene el objeto en la mano
      (has_object ?n)       ; El NPC tiene un objeto
      (hand_empty)          ; El jugador tiene la mano vacía
    )
  )

  ; Moverse a la casilla enfrente del jugador:
  (:action GO
    :parameters (?p - player ?r1 ?r2 - room ?o - orientation)
    :precondition (OR
      ; Bosque:
      (AND
        (at ?r1 ?p)
        (path ?r1 ?r2 ?o)
        (compass ?o)
        (room_type ?r2 forest)
        (has_shoes)
      )

      (AND
        (at ?r1 ?p)
        (path ?r1 ?r2 ?o)
        (compass ?o)
        (room_type ?r2 lake)
        (has_bikini)
      )

      (AND
        (at ?r1 ?p)
        (path ?r1 ?r2 ?o)
        (compass ?o)
        (NOT(room_type ?r2 forest))
        (NOT(room_type ?r2 lake))
        (NOT(room_type ?r2 cliff))
      )
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

  ; Guardar un objeto en la mochila:
  (:action PUT_ON_BAG
    :parameters (?o - object)
    :precondition (AND
      (NOT(hand_empty))
      (on_hand ?o)
      (bag_empty)
    )

    :effect (AND
      (NOT(bag_empty))
      (on_bag ?o)
      (NOT(on_hand ?o))
      (hand_empty)
    )
  )

  ; Sacar un objeto de la mochila:
  (:action GET_OF_BAG
    :parameters (?o - object)
    :precondition (AND
      (hand_empty)
      (NOT(bag_empty))
      (on_bag ?o)
    )

    :effect (AND
      (NOT(hand_empty))
      (on_hand ?o)
      (bag_empty)
      (NOT(on_bag ?o))
    )
  )
)
