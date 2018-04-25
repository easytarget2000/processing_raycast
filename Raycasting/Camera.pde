public class Camera {

  private float resolution;
  private float spacing;
  private float fov;
  private float range;
  private float lightRange;
  private float scale;

  public Camera(final float resolution, final float fov) {
    this.resolution = resolution;
    this.spacing = width / resolution;
    this.fov = fov;
    this.range = 14f;
    this.lightRange = 5f;
    this.scale = (width + height) / 1200f;
  }

  public void render(Player player, Map map) {
    //this.drawSky(player.direction, map.skybox, map.light);
    this.drawColumns(player, map);
    //this.drawWeapon(player.weapon, player.paces);
  }

  //private void drawSky(float direction, Texture sky, float ambient) {
  //  float width = this.width * (Raycaster.CIRCLE / this.fov);
  //  float left = -width * direction / Raycaster.CIRCLE;

  //  batch.begin();
  //  batch.draw(sky, (float)left, (float)0, (float)width, (float)this.height, 0, 0, sky.getWidth(), sky.getHeight(), false, true);
  //  if (left < width - this.width) {
  //    batch.draw(sky, (float)(left + width), (float)0, (float)width, (float)this.height, 0, 0, sky.getWidth(), sky.getHeight(), false, true);
  //  }
  //  batch.end();

  //  if (ambient > 0) {
  //    Gdx.gl.glEnable(GL20.GL_BLEND);
  //    Gdx.gl.glBlendFunc(GL20.GL_SRC_ALPHA, GL20.GL_ONE_MINUS_SRC_ALPHA);
  //    shapeRenderer.setColor(1, 1, 1, (float)(ambient * 0.1));
  //    shapeRenderer.begin(ShapeRenderer.ShapeType.Filled);
  //    shapeRenderer.rect(0, 0, (float)this.width, (float)(this.height * 0.5));
  //    shapeRenderer.end();
  //    Gdx.gl.glDisable(GL20.GL_BLEND);
  //  }
  //}

  private void drawColumns(final Player player, final Map map) {
    for (int column = 0; column < resolution; column++) {
      final float angle = fov * (column / resolution - 0.5f);
      final Ray ray = map.cast(player.getPosition(), player.direction + angle, range);
      drawColumn(column, ray, angle, map);
    }
  }

  //private void drawWeapon(Texture weapon, float paces) {
  //  float bobX = Math.cos(paces * 2) * this.scale * 6;
  //  float bobY = Math.sin(paces * 4) * this.scale * 6;
  //  float left = this.width * 0.66 + bobX;
  //  float top = this.height * 0.6 + bobY;
  //  batch.begin();
  //  batch.draw(weapon, (float)left, (float)top, (float)(weapon.getWidth() * this.scale), (float)(weapon.getHeight() * this.scale), 0, 0, weapon.getWidth(), weapon.getHeight(), false, true);
  //  batch.end();
  //}

  private void drawColumn(float column, Ray ray, float angle, Map map) {
    //Texture texture = map.wallTexture;
    final float left = floor(column * this.spacing);
    final float width_ = ceil(this.spacing);

    int hit = -1;
    while (++hit < ray.getNumOfSteps() && ray.getStep(hit).getHeight() <= 0);

    for (int s = ray.getNumOfSteps() - 1; s >= 0; s--) {
      final RayStep step = ray.getStep(s);
      float rainDrops = pow(random(1f), 3) * s;
      Projection rain = null;
      if (rainDrops > 0f) {
        rain = project(0.1f, angle, step.distance);
      }

      if (s == hit) {
        //float textureX = floor(texture.getWidth() * step.offset);
        final Projection wall = project(step.getHeight(), angle, step.distance);

        //batch.draw(texture, (float)left, (float)wall.top, (float)width, (float)wall.height, (int)textureX, 0, 1, texture.getHeight(), false, true);

        //shapeRenderer.setColor(0, 0, 0, (float)Math.max((step.distance + step.shading) / this.lightRange - map.light, 0));
        rect(left, wall.getTop(), width_, wall.getHeight());
      }

      if (rain != null) {

        //shapeRenderer.setColor(1, 1, 1, 0.15f);
        while (--rainDrops > 0) {
          rect(left, random(rain.getTop()), 1f, rain.getHeight());
        }
      }
    }
  }

  private Projection project(final float height, final float angle, final float distance) {
    final float z = distance * cos(angle);
    final float wallHeight = height * height / z;
    final float bottom = height / 2f * (1f + 1f / z);
    return new Projection(bottom - wallHeight, wallHeight);
  }
}
