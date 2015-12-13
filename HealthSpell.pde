class HealthOrb extends Moving{
  Wizard owner;
  float distY = 200.0;
  float healthRegen = 5.0; //health regenerated per second
  float radius = 20;
  float timer = 5.0;
  
  public HealthOrb(Wizard owner_) {
    super(owner_.x + 50, owner_.y - distY, 10);
    console.log("Health Orb");
    this.velocityX = 20;
    this.velocityY = 10;
    console.log("Health Orb");
    owner = owner_;
    console.log("Health Orb");
  }
  
  void update(int phase, float delta) {
    accelToPoint(owner.x, owner.y + distY);
    
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
    fill(255, 0, 0);
    ellipse(this.x, this.y, radius * 2, radius * 2);
  }
  
  void accelToPoint(float px, float py) {
    //float mag = sqrt( pow((this.x - px), 2) + pow((this.y - py)) );
    float dirX = px - this.x;
    float dirY = py - this.y;
    this.accelY = dirX;
    this.accelY = dirY;
  }
} 

class HealthSpell extends Spell {
  int[] combination = new int[] {0, 1, 1};
 
  public HealthSpell() {
  }
  
  void invoke(Wizard owner) {
    console.log("Health Orb Invoked");
    HealthOrb healthOrb = new HealthOrb(owner);
    addEntity(healthOrb);
  }
  
  float getManaCost() {
    return 10.0f;
  }
  
  int[] getCombination() {
    return combination;
  }
  
}
