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
  oscar gold apple rose book - object
  n e w s - orientation
  patrick - player
)

(:INIT
  ; ---------------------------------------------
  ; Habitaciones:
  (path r1 r2)
  (path r1 r6)

  (path r2 r1)
  (path r2 r7)

  (path r3 r4)

  (path r4 r3)
  (path r4 r9)

  (path r5 r10)

  (path r6 r1)
  (path r6 r7)

  (path r7 r6)
  (path r7 r2)

  (path r8 r9)
  (path r8 r13)

  (path r9 r8)
  (path r9 r4)
  (path r9 r10)

  (path r10 r9)
  (path r10 r5)

  (path r11 r16)
  (path r11 r12)

  (path r12 r11)
  (path r12 r7)
  (path r12 r13)

  (path r13 r12)
  (path r13 r14)
  (path r13 r8)
  (path r13 r18)

  (path r14 r13)
  (path r14 r19)

  (path r15 r20)

  (path r16 r11)
  (path r16 r17)

  (path r17 r16)
  (path r17 r18)
  (path r17 r22)

  (path r18 r17)
  (path r18 r13)

  (path r19 r14)
  (path r19 r20)
  (path r19 r24)

  (path r20 r19)
  (path r20 r15)
  (path r20 r25)

  (path r21 r22)

  (path r22 r21)
  (path r22 r17)
  (path r22 r23)

  (path r23 r22)
  (path r23 r24)

  (path r24 r23)
  (path r24 r19)

  (path r25 r20)
)

(:goal (AND (ON D C) (ON C B) (ON B A)))
)
