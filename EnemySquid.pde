class EnemySquid extends Wizard {
  
  EnemySquid(float x_, float y_, boolean leftFacing, InputProcessor inputProcessor) {
    super(x_, y_, 100.0f, 60.0f, leftFacing, inputProcessor);
  }
  
  float phaseTimer = 0.0f;
  float comboTimer = 0.0f;
  
  void create() {
    super.create();
    if (enemySquidSpriteSheet == null) {
      enemySquidSpriteSheet = loadSpriteSheet("/assets/enemy3.png", 4, 1, 250, 250);
    }
    wizardStandingAnimation = new Animation(enemySquidSpriteSheet, 0.25, 0, 1);
    wizardCastPrepAnimation = wizardStandingAnimation;
    wizardCastingAnimation = wizardStandingAnimation;
    wizardHurtAnimation = wizardStandingAnimation;
    wizardWinAnimation = wizardStandingAnimation;
    wizardLoseAnimation = new Animation(enemySquidSpriteSheet, 0.25, 3);
    wizardFadeAnimation = new Animation(enemySquidSpriteSheet, 0.25, 2);
    wizardStunAnimation = wizardStandingAnimation;
    
    rapidShotSpell = new RapidShotSpell();
    manaOrbSpell = new ManaSpell();
    phaseSpell = new PhaseSpell();
    piercerSpell = new PiercerSpell();
    MANA_REGEN_RATE = 0.0f;
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    if (preFight || stunned || winner || loser) {
      return;
    }
    phaseTimer += delta;
    if (phaseTimer > 3.0f && _mana > phaseSpell.getManaCost()) {
      phaseSpell.invoke(this);
      _mana -= phaseSpell.getManaCost();
      phaseTimer = 10.0f;
    }
    if (phaseTimer > 13.0f) {
      phaseTimer = 0.0f;
    }
    
    comboTimer += delta;
    if (comboTimer > 3.0f) {
      if (_mana > piercerSpell.getManaCost()) {
        piercerSpell.invoke(this);
        _mana -= piercerSpell.getManaCost();
      }
      if (_mana > rapidShotSpell.getManaCost()) {
        rapidShotSpell.invoke(this);
        _mana -= rapidShotSpell.getManaCost();
      }
      comboTimer = 0.0f;
      
      if (random(1) > 1 - 0.2 * delta) {
        manaOrbSpell.invoke(this);
      }
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
  
  RapidShotSpell rapidShotSpell;
  PiercerSpell piercerSpell;
  PhaseSpell phaseSpell;
  ManaSpell manaOrbSpell;
  
}

SpriteSheet enemySquidSpriteSheet;

