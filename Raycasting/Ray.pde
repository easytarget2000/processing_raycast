class Ray {

  private final Map map;

  private final float sin;

  private final float cos;

  private final ArrayList<RayStep> steps = new ArrayList<RayStep>();

  Ray(
    final Map map_, 
    final RayStep origin, 
    final float sin_, 
    final float cos_, 
    final float range
    ) {
    map = map_;
    sin = sin_;
    cos = cos_;

    cast(origin, range);
  }
  
  int getNumOfSteps() {
    return steps.size();
  }
  
  RayStep getStep(final int index) {
    return steps.get(index);
  }

  void cast(final RayStep origin, final float range) {
    final PVector originPosition = origin.getPosition();
    final RayStep stepX = step(sin, cos, originPosition.x, originPosition.y, false);
    final RayStep stepY = step(cos, sin, originPosition.y, originPosition.x, true);

    final RayStep nextRayStep = stepX.length2 < stepY.length2
      ? inspect(stepX, 1, 0, origin.distance, stepX.getPosition().y)
      : inspect(stepY, 0, 1, origin.distance, stepY.getPosition().x);

    steps.add(origin);

    if (nextRayStep.distance < range) {
      cast(nextRayStep, range);
    }
  }

  private RayStep step(
    final float rise, 
    final float run, 
    final float x, 
    final float y, 
    final boolean inverted
    ) {

    if (run == 0f) {
      final RayStep noWallStep = new RayStep(null, 0f, 0f, 9000f, 0, 0);
      return noWallStep;
    }

    final float dx = run > 0f ? floor(x + 1f) - x : ceil(x - 1f) - x;
    final float dy = dx * (rise / run);
    final PVector rayPosition = new PVector(
      inverted ? y + dy : x + dx, 
      inverted ? x + dx : y + dy
      );

    return new RayStep(rayPosition, 0f, 0f, dx * dx + dy * dy, 0f, 0f);
  }

  private RayStep inspect(
    final RayStep step, 
    final float shiftX, 
    final float shiftY, 
    final float distance, 
    final float offset
    ) {

    final float dx = cos < 0f ? shiftX : 0f;
    final float dy = sin < 0f ? shiftY : 0f;

    step.height_ = map.get(step.getPosition().x - dx, step.getPosition().y - dy);
    step.distance = distance + sqrt(step.length2);

    if (shiftX == 1) {
      step.shading = cos < 0f ? 2f : 0f;
    } else {
      step.shading = sin < 0f ? 2f : 1f;
    }

    step.offset = offset - floor(offset);
    return step;
  }
}
