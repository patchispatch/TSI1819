; *****************************************************************************
; TÉCNICAS DE LOS SISTEMAS INTELIGENTES
; Práctica 2 - Planificación clásica en PDDL.
; Autor: Juan Ocaña Valenzuela
;
; ej1problema1.pddl
; Definición del dominio para los problemas del ejercicio 1.
; *****************************************************************************
(define (problem belkan-e1p1)

  (:domain e1-domain)

  (:objects
    r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13
    r14 r15 r16 r17 r18 r19 r20 r21 r22 r23 r24 r25 - room
    leonardo prince witch professor princess - npc
    oscar gold apple rose algorithm - object
    n e w s - orientation
    patrick - player
  )

  (:INIT
    ; ---------------------------------------------
    ; Habitaciones:
    (path r1 r2 e)
    (path r1 r6 s)

    (path r2 r1 w)
    (path r2 r7 s)

    (path r3 r4 e)

    (path r4 r3 w)
    (path r4 r9 s)

    (path r5 r10 s)

    (path r6 r1 n)
    (path r6 r7 e)

    (path r7 r6 w)
    (path r7 r12 s)
    (path r7 r2 n)

    (path r8 r9 e)
    (path r8 r13 s)

    (path r9 r8 w)
    (path r9 r4 n)
    (path r9 r10 e)

    (path r10 r9 w)
    (path r10 r5 n)

    (path r11 r16 s)
    (path r11 r12 e)

    (path r12 r11 w)
    (path r12 r7 n)
    (path r12 r13 e)

    (path r13 r12 w)
    (path r13 r14 e)
    (path r13 r8 n)
    (path r13 r18 s)

    (path r14 r13 w)
    (path r14 r19 s)

    (path r15 r20 s)

    (path r16 r11 n)
    (path r16 r17 e)

    (path r17 r16 w)
    (path r17 r18 e)
    (path r17 r22 s)

    (path r18 r17 w)
    (path r18 r13 n)

    (path r19 r14 n)
    (path r19 r20 e)
    (path r19 r24 s)

    (path r20 r19 w)
    (path r20 r15 n)
    (path r20 r25 s)

    (path r21 r22 e)

    (path r22 r21 w)
    (path r22 r17 n)
    (path r22 r23 e)

    (path r23 r22 w)
    (path r23 r24 e)

    (path r24 r23 w)
    (path r24 r19 n)

    (path r25 r20 n)

    ; -------------------------------------------
    ; Personajes:
    (at r7 leonardo)
    (at r9 prince)
    (at r11 princess)
    (at r19 professor)
    (at r22 witch)

    ; -------------------------------------------
    ; Objetos:
    (at r1 oscar) (on_floor oscar)
    (at r3 algorithm) (on_floor algorithm)
    (at r15 gold) (on_floor gold)
    (at r18 apple) (on_floor apple)
    (at r25 rose) (on_floor rose)

    ; -------------------------------------------
    ; Jugador:
    (at r13 patrick)
    (compass n)
  )

  (:goal
    (AND
      (has_object leonardo)
      (has_object prince)
      (has_object princess)
      (has_object professor)
      (has_object witch)
    )
  )
)
