package practica_busqueda;

import core.game.StateObservation;

import tools.Vector2d;
import java.util.ArrayList;

public class GameState {
    // Elementos del juego:
    public static final int EMPTY = -1;
    public static final int WALL = 0;
    public static final int PLAYER = 1;
    public static final int GROUND = 4;
    public static final int PORTAL = 5;
    public static final int GEM = 6;
    public static final int STONE = 7;
    public static final int SCORPION = 10;
    public static final int BAT = 11;

    // Atributos:
    private StateObservation obs;
    private PlayerObservation player;
    private Patrick pat;
    private ArrayList<Observation>[][] map;


    // Constructor:
    public GameState(StateObservation stateObs, Patrick patrick) {
        obs = stateObs;
        pat = patrick;
        map = pat.getObservationGrid(obs);
    }

    // Lista de enemigos:
    ArrayList<Vector2d> getEnemiesList() {

        // Obtener lista de observaciones:
        ArrayList<Observation>[] obsEnemies = pat.getEnemiesList(obs);

        // Iterar sobre la lista y obtener la posición de cada enemigo:
        ArrayList<Vector2d> enemies = new ArrayList();

        for (ArrayList<Observation> list : obsEnemies) {
            for (Observation e : list) {
                Vector2d enemy = new Vector2d(e.getX(), e.getY());
                enemies.add(enemy);
            }
        }

        return enemies;
    }

    // Lista de gemas:
    ArrayList<Vector2d> getGemsList() {

        // Obtener lista de observaciones:
        ArrayList<Observation> obsGems = pat.getGemsList(obs);

        // Iterar sobre la lista y obtener la posición de cada gema:
        ArrayList<Vector2d> gems = new ArrayList();

        for (Observation g : obsGems) {
            Vector2d gem = new Vector2d(g.getX(), g.getY());
            gems.add(gem);
        }

        return gems;
    }


    // Lista de muros:
    ArrayList<Vector2d> getWallsList() {

        // Obtener lista de observaciones:
        ArrayList<Observation> obsWalls = pat.getWallsList(obs);

        // Iterar sobre la lista y obtener la posición de cada muro:
        ArrayList<Vector2d> walls = new ArrayList();

        for (Observation w : obsWalls) {
            Vector2d wall = new Vector2d(w.getX(), w.getY());
            walls.add(wall);
        }

        return walls;
    }


    // Lista de casillas con tierra:
    ArrayList<Vector2d> getGroundTilesList() {

        // Obtener lista de observaciones:
        ArrayList<Observation> obsGround = pat.getGroundTilesList(obs);

        // Iterar sobre la lista y obtener la posición de cada casilla de tierra:
        ArrayList<Vector2d> ground = new ArrayList();

        for (Observation g : obsGround) {
            Vector2d tile = new Vector2d(g.getX(), g.getY());
            ground.add(tile);
        }

        return ground;
    }


    // Lista de casillas con tierra:
    ArrayList<Vector2d> getEmptyTilesList() {

        // Obtener lista de observaciones:
        ArrayList<Observation> obsEmpty = pat.getEmptyTilesList(obs);

        // Iterar sobre la lista y obtener la posición de cada casilla de tierra:
        ArrayList<Vector2d> empty = new ArrayList();

        for (Observation e : obsEmpty) {
            Vector2d tile = new Vector2d(e.getX(), e.getY());
            empty.add(tile);
        }

        return empty;
    }


    // Actualizar estado del juego:
    void update(StateObservation so) {
        obs = so;
        map = pat.getObservationGrid(obs);
        player = pat.getPlayer(obs);
    }


    // Devolver gema más cercana al jugador:
    Vector2d nearestGem() {

        // Lista de las gemas (observation):
        ArrayList<Observation> gems = pat.getGemsList(obs);

        // Iteramos para quedarnos con la gema más cercana:
        Observation near = gems.get(0);
        int dist = player.getManhattanDistance(near);

        for (Observation gem : gems) {
            // Calculamos distancia manhattan:
            int man = player.getManhattanDistance(gem);

            // Comprobamos si está más cerca:
            if (man < dist) {
                near = gem;
                dist = man;
            }
        }

        // Devolver coordenadas:
        Vector2d nearestGem = new Vector2d(near.getX(), near.getY());
        return nearestGem;
    }

    Vector2d nearestPortal() {
        Observation e = pat.getExit(obs);
        Vector2d exit = new Vector2d(e.getX(), e.getY());

        return exit;
    }

    // Devolver la posición del jugador:
    Vector2d playerPosition() {
        Vector2d playerPos = new Vector2d(player.getX(), player.getY());

        return playerPos;
    }


    // Devuelve la orientación del jugador:
    Orientation playerOrientation() {
        Orientation orientation = player.getOrientation();

        return orientation;
    }


    // Devuelve el contenido de una posición:
    Observation get(double x, double y) {
        return map[(int) x][(int) y].get(0);
    }

    // Devuelve el ancho del mapa:
    int mapWidth() {
        return map.length;
    }

    // Devuelve el largo del mapa:
    int mapHeight() {
        return map[0].length;
    }

}


