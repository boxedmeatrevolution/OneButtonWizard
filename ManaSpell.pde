class ManaOrb extends Collider{
  Wizard owner;
  float distY = 150.0;
  float manaRegen = 2.0; //mana regenerated per second
  float timer = 8.0;
  
  public ManaOrb(Wizard owner_) {
    super(owner_.x + 50, owner_.y - distY, 20, 0.0);
    this.velocityX = 25;
    this.velocityY = 15;
    owner = owner_;
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    accelToPoint(owner.x, owner.y - distY);
    
    owner._mana += manaRegen * delta;
    if (owner._mana > owner._maxMana) {
      owner._mana = owner._maxMana;
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

class ManaSpell extends Spell {
  int[] combination = new int[] { 1 };
  String name = "ManaSpell";
 
  public ManaSpell() {
    super();
  }
  
  void invoke(Wizard owner) {
    ManaOrb manaOrb = new ManaOrb(owner);
    addEntity(manaOrb);
  }
  
  float getManaCost() {
    return 5.0f;
  }
  
  int[] getCombination() {
    return combination;
  }
}
