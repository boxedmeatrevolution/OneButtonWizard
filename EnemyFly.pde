class EnemyFly extends Wizard {
  
  EnemyFly(float x_, float y_, boolean leftFacing, InputProcessor inputProcessor) {
    super(x_, y_, 100.0f, 100.0f, leftFacing, inputProcessor);
  }
  
  float gustTimer = 0.0f;
  float meteorTimer = 6.7f;
  float manaSuckerTimer = 0.0f;
  float blackHoleTimer = 0.0f;
  
  void create() {
    super.create();
    if (enemyFlySpritesheet == null) {
      enemyFlySpritesheet = loadSpriteSheet("/assets/enemy2.png", 3, 1, 250, 250);
    }
    wizardStandingAnimation = new Animation(enemyFlySpritesheet, 0.25, 0, 1);
    wizardCastPrepAnimation = wizardStandingAnimation;
    wizardCastingAnimation = wizardStandingAnimation;
    wizardHurtAnimation = wizardStandingAnimation;
    wizardWinAnimation = wizardStandingAnimation;
    wizardLoseAnimation = new Animation(enemyFlySpritesheet, 0.25, 2);
    wizardFadeAnimation = wizardStandingAnimation;
    wizardStunAnimation = wizardStandingAnimation;
    
    gustSpell = new GustSpell();
    meteorSpell = new MeteorShowerSpell();
    manaSuckerSpell = new ManaSuckerSpell();
    manaOrbSpell = new ManaSpell();
    healthOrbSpell = new HealthSpell();
    gravityWellSpell = new GravityWellSpell();
    MANA_REGEN_RATE = 5.0f;
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    if (preFight || phased || stunned || winner || loser) {
      return;
    }
    gustTimer += delta;
    meteorTimer += delta;
    manaSuckerTimer += delta;
    blackHoleTimer += delta;
    
    if (gustTimer >= 4.0f) {
      gustSpell.invoke(this);
      gustTimer = 0.0f;
    }
    if (meteorTimer >= 8.0f) {
      meteorSpell.invoke(this);
      meteorTimer = 0.0f;
    }
    if (manaSuckerTimer >= 8.0f) {
      manaSuckerSpell.invoke(this);
      manaSuckerTimer = 0.0f;
    }
    if (blackHoleTimer >= 8.0f) {
      gravityWellSpell.invoke(this);
      blackHoleTimer = 0.0f;
    }
    
    if (random(1) > 1 - 0.2 * delta) {
      manaOrbSpell.invoke(this);
    }
    if (random(1) > 1 - 0.2 * delta) {
      healthOrbSpell.invoke(this);
    }
  }
  
  void render() {
    super.render();
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
  }
  
  void hurt(float damage) {
    super.hurt(damage);
  }
  
  GustSpell gustSpell;
  MeteorShowerSpell meteorSpell;
  ManaSuckerSpell manaSuckerSpell;
  ManaSpell manaOrbSpell;
  HealthSpell healthOrbSpell;
  GravityWellSpell gravityWellSpell;
  
}

SpriteSheet enemyFlySpritesheet;

