(define (problem p3
)

(:domain e3-domain
)

(:objects
z1 z2 z3 z4 z5 z6 z7 - room
bruja1 - Bruja
player1 - Player
manzana1 - Manzana
oscar1 - Oscar
princesa1 - Princesa
bikini - Bikini
zapato - Zapato
n e w s - orientation
Bosque Agua Precipicio Arena Piedra - terrain)

(:init

(room_type z1 Bosque)
(room_type z2 Arena)
(room_type z3 Arena)
(room_type z4 Piedra)
(room_type z5 Bosque)
(room_type z6 Bosque)
(room_type z7 Agua)

; Caminos:
(path z1 z3 n) (path z3 z1 s)
(= (distance z1 z3) 10) (= (distance z3 z1) 10)

(path z3 z6 n) (path z6 z3 s)
(= (distance z3 z6) 5) (= (distance z6 z3) 5)

(path z2 z3 e) (path z3 z2 w)

(= (distance z2 z3) 10) (= (distance z3 z2) 10)

(path z3 z4 e) (path z4 z3 w)

(= (distance z3 z4) 5) (= (distance z4 z3) 5)

(path z5 z6 e) (path z6 z5 w)

(= (distance z5 z6) 10) (= (distance z6 z5) 10)

(path z6 z7 e) (path z7 z6 w)

(= (distance z6 z7) 5) (= (distance z7 z6) 5)



; Situación del mapa:
(at z1 bruja1)

(at z2 player1)

(at z4 manzana1)
(on_floor manzana1)

(at z5 oscar1)
(on_floor oscar1)

(at z7 princesa1)

(at z1 bikini)
(at z2 zapato)



; Situación inicial del jugador:
(compass n)
(hand_empty)
(bag_empty)


; Coste inicial del plan:
(= (total_cost) 0)
)

; Introduzca aquí sus objetivos:
(:goal
  (at z1 player1)
)
)
