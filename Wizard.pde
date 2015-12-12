class Wizard extends Collider{
  float _maxHealth;
  float _maxMana;
  float _health;
  float _mana;
  
  boolean leftFacing;
  
  Wizard(float maxHealth, float maxMana, boolean leftFacing) {
    _maxHealth = maxHealth;
    _maxMana = maxMana;
    _leftFacing = leftFacing;
    x = 100;
    y = 100;
  }
  
  void create() {
    super.create();
    if (wizardStandingSheet == null) {
      wizardStandingSheet = loadSpriteSheet("/assets/standing.png", 2, 1, 256, 256);
    }
    wizardStandingAnimation = new Animation(wizardStandingSheet, 0.2, 0, 1);
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    wizardStandingAnimation.update(delta);
  }
  
  void render() {
    super.render();
    console.log(x + " " + y);
    wizardStandingAnimation.drawAnimation(x - 32, y - 32, 64, 64);
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
  }
  
  void hurt(float damage) {
    health -= damage;
  }
  
  Animation wizardStandingAnimation;
}

SpriteSheet wizardStandingSheet;
