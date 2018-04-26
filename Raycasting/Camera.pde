class Camera {

  protected final float resolution;

  protected final float spacing;

  protected final float fov;

  protected final float range;

  protected final float lightRange;

  protected final float scale;

  //private OrthographicCamera camera;
  //private SpriteBatch batch;
  //private ShapeRenderer shapeRenderer;

  public Camera(final float resolution_, final float fov_) {
    //this.camera = camera;
    //this.batch = new SpriteBatch();
    //this.batch.setProjectionMatrix(camera.combined);
    //this.shapeRenderer = new ShapeRenderer();
    //this.shapeRenderer.setProjectionMatrix(camera.combined);
    //this.width = this.camera.viewportWidth;
    //this.height = this.camera.viewportHeight;
    resolution = resolution_;
    spacing = width / resolution;
    fov = fov_;
    range = 14f;
    lightRange = 5f;
    scale = (width + height) / 1200;
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

  private void drawColumns(Player player, Map map) {
    for (int column = 0; column < this.resolution; column++) {
      final float angle = fov * (column / resolution - 0.5f);
      final Ray ray = map.cast(player.getPosition(), player.direction + angle, range);
      this.drawColumn(column, ray, angle, map);
    }
  }

  //private void drawWeapon(Texture weapon, float paces) {
  //  float bobX = cos(paces * 2) * this.scale * 6;
  //  float bobY = sin(paces * 4) * this.scale * 6;
  //  float left = this.width * 0.66 + bobX;
  //  float top = this.height * 0.6 + bobY;
  //  batch.begin();
  //  batch.draw(weapon, (float)left, (float)top, (float)(weapon.getWidth() * this.scale), (float)(weapon.getHeight() * this.scale), 0, 0, weapon.getWidth(), weapon.getHeight(), false, true);
  //  batch.end();
  //}

  private void drawColumn(float column, Ray ray, float angle, Map map) {
    //Texture texture = map.wallTexture;
    float left = floor(column * this.spacing);
    float width_ = ceil(this.spacing);
    int hit = -1;

    while (++hit < ray.getNumOfSteps() && ray.getStep(hit).getHeight() <= 0);
    
    noStroke();

    for (int s = ray.steps.size() - 1; s >= 0; s--) {
      final RayStep step = ray.steps.get(s);
      float rainDrops = pow(random(1f), 3f) * s;
      Projection rain = null;
      if (rainDrops > 0f) {
        rain = project(0.1f, angle, step.distance);
      }

      if (s == hit) {
        //float textureX = floor(texture.getWidth() * step.offset);
        final Projection wall = project(step.getHeight(), angle, step.getDistance());

        //batch.begin();
        //batch.draw(texture, (float)left, (float)wall.top, (float)width, (float)wall.height, (int)textureX, 0, 1, texture.getHeight(), false, true);
        //batch.end();
        fill(0xFFFFFFFF);
        rect((float)left, (float)wall.getTop(), (float)width_, (float)wall.getHeight());

        //Gdx.gl.glEnable(GL20.GL_BLEND);
        //Gdx.gl.glBlendFunc(GL20.GL_SRC_ALPHA, GL20.GL_ONE_MINUS_SRC_ALPHA);
        //shapeRenderer.setColor(0, 0, 0, (float)max((step.distance + step.shading) / this.lightRange - map.light, 0));
        //shapeRenderer.begin(ShapeRenderer.ShapeType.Filled);
        
        fill(0f, 0f, 0f, (float)max((step.distance + step.shading) / lightRange - map.light, 0f));
        rect((float)left, (float)wall.getTop(), (float)width_, (float)wall.getHeight());

        //rect((float)left, (float)wall.getTop(), (float)width_, (float)wall.getHeight());
        //shapeRenderer.end();
        //Gdx.gl.glDisable(GL20.GL_BLEND);
      }

      if (rain != null) {
        //Gdx.gl.glEnable(GL20.GL_BLEND);
        //Gdx.gl.glBlendFunc(GL20.GL_SRC_ALPHA, GL20.GL_ONE_MINUS_SRC_ALPHA);
        //shapeRenderer.setColor(1, 1, 1, 0.15f);]
        fill(0x20FFFFFF);
        //shapeRenderer.begin(ShapeRenderer.ShapeType.Filled);
        while (--rainDrops > 0) {
          rect((float)left, (float)(random(rain.top)), 1f, (float)rain.getHeight());
        }
        //shapeRenderer.end();
      }
    }
  }

  private Projection project(float height_, float angle, float distance) {
    float z = distance * cos(angle);
    float wallHeight = height * height_ / z;
    float bottom = (height / 2f) * (1f + (1f / z));
    return new Projection(bottom - wallHeight, wallHeight);
  }
}
