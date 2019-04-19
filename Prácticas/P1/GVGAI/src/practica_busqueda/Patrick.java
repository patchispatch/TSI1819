package practica_busqueda;

import core.game.StateObservation;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.pathfinder.PathFinder;
import tools.pathfinder.Node;
import tools.Vector2d;

import java.util.ArrayList;
import java.util.ListIterator;
import java.awt.*;

import javax.swing.plaf.nimbus.State;

public class Patrick extends BaseAgent {

    // Atributos:
    PathFinder pf;
    GameState gs;

    ArrayList<Node> currentPath;
    ListIterator<Node> currentPos;
    Vector2d objective;
    Vector2d nearestPortal;
    int remainingGems;

    boolean danger;
    boolean reroute;
    boolean hasGems;

    // Constructor:
    public Patrick(StateObservation so, ElapsedCpuTimer elapsedTimer) {
        super(so, elapsedTimer);

        // Enemigos: murciélagos y escorpiones
        ArrayList<Integer> obstacles = new ArrayList();
        obstacles.add(gs.WALL);
        obstacles.add(gs.STONE);

        pf = new PathFinder(obstacles);
        gs = new GameState(so, this);

        currentPath = new ArrayList();
        remainingGems = getRemainingGems(so);

        danger = false;
        reroute = true;
        hasGems = false;
    }

    // Método act:
    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {

        // Acción a devolver:
        Types.ACTIONS action = Types.ACTIONS.ACTION_NIL;

        // Actualizar estado del juego:
        gs.update(stateObs);

        // Comprobar si estamos en peligro:
        action = checkBug();

        if (!danger) {
            // Realcular ruta si es necesario:
            if(reroute) {
                reroute(stateObs);
            }

            // Decidir qué acción tomar según la siguiente posición de la ruta:
            if(currentPos.hasNext()) {
                Node next = currentPos.next();

                action = nextMove(next.position);

                // Comprobar si nos movemos a la siguiente casilla o simplemente cambiamos de orientación:
                checkMove(action);
            }
            else {
                // Recalculamos:
                reroute = true;
            }
        }

        // Para poder apreciar mejor lo tonto que es Patrick:
        try {
            Thread.sleep(100);
        }
        catch (InterruptedException e) {}

        return action;
    }


    // Determina la siguiente acción basándose en la siguiente casilla de la ruta
    private Types.ACTIONS nextMove(Vector2d nextPos){

        Types.ACTIONS nextMove;
        Vector2d patrickPos = gs.playerPosition();

        // Comprobamos si es una gema:

        if (nextPos.x != patrickPos.x){
            if (nextPos.x > patrickPos.x) {
                System.out.println("Derecha");
                nextMove = Types.ACTIONS.ACTION_RIGHT;
            }

            else {
                System.out.println("Izquierda");
                nextMove = Types.ACTIONS.ACTION_LEFT;
            }
        }

        else if (nextPos.y != patrickPos.y){
            if(nextPos.y > patrickPos.y){
                System.out.println("Abajo");
                nextMove = Types.ACTIONS.ACTION_DOWN;
            }

            else {
                System.out.println("Arriba");
                nextMove = Types.ACTIONS.ACTION_UP;
            }
        }

        else {
            nextMove = Types.ACTIONS.ACTION_NIL;
        }

        return nextMove;
    }


    // Recalcular la ruta a seguir:
    private void reroute(StateObservation stateObs) {

        // Si quedan gemas por coger:
        remainingGems = getRemainingGems(stateObs);

        if (remainingGems != 0) {
            // Ir a la gema más cercana
            objective = gs.nearestGem();
        }
        else {
            // Ir a la puerta
            objective = gs.nearestPortal();
        }


        pf.run(stateObs);
        currentPath = pf.getPath(gs.playerPosition(), objective);

        currentPos = currentPath.listIterator();
        reroute = false;
    }


    // Comprobar si nos movemos, y si no, corregir el iterador del plan:
    void checkMove(Types.ACTIONS action) {

        Orientation ori = gs.playerOrientation();

        if ((action == Types.ACTIONS.ACTION_RIGHT && ori != Orientation.E) ||
                (action == Types.ACTIONS.ACTION_UP && ori != Orientation.N) ||
                (action == Types.ACTIONS.ACTION_LEFT && ori != Orientation.W) ||
                (action == Types.ACTIONS.ACTION_DOWN && ori != Orientation.S))
        {
            currentPos.previous();
        }
    }


