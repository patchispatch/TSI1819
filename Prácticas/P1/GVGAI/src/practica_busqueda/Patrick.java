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

    ArrayList currentPath;
    Iterator<Node> currentPos;
    boolean reroute;

    // Constructor:
    public Patrick(StateObservation so, ElapsedCpuTimer elapsedTimer) {
        super(so, elapsedTimer);

        // Enemigos: murciélagos y escorpiones
        ArrayList<Integer> enemies = new ArrayList();
        enemies.add(gs.SCORPION);
        enemies.add(gs.BAT);

        pf = new PathFinder(enemies);
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
            reroute();
        }

        // Acción a devolver:
        Types.ACTIONS action;

        // Decidir qué acción tomar según la siguiente posición de la ruta:
        Node next = currentPos.next();
        action = nextMove(next.position);


        return action;
    }


    // Determina la siguiente acción basándose en la siguiente posición de la ruta
    private Types.ACTIONS nextMove(Vector2d nextPos){

        Types.ACTIONS nextMove;
        Vector2d patrickPos = gs.playerPosition();

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
    private void reroute() {
        // Ir a la gema más cercana
        System.out.println(gs.playerPosition().x);
        System.out.println(gs.playerPosition().y);
        System.out.println(gs.nearestGem().x);
        System.out.println(gs.nearestGem().y);
        currentPath = pf.getPath(gs.playerPosition(), gs.nearestGem());
        currentPos = currentPath.iterator();
        reroute = false;
    }
}















