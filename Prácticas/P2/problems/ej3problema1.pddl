; *****************************************************************************
; TÉCNICAS DE LOS SISTEMAS INTELIGENTES
; Práctica 2 - Planificación clásica en PDDL.
; Autor: Juan Ocaña Valenzuela
;
; ej2problema1.pddl
; Problema 1 para el dominio 2: encontrar un plan con un coste menor a 100.
; *****************************************************************************
(define (problem belkan-e3p1)

  (:domain e3-domain)

  (:objects
    r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13
    r14 r15 r16 r17 r18 r19 r20 r21 r22 r23 r24 r25 - room
    leonardo prince witch professor princess - npc
    oscar gold apple rose algorithm shoes bikini - object
    lake cliff forest sand rock - terrain
    n e w s - orientation
    patrick - player
  )

  (:INIT
    ; ---------------------------------------------
    ; Habitaciones:
    (path r1 r2 e) (= (distance r1 r2) 2)
    (path r1 r6 s) (= (distance r1 r6) 1)
    (room_type r1 lake)

    (path r2 r1 w) (= (distance r2 r1) 2)
    (path r2 r7 s) (= (distance r2 r7) 5)
    (room_type r2 sand)

    (path r3 r4 e) (= (distance r3 r4) 5)
    (room_type r3 forest)

    (path r4 r3 w) (= (distance r4 r3) 5)
    (path r4 r9 s) (= (distance r4 r9) 3)
    (room_type r4 forest)

    (path r5 r10 s) (= (distance r5 r10) 3)
    (room_type r5 cliff)

    (path r6 r1 n) (= (distance r6 r1) 1)
    (path r6 r7 e) (= (distance r6 r7) 3)
    (room_type r6 cliff)

    (path r7 r6 w) (= (distance r7 r6) 3)
    (path r7 r12 s) (= (distance r7 r12) 1)
    (path r7 r2 n) (= (distance r7 r2) 5)
    (room_type r7 sand)

    (path r8 r9 e) (= (distance r8 r9) 4)
    (path r8 r13 s) (= (distance r8 r13) 1)
    (room_type r8 sand)

    (path r9 r8 w) (= (distance r9 r8) 4)
    (path r9 r4 n) (= (distance r9 r4) 3)
    (path r9 r10 e) (= (distance r9 r10) 2)
    (room_type r9 rock)

    (path r10 r9 w) (= (distance r10 r9) 2)
    (path r10 r5 n) (= (distance r10 r5) 3)
    (room_type r10 sand)

    (path r11 r16 s) (= (distance r11 r16) 4)
    (path r11 r12 e) (= (distance r11 r12) 1)
    (room_type r11 lake)

    (path r12 r11 w) (= (distance r12 r11) 1)
    (path r12 r7 n) (= (distance r12 r7) 1)
    (path r12 r13 e) (= (distance r12 r13) 2)
    (room_type r12 rock)

    (path r13 r12 w) (= (distance r13 r12) 2)
    (path r13 r14 e) (= (distance r13 r14) 3)
    (path r13 r8 n) (= (distance r13 r8) 1)
    (path r13 r18 s) (= (distance r13 r18) 1)
    (room_type r13 sand)

    (path r14 r13 w) (= (distance r14 r13) 3)
    (path r14 r19 s) (= (distance r14 r19) 2)
    (room_type r14 lake)

    (path r15 r20 s) (= (distance r15 r20) 1)
    (room_type r15 lake)

    (path r16 r11 n) (= (distance r16 r11) 4)
    (path r16 r17 e) (= (distance r16 r17) 1)
    (room_type r16 sand)

    (path r17 r16 w) (= (distance r17 r16) 1)
    (path r17 r18 e) (= (distance r17 r18) 1)
    (path r17 r22 s) (= (distance r17 r22) 3)
    (room_type r17 forest)

    (path r18 r17 w) (= (distance r18 r17) 1)
    (path r18 r13 n) (= (distance r18 r13) 1)
    (room_type r18 sand)

    (path r19 r14 n) (= (distance r19 r14) 2)
    (path r19 r20 e) (= (distance r19 r20) 3)
    (path r19 r24 s) (= (distance r19 r24) 1)
    (room_type r19 lake)

    (path r20 r19 w) (= (distance r20 r19) 3)
    (path r20 r15 n) (= (distance r20 r15) 1)
    (path r20 r25 s) (= (distance r20 r25) 8)
    (room_type r20 lake)

    (path r21 r22 e) (= (distance r21 r22) 7)
    (room_type r21 cliff)

    (path r22 r21 w) (= (distance r22 r21) 7)
    (path r22 r17 n) (= (distance r22 r17) 3)
    (path r22 r23 e) (= (distance r22 r23) 6)
    (room_type r22 forest)

    (path r23 r22 w) (= (distance r23 r22) 6)
    (path r23 r24 e) (= (distance r23 r24) 2)
    (room_type r23 sand)

    (path r24 r23 w) (= (distance r24 r23) 2)
    (path r24 r19 n) (= (distance r24 r19) 1)
    (room_type r24 lake)

    (path r25 r20 n) (= (distance r25 r20) 8)
    (room_type r25 forest)

    ; -------------------------------------------
    ; Personajes:
    (at r7 leonardo)
    (at r9 prince)
    (at r11 princess)
    (at r19 professor)
    (at r22 witch)

    ; -------------------------------------------
    ; Objetos:
    (at r16 oscar) (on_floor oscar)
    (at r3 algorithm) (on_floor algorithm)
    (at r15 gold) (on_floor gold)
    (at r18 apple) (on_floor apple)
    (at r25 rose) (on_floor rose)

    (at r13 bikini) (on_floor bikini) (clothes bikini)
    (at r24 shoes) (on_floor shoes) (clothes shoes)

    ; -------------------------------------------
    ; Jugador:
    (at r13 patrick)
    (compass n)
    (hand_empty)
    (bag_empty)

    ; -------------------------------------------
    ; Estado del juego:
    (= (total_cost) 0)
  )

  (:goal
    (AND
      (has_object leonardo)
      (has_object prince)
      (has_object princess)
      (has_object professor)
      (has_object witch)
      ;(<= (total_cost) 100)
    )
  )
)
