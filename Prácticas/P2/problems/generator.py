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
    # Variables:
    num_zones = 0
    problem_name = ""
    domain_name = ""
    map_elements = defaultdict(list())
    v_rel = list()
    h_rel = list()

    # Ruta del archivo a leer y escribir:
    p1 = sys.argv[1]
    p2 = sys.argv[2]

    # Abrir archivo:
    with open(p1, "r") as file:
        lines = file.readlines()

    # Eliminar líneas en blanco:
    lines = filter(lambda x: x.strip(), lines)

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
        line.pop(0)
        line.pop(0)     # Quitar la flecha de los cojones

        for i in line:
            e = i.replace("]", "[").split("[")
            rel.append(e[0])

            if e[1] is not "":
                obj = e[1].split("-")
                map_elements[obj[1]] = obj[0]

        for i in rel[:-1]:
            pair = (i, i.next())

            if mode is "v":
                v_rel.append(pair)
            else:
                h_rel.append(pair)

        rel.clear()

    # Escribir:
    file = open(p2, "w+")

    # Nombre del problema:
    file.write("(define (problem {} \n\n".format(problem_name))

    # Nombre del dominio:
    file.write("(:domain {}) \n\n".format(domain_name))

    # Elementos del mapa:
    file.write("(:objects")

    stringo = ""
    for type, value in map_elements.items():
        for v in value:
            stringo +=  str(v) + " "

        stringo += "- " + str(type) + "\n"
        file.write(stringo)
        stringo.clear()
