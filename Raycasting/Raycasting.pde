/**
 * Constants
 */

/**
 * Values
 */

private Engine engine;

/**
 * Lifecycle
 */

void setup() {
  fullScreen();
  // fullScreen(2);
  background(0);

  colorMode(HSB, 1f);
  engine = new Engine();
}

void draw() {
  background(0);
  engine.tick();
}

/*
 * Implementation
 */
