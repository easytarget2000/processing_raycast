class Player {

  private PVector position;

  private float direction;

  private float paces = 0f;

  //function Player(x, y, direction) {
  //  this.x = x;
  //  this.y = y;
  //  this.direction = direction;
  //  this.weapon = new Bitmap('assets/knife_hand.png', 319, 320);
  //  this.paces = 0;
  //}

  Player(final PVector position_, final float direction_) {
    position = position_;
    direction = direction_;
  }
  
  PVector getPosition() {
    return position;
  }

  void rotate(final float angle) {
    direction = (direction + angle + TWO_PI) % TWO_PI;
  }

  void walk(final float distance, final Map map) {
    final float deltaX = cos(direction) * distance;
    final float deltaY = sin(direction) * distance;

    if (map.get(position.x + deltaX, position.y) <= 0) {
      position.x += deltaX;
    }

    if (map.get(position.x, position.y + deltaY) <= 0) {
      position.y += deltaY;
    }

    paces += distance;
  }
  
  void update() {
  }
}
