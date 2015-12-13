class Wizard extends Collider{
  float _maxHealth;
  float _maxMana;
  float _health;
  float _mana;
  final float MANA_REGEN_RATE = 2.0;
  
  boolean _leftFacing;
  ArrayList<Spell> spellBook = new ArrayList<Spell>();
  
  InputProcessor _inputProcessor;
  
  Wizard(float x_, float y_, float maxHealth, float maxMana, boolean leftFacing, InputProcessor inputProcessor) {
    super(x_, y_, 100, 0);
    _maxHealth = maxHealth;
    _maxMana = maxMana;
    _leftFacing = leftFacing;
    _health = _maxHealth;
    _mana = _maxMana;
    _inputProcessor = inputProcessor;
    spellBook.add(new FireballSpell());
    spellBook.add(new HighFireballSpell());
    spellBook.add(new ShieldSpell());
    spellBook.add(new MeteorShowerSpell());
    spellBook.add(new HealthSpell());
    spellBook.add(new GravityWellSpell());
    spellBook.add(new ManaSpell());
  }
  
  void create() {
    super.create();
    if (characterSpritesheet == null) {
      characterSpritesheet = loadSpriteSheet("/assets/character_spritesheet.png", 5, 5, 250, 250);
    }
    wizardStandingAnimation = new Animation(characterSpritesheet, 0.25, 0, 1);
    wizardCastingAnimation = new Animation(characterSpritesheet, 0.2, 2, 2);
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    wizardStandingAnimation.update(delta);
    _mana += MANA_REGEN_RATE * delta;
    if (_mana > _maxMana) {
      _mana = _maxMana;
    }
    
    ArrayList<Integer> word = _inputProcessor.getNextWord();  
    if(word != null) {
      for(Spell spell : spellBook) {
        console.log("checking spell match");
        if(checkForMatch(spell.getCombination(), word) && spell.getManaCost() <= _mana) {
          _mana -= spell.getManaCost();
          spell.invoke(this);
          console.log("spell invoked");
          break;
        }
      }
    } 
  }
  
  void render() {
    super.render();
    if(_leftFacing) {
      scale(-1, 1);
      if (_inputProcessor._inputState == 1 || _inputProcessor._inputState == 2) {
        wizardCastingAnimation.drawAnimation(-((x - 128) + 256), y - 128, 256, 256);
      } else {
        wizardStandingAnimation.drawAnimation(-((x - 128) + 256), y - 128, 256, 256);
      }
      scale(-1, 1);
    } else {
      if (_inputProcessor._inputState == 1 || _inputProcessor._inputState == 2) {
        wizardCastingAnimation.drawAnimation(x - 128, y - 128, 256, 256);
      } else {
        wizardStandingAnimation.drawAnimation(x - 128, y - 128, 256, 256);
      }
    }
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
  Animation wizardCastingAnimation;
}

SpriteSheet characterSpritesheet;
