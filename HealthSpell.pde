class HealthOrb extends Collider{
  Wizard owner;
  float distY = 200.0;
  float healthRegen = 0.5; //health regenerated per second
  float timer = 10.0;
  
  public HealthOrb(Wizard owner_) {
    super(owner_.x + 50, owner_.y - distY, 20, 0.0);
    this.velocityX = 25;
    this.velocityY = 15;
    owner = owner_;
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    accelToPoint(owner.x, owner.y - distY);
    
    owner._health += healthRegen * delta;
    if (owner._health > owner._maxHealth) {
      owner._health = owner._maxHealth;
    }
    timer -= delta;
    if (timer <= 0) {
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
    fill(0, 255, 0);
    ellipse(this.x, this.y, radius * 2, radius * 2);
  }
  
  void accelToPoint(float px, float py) {
    float mag = sqrt(sq(this.x - px) + sq(this.y - py));
    if (mag == 0) {
      return;
    }
    float dirX = (px - this.x) / mag;
    float dirY = (py - this.y) / mag;
    this.accelX = dirX * 500;
    this.accelY = dirY * 500;
  }
} 

class HealthSpell extends Spell {
  int[] combination = new int[] {0};
 
  public HealthSpell() {
  }
  
  void invoke(Wizard owner) {
    console.log("Health Orb Invoked");
    HealthOrb healthOrb = new HealthOrb(owner);
    addEntity(healthOrb);
  }
  
  float getManaCost() {
    return 15.0f;
  }
  
  int[] getCombination() {
    return combination;
  }
  
}
