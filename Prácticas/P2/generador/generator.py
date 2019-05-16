# coding=utf-8
# *****************************************************************************
# TÉCNICAS DE LOS SISTEMAS INTELIGENTES
# Práctica 2 - Planificación clásica en PDDL.
# Autor: Juan Ocaña Valenzuela
#
# generator.py
# Generador de problemas dado un archivo de texto plano.
# *****************************************************************************

import sys
from collections import defaultdict



def main():
    # Personajes:
    personajes = "Princesa Principe Bruja Profesor Leonardo Player"

    # Variables:
    num_zones = 0
    problem_name = ""
    domain_name = ""
    map_elements = defaultdict(list)

    objects_place = list()
    v_rel = list()
    h_rel = list()

    # Ruta del archivo a leer y escribir:
    p1 = sys.argv[1]
    p2 = "./" + sys.argv[2]

    # Abrir archivo:
    with open(p1, "r") as file:
        lines = file.readlines()

    # Eliminar líneas en blanco:
    lines = list(filter(lambda x: x.strip(), lines))

    # Línea 1: nombre del dominio:
    v = lines[0].split(":")
    domain_name = v[1]
    lines.pop(0)

    # Línea 2: nombre del problema:
    v = lines[0].split(":")
    problem_name = v[1]
    lines.pop(0)

    # Línea 3: número de zonas:
    v = lines[0].split(":")
    num_zones = int(v[1])
    lines.pop(0)

    # Resto:
    mode = 0
    rel = list()

    for line in lines:
        v = line.split(" ")
        mode = line[0].lower()
        v.pop(0)
        v.pop(0)     # Quitar la flecha de los cojones

        for i in v:
            e = i.replace("]", "[").split("[")
            map_elements["room"].append(e[0])
            rel.append(e[0])

            if e[1] is not "":
                obj = e[1].split("-")
                map_elements[obj[1]].append(obj[0])

                if obj[1] not in personajes:
                    objeto = False
                else:
                    objeto = True

                op = (e[0], obj[0], objeto)
                objects_place.append(op)

        for i, item in enumerate(rel[:-1]):
            pair = (item, rel[i+1])

            if "v" in mode:
                v_rel.append(pair)
            else:
                h_rel.append(pair)

        rel.clear()

    # Eliminar zonas repetidas:
    map_elements["room"] = sorted(set(map_elements["room"]))

    # Escribir:
    file = open(p2, "w+")

    # Nombre del problema:
    file.write("(define (problem {})\n\n".format(problem_name))

    # Nombre del dominio:
    file.write("(:domain {})\n\n".format(domain_name))

    # Elementos del mapa:
    file.write("(:objects \n")

    stringo = ""
    for type, value in map_elements.items():
        stringo = " ".join(value) + " - " + str(type) + "\n"
        file.write(stringo)
        stringo = ""

    file.write(")\n\n")

    # Situación inicial:
    file.write("(:init\n\n")

    # Caminos:
    file.write("; Caminos:\n")

    stringo = "(path {0} {1} n) (path {1} {0} s)\n"
    for v in v_rel:
        file.write(stringo.format(v[0], v[1]))

    stringo = "(path {0} {1} e) (path {1} {0} w)\n"
    for h in h_rel:
        file.write(stringo.format(h[0], h[1]))

    # Situación de los objetos:
    file.write("\n\n; Situación del mapa:\n")

    stringo = "(at {0} {1})\n"
    stringo2 = "(on_floor {})\n"

    for p in objects_place:
        file.write(stringo.format(p[0], p[1]))

        if not p[2]:
            file.write(stringo2.format(p[1]))

        file.write("\n")

    # Orientación por defecto del jugador: norte
    file.write("\n\n; Orientación del jugador:\n(compass n)")

    # Cierre del bloque init:
    file.write("\n)")

    # Objetivos a rellenar:
    file.write("\n\n; Introduzca aquí sus objetivos:\n(:goal\n\n)")

    # Cerrar paréntesis:
    file.write("\n)")

if __name__ == "__main__":
    main()