    // Esquiva un bicho si lo tiene a dos casillas de distancia:
    Types.ACTIONS checkBug() {
        Vector2d pos = gs.playerPosition();
        int height = gs.mapHeight() - 1;
        int width = gs.mapWidth() - 1;

        System.out.println(width);
        System.out.println(height);

        // Valores:

        double x = pos.x;
        double y = pos.y;

        System.out.println("X: " + x);
        System.out.println("Y: " + y);


        double xPlus2 = pos.x + 2;
        if (xPlus2 > width) {xPlus2 = width;}

        double xMinus2 = pos.x - 2;
        if (xMinus2 < 0) {xMinus2 = 0;}

        double yPlus2 = pos.y + 2;
        if (yPlus2 > height) {yPlus2 = height;}

        double yMinus2 = pos.x - 2;
        if (yMinus2 < 0) {yMinus2 = 0;}

        double xPlus1 = pos.x + 1;
        double xMinus1 = pos.x - 1;
        double yPlus1 = pos.y + 1;
        double yMinus1 = pos.y - 1;


        // x + 2, y + 0
        if ((gs.get(xPlus2, y).getType() == ObservationType.SCORPION) ||
                (gs.get(xPlus2, y).getType() == ObservationType.BAT))
        {
            // Ir en dirección contraria: oeste
            danger = true;
            return Types.ACTIONS.ACTION_LEFT;
        }
        // x + 1, y + 1
        else if ((gs.get(xPlus1, yPlus1).getType() == ObservationType.SCORPION) ||
                (gs.get(xPlus1, yPlus1).getType() == ObservationType.BAT))
        {
            // Ir en dirección contraria: oeste
            danger = true;
            return Types.ACTIONS.ACTION_LEFT;
        }
        // x + 0, y + 2
        else if ((gs.get(x, yPlus2).getType() == ObservationType.SCORPION) ||
                (gs.get(x, yPlus2).getType() == ObservationType.BAT))
        {
            // Ir en dirección contraria: norte
            danger = true;
            return Types.ACTIONS.ACTION_UP;
        }
        // x - 1, y + 1
        else if ((gs.get(xMinus1, yPlus1).getType() == ObservationType.SCORPION) ||
                (gs.get(xMinus1, yPlus1).getType() == ObservationType.BAT))
        {
            // Ir en dirección contraria: norte
            danger = true;
            return Types.ACTIONS.ACTION_UP;
        }
        // x - 2, y + 0
        else if ((gs.get(xMinus2, y).getType() == ObservationType.SCORPION) ||
                (gs.get(xMinus2, y).getType() == ObservationType.BAT))
        {
            // Ir en dirección contraria: este
            danger = true;
            return Types.ACTIONS.ACTION_RIGHT;
        }
        // x - 1, y - 1
        else if ((gs.get(xMinus1, yMinus1).getType() == ObservationType.SCORPION) ||
                (gs.get(xMinus1, yMinus1).getType() == ObservationType.BAT))
        {
            // Ir en dirección contraria: este
            danger = true;
            return Types.ACTIONS.ACTION_RIGHT;
        }
        // x + 0, y - 2
        else if ((gs.get(x, yMinus2).getType() == ObservationType.SCORPION) ||
                (gs.get(x, yMinus2).getType() == ObservationType.BAT))
        {
            // Ir en dirección contraria: sur
            danger = true;
            return Types.ACTIONS.ACTION_DOWN;
        }
        // x + 1, y - 1
        else if ((gs.get(xPlus1, yMinus1).getType() == ObservationType.SCORPION) ||
                (gs.get(xPlus1, yMinus1).getType() == ObservationType.BAT))
        {
            // Ir en dirección contraria: sur
            danger = true;
            return Types.ACTIONS.ACTION_DOWN;
        }
        // No hay bichos:
        else {
            // No hace nada:
            if (danger) {
                reroute = true;
                danger = false;
            }

            return Types.ACTIONS.ACTION_NIL;
        }
    }

}















