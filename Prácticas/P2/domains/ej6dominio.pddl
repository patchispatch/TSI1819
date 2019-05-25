; *****************************************************************************
; TÉCNICAS DE LOS SISTEMAS INTELIGENTES
; Práctica 2 - Planificación clásica en PDDL.
; Autor: Juan Ocaña Valenzuela
;
; ej3dominio.pddl
; Definición del dominio para los problemas del ejercicio 1.
; *****************************************************************************

(define (domain e3-domain)
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
    Bikini Zapato - object
    orientation                   ; Orientación
    terrain                       ; Tipo de terreno
    room                          ; Zona del dominio
  )

  ; Predicados:
  (:predicates
    (at ?r - room ?l - locatable)           ; Habitación en la que se encuentra un locatable
    (on_floor ?o - object)                  ; Objeto se encuentra en el suelo

    (hand_empty ?p - player)                ; La mano del jugador no tiene nada
    (bag_empty ?p - player)                 ; La mochila del jugador está vacía
    (on_hand ?o - object)                   ; Objeto se encuentra en las manos del jugador
    (on_bag ?o - object)                    ; Objeto se encuentra en la mochila del jugador
    (has_object ?c - character)             ; El personaje tiene un objeto

    (compass ?p - player ?o - orientation)  ; Orientación del jugador

    (path ?r1 ?r2 - room ?o - orientation)  ; Hay un camino entre r1 y r2 con orientación o
    (room_type ?r - room ?t - terrain)      ; Tipo de terreno de una sala

    (has_zapato ?p - player)                ; El personaje lleva los zapatos en la mano o en la mochila
    (has_bikini ?p - player)                ; El personaje lleva el bikini en la mano o en la mochila
    (clothes ?o - object)                   ; El objeto es ropa.
  )

  ; Funciones:
  (:functions
    (total_cost)                            ; Coste total del plan calculado.
    (distance ?r1 ?r2 - room)               ; Distancia entre dos zonas.
    (points_given ?ch - npc ?o - object)    ; Puntos dados por entregar el objeto o al personaje ch
    (points_earned ?p - player)             ; Puntos obtenidos por el jugador
    (total_points)                          ; Puntos totales entre los dos personajes
    (stock ?ch - npc)                       ; Bolsillos ocupados de un personaje
    (max_stock ?ch - npc)                   ; Bolsillos totales de un personaje
  )

  ; Acciones:
  ; Coger un objeto:
  (:action PICK
    :parameters (?p - player ?o - object ?r - room)
    :precondition (AND
      (on_floor ?o)         ; El objeto está en el suelo
      (at ?r ?p)            ; El jugador está en la sala r
      (at ?r ?o)            ; El objeto está en la sala r
      (hand_empty ?p)       ; El jugador tiene la mano vacía
    )

    :effect (AND
      (on_hand ?o)          ; El jugador tiene un objeto en la mano
      (NOT(at ?r ?o))       ; El objeto ya no está en la sala
      (NOT(on_floor ?o))    ; El objeto ya no está en el suelo
      (NOT(hand_empty ?p))  ; El jugador tiene la mano ocupada

      (WHEN (= ?o bikini)
        (has_bikini ?p)         ; Equipamos el bikini
      )
      (WHEN (= ?o zapato)
        (has_zapato ?p)         ; Equipamos los zapatos
      )
    )
  )

  ; Dejar un objeto en el suelo:
  (:action DROP
    :parameters (?p - player ?o - object ?r - room)
    :precondition (OR
      (AND
        (on_hand ?o)                        ; El jugador lo tiene en la mano
        (at ?r ?p)                          ; El jugador está en una sala
        (NOT(hand_empty ?p))                ; El jugador tiene la mano ocupada
        (NOT(room_type ?r Precipicio))      ; La siguiente sala no es acantilado
        (NOT(room_type ?r Bosque))          ; La siguiente sala no es bosque
        (NOT(room_type ?r Agua))            ; La siguiente sala no es lago
      )

      (AND
        (on_hand ?o)                ; El jugador lo tiene en la mano
        (at ?r ?p)                  ; El jugador está en una sala
        (NOT(hand_empty ?p))        ; El jugador tiene la mano ocupada
        (room_type ?r Bosque)       ; La siguiente sala es bosque
        (NOT(= ?o zapato))          ; El objeto a soltar no son los zapatos
      )

      (AND
        (on_hand ?o)                ; El jugador lo tiene en la mano
        (at ?r ?p)                  ; El jugador está en una sala
        (NOT(hand_empty ?p))        ; El jugador tiene la mano ocupada
        (room_type ?r Agua)         ; La siguiente sala es lago
        (NOT(= ?o bikini))          ; El objeto a soltar no es el bikini
      )

    )

    :effect (AND
      (NOT(on_hand ?o))         ; El jugador no tiene el objeto en la mano
      (at ?r ?o)                ; El objeto está en la sala
      (on_floor ?o)             ; El objeto está en el suelo
      (hand_empty ?p)           ; El jugador tiene la mano vacía

      (WHEN (= ?o bikini)
        (NOT(has_bikini ?p))
      )
      (WHEN (= ?o zapato)
        (NOT(has_zapato ?p))
      )
    )
  )

  ; Darle un objeto a un personaje:
  (:action GIVE
    :parameters (?p - player ?o - object ?r - room ?n - npc)
    :precondition (AND
      (at ?r ?p)                       ; El NPC está en la sala r
      (at ?r ?n)                       ; El NPC está en la sala r
      (on_hand ?o)                     ; El jugador tiene el objeto en la mano
      (NOT(clothes ?o))                ; El objeto no es ropa
      (< (stock ?n) (max_stock ?n))    ; El NPC tiene hueco para guardar el objeto
      (NOT(hand_empty ?p))             ; El jugador tiene la mano ocupada
    )

    :effect (AND
      (not(on_hand ?o))                                   ; El jugador no tiene el objeto en la mano
      (hand_empty ?p)                                     ; El jugador tiene la mano vacía
      (increase (stock ?n) 1)                             ; El NPC ocupa un hueco más
      (increase (points_earned ?p) (points_given ?n ?o))  ; Incrementamos los puntos por entregar el objeto al NPC
    )
  )

  ; Moverse a la casilla enfrente del jugador:
  (:action GO
    :parameters (?p - player ?r1 ?r2 - room ?o - orientation)
    :precondition (OR
      ; Otro:
      (AND
        (at ?r1 ?p)
        (path ?r1 ?r2 ?o)
        (compass ?p ?o)
        (NOT(room_type ?r2 Bosque))
        (NOT(room_type ?r2 Agua))
        (NOT(room_type ?r2 Precipicio))
      )

      ; Bosque:
      (AND
        (at ?r1 ?p)
        (path ?r1 ?r2 ?o)
        (compass ?p ?o)
        (room_type ?r2 Bosque)
        (has_zapato ?p)
      )

      ; Lago:
      (AND
        (at ?r1 ?p)
        (path ?r1 ?r2 ?o)
        (compass ?p ?o)
        (room_type ?r2 Agua)
        (has_bikini ?p)
      )
    )
    :effect (AND
      (not(at ?r1 ?p))
      (at ?r2 ?p)
      (increase (total_cost) (distance ?r1 ?r2))
    )
  )

  ; Girar 180 grados:
  (:action TURN_180
    :parameters (?p - player ?o - orientation)
    :precondition (AND (compass ?p ?o))
    :effect (AND
      (WHEN (= ?o n)
        (AND
          (compass ?p s)
          (NOT(compass ?p n))
        )
      )
      (WHEN (= ?o e)
        (AND
          (compass ?p w)
          (NOT(compass ?p e))
        )
      )
      (WHEN (= ?o s)
        (AND
          (compass ?p n)
          (NOT(compass ?p s))
        )
      )
      (WHEN (= ?o w)
        (AND
          (compass ?p e)
          (NOT(compass ?p w))
        )
      )
    )
  )

  ; Girar a la izquierda:
  (:action TURN_LEFT
    :parameters (?p - player ?o - orientation)
    :precondition (AND
      (compass ?p ?o)
    )

    :effect (AND
      (WHEN (= ?o n)
        (AND
          (compass ?p w)
          (NOT(compass ?p n))
        )
      )
      (WHEN (= ?o e)
        (AND
          (compass ?p n)
          (NOT(compass ?p e))
        )
      )
      (WHEN (= ?o s)
        (AND
          (compass ?p e)
          (NOT(compass ?p s))
        )
      )
      (WHEN (= ?o w)
        (AND
          (compass ?p s)
          (NOT(compass ?p w))
        )
      )
    )
  )

  ; Girar a la izquierda:
  (:action TURN_RIGHT
    :parameters (?p - player ?o - orientation)
    :precondition (AND
      (compass ?p ?o)
    )

    :effect (AND
      (WHEN (= ?o ?p n)
        (AND
          (compass ?p e)
          (NOT(compass ?p n))
        )
      )
      (WHEN (= ?o e)
        (AND
          (compass ?p s)
          (NOT(compass ?p e))
        )
      )
      (WHEN (= ?o s)
        (AND
          (compass ?p w)
          (NOT(compass ?p s))
        )
      )
      (WHEN (= ?o w)
        (AND
          (compass ?p n)
          (NOT(compass ?p w))
        )
      )
    )
  )

  ; Guardar un objeto en la mochila:
  (:action PUT_ON_BAG
    :parameters (?p - player ?o - object)
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
