class Map {

  protected int size;

  protected int[] wallGrid;

  protected float light;

  //protected Texture skybox;

  //protected Texture wallTexture;

  Map(int size) {
    this.size = size;
    this.wallGrid = new int[this.size * this.size];
    this.light = 0;
    //this.skybox = new Texture(Gdx.files.internal("deathvalley_panorama.jpg"));
    //this.wallTexture = new Texture(Gdx.files.internal("wall_texture.jpg"));
  }

  int get(float x, float y) {
    x = floor(x);
    y = floor(y);

    if (x < 0 || x > size - 1 || y < 0 || y > size - 1) {
      return -1;
    } else {
      return wallGrid[(int) (y * size + x)];
    }
  }

  void randomize() {
    for (int i = 0; i < this.size * this.size; i++) {
      this.wallGrid[i] = Math.random() < 0.3 ? 1 : 0;
    }
  }

  Ray cast(final PVector position, final float angle, final float range) {
    final RayStep origin = new RayStep(position, 0f, 0f, 0f, 0f, 0f);
    return new Ray(this, origin, sin(angle), cos(angle), range);
  }

  void update(final float seconds) {
    if (light > 0f) {
      light = max(light - 10f * seconds, 0f);
    } else if (random(5f) < seconds) {
      light = 2f;
    }
  }
}
