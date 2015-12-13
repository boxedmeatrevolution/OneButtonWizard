class ManaOrb extends Moving{
  Wizard owner;
  float distY = 150.0;
  float manaRegen = 5.0; //mana regenerated per second
  float radius = 20;
  float timer = 5.0;
  
  public ManaOrb(Wizard owner_) {
    super(owner_.x + 50, owner_.y - distY, 0.0);
    this.velocityX = 25;
    this.velocityY = 15;
    owner = owner_;
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    accelToPoint(owner.x, owner.y - distY);
    
    owner._mana += manaRegen * delta;
    if (owner._mana > owner._maxMana) {
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
    fill(0, 0, 255);
    ellipse(this.x, this.y, radius * 2, radius * 2);
  }
  
  void accelToPoint(float px, float py) {
    //float mag = sqrt( pow((this.x - px), 2) + pow((this.y - py)) );
    float dirX = px - this.x;
    float dirY = py - this.y;
    this.accelX = dirX * 50;
    this.accelY = dirY * 50;
  }
} 

class ManaSpell extends Spell {
  int[] combination = new int[] {1, 1};
  String name = "ManaSpell";
 
  public ManaSpell() {
    super();
  }
  
  void invoke(Wizard owner) {
    ManaOrb manaOrb = new ManaOrb(owner);
    addEntity(manaOrb);
  }
  
  float getManaCost() {
    return 0.0f;
  }
  
  int[] getCombination() {
    return combination;
  }
}
