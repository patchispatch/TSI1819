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
import java.util.Vector;

import javax.swing.plaf.nimbus.State;

public class Patrick extends BaseAgent {

    // Atributos:
    PathFinder pf;
    GameState gs;
    PathFinder bugFinder;

    ArrayList<Node> currentPath;
    ListIterator<Node> currentPos;
    Vector2d objective;
    Vector2d nearestPortal;
    int remainingGems;

    boolean danger;
    boolean reroute;
    boolean hasGems;

    Types.ACTIONS bufferedAction;

    // Constructor:
    public Patrick(StateObservation so, ElapsedCpuTimer elapsedTimer) {
        super(so, elapsedTimer);

        // Enemigos: murciélagos y escorpiones
        ArrayList<Integer> obstacles = new ArrayList();
        obstacles.add(gs.WALL);
        obstacles.add(gs.STONE);

        pf = new PathFinder(obstacles);
        gs = new GameState(so, this);

        // BugFinder: devuelve un camino de tierra excavada entre un elemento (bicho) y
        // el jugador.
        ArrayList<Integer> everything = new ArrayList();
        everything.add(gs.WALL);
        everything.add(gs.STONE);
        everything.add(gs.GEM);
        everything.add(gs.PORTAL);
        everything.add(gs.GROUND);
        bugFinder = new PathFinder(everything);

        currentPath = new ArrayList();
        remainingGems = getRemainingGems(so);

        danger = false;
        reroute = true;
        hasGems = false;

        bufferedAction = Types.ACTIONS.ACTION_NIL;
    }

    // Método act:
    @Override
    public Types.ACTIONS act(StateObservation stateObs, ElapsedCpuTimer elapsedTimer) {

        // Acción a devolver:
        Types.ACTIONS action = Types.ACTIONS.ACTION_NIL;

        // Actualizar estado del juego:
        gs.update(stateObs);

        // Comprobar si hay una acción en el buffer:
        if (bufferedAction != Types.ACTIONS.ACTION_NIL) {
            action = bufferedAction;
            bufferedAction = Types.ACTIONS.ACTION_NIL;
        }
        else {
            // Comprobar si estamos en peligro:
            action = checkBug(stateObs);

            if (!danger) {

                // Fuera de peligro:
                System.out.println("Fuera de peligro");

                // Realcular ruta si es necesario:
                if(reroute) {
                    reroute(stateObs);
                }

                // Decidir qué acción tomar según la siguiente posición de la ruta:
                if(currentPos.hasNext()) {
                    Node next = currentPos.next();

                    // Comprobar si no estamos en peligro de ser el próximo Garcilaso:
                    if(garcilaso(next.position)) {
                        System.out.println("GARCILASOOOOOO");
                        action = Types.ACTIONS.ACTION_NIL;
                    }
                    else {
                        action = nextMove(next.position);
                    }

                    // Comprobar si nos movemos a la siguiente casilla o simplemente cambiamos de orientación:
                    checkMove(action);
                }
                else {
                    // Recalculamos:
                    reroute = true;
                }
            }
        }

        // Para poder apreciar mejor lo tonto que es Patrick:
        try {
            Thread.sleep(100);
        }
        catch (InterruptedException e) {}

        System.out.println(gs.get(19.0, 3.0));

        return action;
    }


    // Determina la siguiente acción basándose en la siguiente casilla de la ruta
    private Types.ACTIONS nextMove(Vector2d nextPos){

        Types.ACTIONS nextMove;
        Vector2d patrickPos = gs.playerPosition();

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
                (action == Types.ACTIONS.ACTION_DOWN && ori != Orientation.S) ||
                (action == Types.ACTIONS.ACTION_NIL))
        {
            currentPos.previous();
        }
    }


    // Esquiva un bicho si lo tiene a dos casillas de distancia:
    Types.ACTIONS checkBug(StateObservation stateObs) {
        PlayerObservation player = getPlayer(stateObs);

        Types.ACTIONS action = Types.ACTIONS.ACTION_NIL;

        // Obtener enemigos:
        ArrayList<Observation>[] enemies = this.getEnemiesList(stateObs);

        for (int i = 0; i < enemies.length; i++) {
            for (Observation obs : enemies[i]) {
                int d = player.getManhattanDistance(obs);
                boolean caught = bugCaught(stateObs, obs);

                // Enemigo en zona de peligro
                if (d <= 2 && !caught) {
                    // Estamos en peligro:
                    System.out.println("En peligro");
                    danger = true;

                    Vector2d bugPos = new Vector2d(obs.getX(), obs.getY());
                    Orientation bugOrientation = gs.relativeOrientation(bugPos);

                    // Decidir la acción a realizar:
                    action = escape(bugOrientation);

                    // Si no estamos mirando en la dirección opuesta al bicho, metemos la
                    // acción en el buffer:
                    if (bugOrientation != opposite(player.getOrientation())) {
                        bufferedAction = action;
                    }

                    // Salimos del bucle cagando leches:
                    return action;
                }
            }
        }

        // Si hemos llegado hasta aquí estamos a salvo:
        danger = false;
        return action;
    }


    // Devuelve la orientación opuesta a la dada:
    private Orientation opposite(Orientation ori) {
        if(ori == Orientation.N) {
            return Orientation.S;
        }
        else if(ori == Orientation.S) {
            return Orientation.N;
        }
        else if(ori == Orientation.E) {
            return Orientation.W;
        }
        else {
            return Orientation.E;
        }
    }


    // Huir en la dirección opuesta a la orientación dada:
    private Types.ACTIONS escape(Orientation ori) {

        Types.ACTIONS action;

        if(ori == Orientation.N) {
            action = Types.ACTIONS.ACTION_DOWN;
        }
        else if(ori == Orientation.E) {
            action = Types.ACTIONS.ACTION_LEFT;
        }
        else if(ori == Orientation.S) {
            action = Types.ACTIONS.ACTION_UP;
        }
        else {
            action = Types.ACTIONS.ACTION_RIGHT;
        }

        return action;
    }

    private boolean bugCaught(StateObservation stateObs, Observation bug) {

        Vector2d bugPos = new Vector2d(bug.getX(), bug.getY());

        bugFinder.run(stateObs);
        ArrayList<Node> bugPath = bugFinder.getPath(bugPos, gs.playerPosition());

        if(bugPath == null) {
            return true;
        }
        else {
            return false;
        }
    }


    // Comprueba si Patrick planea emular la grandiosa muerte de Garcilaso de la Vega:
    private boolean garcilaso(Vector2d pos) {
        Observation obs = gs.get(pos);

        System.out.println(obs);

        if(obs.getType() == ObservationType.BOULDER && gs.rockAbove(pos)) {
            // No caigas en la trampa mortal:
            System.out.println("GARCILASO");
            reroute = true;
            return true;
        }

        return false;
    }
}















