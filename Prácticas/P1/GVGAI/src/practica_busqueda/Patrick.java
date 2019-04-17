package practica_busqueda;

import core.game.StateObservation;
import ontology.Types;
import tools.ElapsedCpuTimer;
import tools.pathfinder.PathFinder;
import tools.pathfinder.Node;
import tools.Vector2d;

import java.util.ArrayList;
import java.util.Iterator;
import java.awt.*;

import javax.swing.plaf.nimbus.State;

public class Patrick extends BaseAgent {

    // Atributos:
    PathFinder pf;
    GameState gs;

    ArrayList<Node> currentPath;
    Iterator<Node> currentPos;
    Vector2d nearestGem;

    boolean reroute;

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
        reroute = true;
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
        }
        else {
            System.out.println("Cogiendo gema");
            action = nextMove(nearestGem);
            reroute = true;
        }

        // Para poder apreciar mejor lo tonto que es Patrick:
        try {
            Thread.sleep(1000);
        }
        catch (InterruptedException e) {}

        return action;
    }


    // Coger gema:
    private Types.ACTIONS pickGem(StateObservation stateObs) {

        PlayerObservation player = getPlayer(stateObs);
        Vector2d playerPosition = gs.playerPosition();

        Types.ACTIONS best = Types.ACTIONS.ACTION_NIL;
        if (player.getManhattanDistance(nearestGem) == 1) { // Veo si puedo coger esa gema (está a una distancia de 1)

            if (nearestGem.x < playerPosition.x) // gema a la izquierda
                best = Types.ACTIONS.ACTION_LEFT;

            else if (nearestGem.x > playerPosition.x) // gema a la derecha
                best = Types.ACTIONS.ACTION_RIGHT;

            else {
                if (nearestGem.y < playerPosition.y) // gema arriba
                   best = Types.ACTIONS.ACTION_UP;
                else
                    best = Types.ACTIONS.ACTION_DOWN;
            }

            reroute = true;
            return best; // Escojo esa acción directamente
        }

        else {
            reroute = true;
            return Types.ACTIONS.ACTION_NIL;
        }
    }


    // Determina la siguiente acción basándose en la siguiente casilla de la ruta
    private Types.ACTIONS nextMove(Vector2d nextPos){

        Types.ACTIONS nextMove;
        Vector2d patrickPos = gs.playerPosition();

        // Comprobamos si es una gema:

        if (nextPos.x != patrickPos.x){
            if (nextPos.x > patrickPos.x) {
                nextMove = Types.ACTIONS.ACTION_RIGHT;
            }

            else {
                nextMove = Types.ACTIONS.ACTION_LEFT;
            }
        }

        else if (nextPos.y != patrickPos.y){
            if(nextPos.y > patrickPos.y){
                nextMove = Types.ACTIONS.ACTION_DOWN;
            }

            else {
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
        // Ir a la gema más cercana
        System.out.println("Recalculando");

        nearestGem = gs.nearestGem();

        pf.run(stateObs);
        currentPath = pf.getPath(gs.playerPosition(), nearestGem);

        for (Node n : currentPath) {
            System.out.println(n.position.x);
        }

        currentPos = currentPath.iterator();
        reroute = false;
    }
}















