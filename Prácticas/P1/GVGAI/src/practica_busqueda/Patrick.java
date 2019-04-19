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

        reroute = true;
        hasGems = false;
    }

    // Método act:
    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {

        // Actualizar estado del juego:
        gs.update(stateObs);


        // Realcular ruta si es necesario:
        if(reroute) {
            reroute(stateObs);
        }

        // Acción a devolver:
        Types.ACTIONS action = Types.ACTIONS.ACTION_NIL;

        // Decidir qué acción tomar según la siguiente posición de la ruta:
        if(currentPos.hasNext()) {
            Node next = currentPos.next();

            action = nextMove(next.position);

            // Comprobar si nos movemos a la siguiente casilla o simplemente cambiamos de orientación:
            checkMove(action);
        }
        else {
          //  action = pickGem();
            reroute = true;
        }

        // Para poder apreciar mejor lo tonto que es Patrick:
        try {
            Thread.sleep(500);
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
}















