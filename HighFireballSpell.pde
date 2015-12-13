class HighFireball extends Hazard {
  
  int GRAV = 220;
  float ACCELX = 50;
  
  boolean _leftFacing;
  
  public HighFireball(float x_, float y_, float velocityX_, float velocityY_, Wizard owner) {
    super(x_, y_, 20.0, 0.0, 1.0, owner);
    console.log("fireball " + y_);
    this.damage = 12.0f;
    this.velocityX = velocityX_;
    this.velocityY = velocityY_;
    ACCELX = (owner._leftFacing ? -ACCELX : ACCELX);
    _leftFacing = owner._leftFacing;
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
    if (triggered) {
      removeEntity(this);
    }
  }
  
  void create() {
    super.create();
    if (spinningFireballSpritesheet == null) {
      spinningFireballSpritesheet = loadSpriteSheet("/assets/spinningFireball.png", 4, 1, 60, 60);
    }
    spinningFireballAnimation = new Animation(spinningFireballSpritesheet, 0.1, 0, 1, 2, 3);
  }
  
  void destroy() {
    super.destroy();
  }
  
  void render() {
    super.render();
    float xr = x - 60;
    float xy = y - 60;
    float size = 120;
    
    if(_leftFacing) {
      scale(-1, 1);
      xr = -((x - size/2) + size);
    }
    
    spinningFireballAnimation.drawAnimation(xr, xy, size, size);
     
    if (_leftFacing) {
      scale(-1, 1);
    }    
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    spinningFireballAnimation.update(delta);
    velocityY += delta * GRAV;
    velocityX += delta * ACCELX;
  }
  
  int depth() {
    return 0;
  }
  
}

class HighFireballSpell extends Spell {
  
  int[] combination = new int[] { 1, 0, 1 };
  
  public HighFireballSpell() {
  }
  
  public void invoke(Wizard owner) {
    console.log("invoked");
    HighFireball fireball = new HighFireball(owner.x, owner.y, 100, -460, owner);
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
    return 15.0f;
  }
  
  public int[] getCombination() {
    return combination;
  }
}

SpriteSheet spinningFireballSpritesheet;
