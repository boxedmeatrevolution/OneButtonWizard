class Fireball extends Hazard {
  
  public Fireball(float x_, float y_, float velocityX_, float velocityY_) {
    super(x_, y_, 20.0, 0.0);
    this.damage = 10.0f;
    this.velocityX = velocityX_;
    this.velocityY = velocityY_;
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
    removeEntity(this);
  }
  
  void create() {
    super.create();
  }
  
  void destroy() {
    super.destroy();
  }
  
  void render() {
    super.render();
    fill(255, 0, 0);
    ellipse(x, y, radius / 2, radius / 2);
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
  }
  
  int depth() {
    return 0;
  }
  
}

