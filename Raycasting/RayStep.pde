class RayStep {

  private PVector position;

  private float height_;

  private float distance;

  private float length2;

  private float shading;

  private float offset;

  RayStep(
    final PVector position_, 
    final float height__, 
    final float distance_, 
    final float length2_, 
    final float shading_, 
    final float offset_
    ) {
    position = position_;
    height_ = height__;
    distance = distance_;
    length2 = length2_;
    shading = shading_;
    offset = offset_;
  }

  final PVector getPosition() {
    return position;
  }

  float getHeight() {
    return height_;
  }

  float getDistance() {
    return distance;
  }

  float getLength2() {
    return length2;
  }
}
