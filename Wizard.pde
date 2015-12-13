class Wizard extends Collider{
  float _maxHealth;
  float _maxMana;
  float _health;
  float _mana;
  final float MANA_REGEN_RATE = 0.0;
  boolean phased = false;
  float phaseTimer = 0.0;
  
  float hurtTimer = 0;
  float castTimer = 0;
  
  boolean stunned = false;
  float stunTimer = 0.0f;
  
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
    spellBook.add(new ReflectorSpell());
    spellBook.add(new MeteorShowerSpell());
    spellBook.add(new HealthSpell());
    spellBook.add(new GravityWellSpell());
    spellBook.add(new ManaSpell());
    spellBook.add(new PiercerSpell());
    spellBook.add(new RapidShotSpell());
    spellBook.add(new PhaseSpell());
    spellBook.add(new ZappyOrbSpell());
    spellBook.add(new ManaSuckerSpell());
    spellBook.add(new GustSpell());    
  }
  
  void create() {
    super.create();
    if (characterSpritesheet == null) {
      characterSpritesheet = loadSpriteSheet("/assets/character_spritesheet.png", 5, 5, 250, 250);
    }
    wizardStandingAnimation = new Animation(characterSpritesheet, 0.25, 0, 1);
    wizardCastPrepAnimation = new Animation(characterSpritesheet, 0.2, 2);
    wizardCastingAnimation = new Animation(characterSpritesheet, 0.2, 3);
    wizardHurtAnimation = new Animation(characterSpritesheet, 0.2, 4);
    wizardWinAnimation = new Animation(characterSpritesheet, 0.2, 5, 6, 7, 8);
    wizardLoseAnimation = new Animation(characterSpritesheet, 0.2, 9, 10);
    wizardFadeAnimation = new Animation(characterSpritesheet, 0.25, 13, 12);
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    
    hurtTimer -= delta;
    castTimer -= delta;
    if (phased) {
      phaseTimer -= delta;
      if (phaseTimer < 0.0f) {
        phased = false;
      }
    }
    
    if (stunned) {
      stunTimer -= delta;
      if (stunTimer < 0.0f) {
        stunned = false;
        _inputProcessor.canInput = true;
      }
    }
    
    wizardFadeAnimation.update(delta);
    wizardStandingAnimation.update(delta);
    if (!phased) {
      _mana += MANA_REGEN_RATE * delta;
    }
    if (_mana > _maxMana) {
      _mana = _maxMana;
    }
    
    ArrayList<Integer> word = _inputProcessor.getNextWord();  
    if(word != null) {
      for(Spell spell : spellBook) {
        if(checkForMatch(spell.getCombination(), word) <= _mana && !phased) {
          castTimer = 0.25;
          _mana -= spell.getManaCost();
          spell.invoke(this);
          if (_mana < 0.0f) {
            _mana = 0.0f;
            _inputProcessor.canInput = false;
            stunned = true;
            stunTimer = 3.0f;
          }
          break;
        }
      }
    } 
  }
  
  void render() {
    super.render();
    float xr = x - 128;
    float xy = y - 128;
    float size = 256;
    
    if(_leftFacing) {
      scale(-1, 1);
      xr = -((x - 128) + 256);
    }
    
    if (phased) {
      wizardFadeAnimation.drawAnimation(xr, xy, size, size);
    } else if (_inputProcessor._inputState == 1 || _inputProcessor._inputState == 2) {
      wizardCastPrepAnimation.drawAnimation(xr, xy, size, size);
    } else if (hurtTimer > 0) {
     wizardHurtAnimation.drawAnimation(xr, xy, size, size);
    } else if (castTimer > 0) {
     wizardCastingAnimation.drawAnimation(xr, xy, size, size); 
    } else {
      wizardStandingAnimation.drawAnimation(xr, xy, size, size);
    }
    
    if (_leftFacing) {
      scale(-1, 1);
    }    
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
  }
  
  void hurt(float damage) {
    if (!phased) {
      _health -= damage;
      hurtTimer = 0.25;
    }
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
  Animation wizardCastPrepAnimation;
  Animation wizardHurtAnimation;
  Animation wizardWinAnimation;
  Animation wizardLoseAnimation;
  Animation wizardFadeAnimation;
}

SpriteSheet characterSpritesheet;
