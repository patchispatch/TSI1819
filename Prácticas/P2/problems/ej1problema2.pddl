(define (problem Problema1
)

(:domain Ejercicio1
)

(:objects
z1 z2 z3 z4 z5 z6 z7 - room
bruja1 bruja2 - Bruja
player1 - Player
manzana1 - Manzana
oscar1 - Oscar
princesa1 - Princesa

n e w s - orientation)

(:init

; Caminos:
(path z1 z3 n) (path z3 z1 s)
(path z3 z6 n) (path z6 z3 s)
(path z2 z3 e) (path z3 z2 w)
(path z3 z4 e) (path z4 z3 w)
(path z5 z6 e) (path z6 z5 w)
(path z6 z7 e) (path z7 z6 w)


; Situación del mapa:
(at z1 bruja1)

(at z3 bruja2)

(at z2 player1)

(at z4 manzana1)
(on_floor manzana1)

(at z5 oscar1)
(on_floor oscar1)

(at z7 princesa1)



; Orientación del jugador:
(compass n)
)

; Introduzca aquí sus objetivos:
(:goal
  (has_object bruja1)
)
)
