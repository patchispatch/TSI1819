; *****************************************************************************
; TÉCNICAS DE LOS SISTEMAS INTELIGENTES
; Práctica 2 - Planificación clásica en PDDL.
; Autor: Juan Ocaña Valenzuela
;
; ej1dominio.PDDL
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
    room                          ; Zona del dominio
  )

  ; Predicados:
  (:predicates
    (at ?r - room ?l - locatable)           ; Habitación en la que se encuentra un locatable
    (on_floor ?o - object)                  ; Objeto se encuentra en el suelo
    (compass ?o - orientation)              ; Orientación del jugador
    (path ?r1 ?r2 - room ?o - orientation)  ; Hay un camino entre r1 y r2 con orientación o
    (has_object ?c - character)             ; El personaje tiene un objeto
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
      (NOT(at ?r ?o))       ; El objeto ya no está en la sala
      (NOT(on_floor ?o))    ; El objeto ya no está en el suelo
    )
  )

  (:action DROP
    :parameters (?p - player ?o - object ?r - room)
    :precondition (AND
      (has_object ?p)       ; El jugador tiene un objeto
      (at ?r ?p)            ; El jugador está en una sala
    )

    :effect (AND
      (NOT(has_object ?p))  ; El jugador ya no tiene un objeto
      (at ?r ?o)            ; El objeto está en la sala
      (on_floor ?o)         ; El objeto está en el suelo
    )

  )



)
