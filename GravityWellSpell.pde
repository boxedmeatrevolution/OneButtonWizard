class GravityWell extends Collider {
  
  float timer = 0.0;
  float lifetime = 10.0;
  
  public GravityWell(float x_, float y_, float velocityX_, float velocityY_) {
    super(x_, y_, 32.0, 20.0);
    velocityX = velocityX_;
    velocityY = velocityY_;
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
    removeEntity(other);
  }
  
  void create() {
    super.create();
  }
  
  void destroy() {
    super.destroy();
  }
  
  void render() {
    super.render();
    fill(0, 0, 0);
    ellipse(x, y, 2 * radius, 2 * radius);
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    timer += delta;
    if (timer > lifetime) {
      removeEntity(this);
    }
    for (Entity entity : entities) {
      if (entity instanceof HealthOrb || entity instanceof ManaOrb) {
        dist = sq(entity.x - x) + sq(entity.y - y);
        mag = pow(dist, 1.5);
        if (dist != 0) {
          entity.velocityX -= delta * 100000000 * (entity.x - x) / mag;
          entity.velocityY -= delta * 100000000 * (entity.y - y) / mag;
        }
      }
    }
  }
  
  int depth() {
    return 0;
  }
  
}

class GravityWellSpell extends Spell {
  
  int[] combination = new int[] { 1, 1, 0, 1, 0, 0 };
  
  public GravityWellSpell() {
  }
  
  public void invoke(Wizard owner) {
    GravityWell well = new GravityWell(width / 2, height / 2, 0, 0);
    addEntity(well);
  }
  
  public float getManaCost() {
    return 50.0f;
  }
  
  public int[] getCombination() {
    return combination;
  }
}

