class HighFireball extends Hazard {
  
  int GRAV = 500;
  float ACCELX = 400;
  
  public HighFireball(float x_, float y_, float velocityX_, float velocityY_, Wizard owner) {
    super(x_, y_, 20.0, 0.0, 1.0, owner);
    console.log("fireball " + y_);
    this.damage = 1.0f;
    this.velocityX = velocityX_;
    this.velocityY = velocityY_;
    ACCELX = (owner._leftFacing ? -ACCELX : ACCELX);
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
    if (triggered) {
      removeEntity(this);
    }
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
    ellipse(x, y, 2 * radius, 2 * radius);
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    velocityY += delta * GRAV;
    velocityX += delta * ACCELX;
  }
  
  int depth() {
    return 0;
  }
  
}

class HighFireballSpell extends Spell {
  
  int[] combination = new int[] { 1, 0 };
  
  public HighFireballSpell() {
  }
  
  public void invoke(Wizard owner) {
    console.log("invoked");
    HighFireball fireball = new HighFireball(owner.x, owner.y, 100, -500, owner);
    if (owner.x < width / 2) {
      fireball.x += 10;
    }
    else {
      fireball.x -= 10;
      fireball.velocityX *= -1;
    }
    addEntity(fireball);
  }
  
  public float getManaCost() {
    return 10.0f;
  }
  
  public int[] getCombination() {
    return combination;
  }
}

