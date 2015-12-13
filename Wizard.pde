class Wizard extends Collider{
  float _maxHealth;
  float _maxMana;
  float _health;
  float _mana;
  
  boolean leftFacing;
  ArrayList<Spell> spellBook = new ArrayList<Spell>();
  
  InputProcessor _inputProcessor;
  
  Wizard(float maxHealth, float maxMana, boolean leftFacing, InputProcessor inputProcessor) {
    _maxHealth = maxHealth;
    _maxMana = maxMana;
    _leftFacing = leftFacing;
    x = 100;
    y = 100;
    _inputProcessor = inputProcessor;
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
    
    ArrayList<Integer> word = _inputProcessor.getNextWord();  
    if(word != null) {
      for(Spell spell : spellBook) {
        if(checkForMatch(spell, word)) {
          spell.inkove(this);
          break;
        }
      }
    } 
  }
  
  void render() {
    super.render();
    wizardStandingAnimation.drawAnimation(x - 32, y - 32, 64, 64);
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
  }
  
  void hurt(float damage) {
    health -= damage;
  }
  
  boolean checkForMatch(int[] spellSeq, ArrayList<Integer> word) {
    if(spellSeq.length != word.size()) {
      return false;
    }
    for(int i = 0; i < spellSeq.length; i ++) {
      if(spellSeq[i] != word.get(i)) {
        return false;
      }
    }
    return true;
  }
  
  Animation wizardStandingAnimation;
}

SpriteSheet wizardStandingSheet;
