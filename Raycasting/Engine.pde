class Engine {

  /**
   * Values
   */

  private Player player;

  private Map map;

  private Camera camera;

  private int lastUpdateMillis = 0;

  Engine() {
    final PVector playerPosition = new PVector(15.3f, -1.2f);
    player = new Player(playerPosition, PI * 0.3f);
    map = new Map(32);
    map.randomize();
    camera = new Camera(320f, PI * 0.4f);
  }

  void tick() {
    final float deltaSeconds = (millis() - lastUpdateMillis) / 1000f;

    map.update(deltaSeconds);
    player.update(map, deltaSeconds);
    camera.render(player, map);

    lastUpdateMillis = millis();
  }
}
