class FireballRushAI extends Wizard {
  int timer = 0;
  
  int comboChain;
  int rechargeOrbs;
  
  FireballRushAI(float x_, float y_, float maxHealth, float maxMana, boolean leftFacing, InputProcessor inputProcessor) {
    super(x_, y_, maxHealth, maxMana, leftFacing, inputProcessor);
    comboChain = 0;
    rechargeOrbs = 0;
  }
  
  void create() {
    super.create();
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    timer += delta;  
    if (timer > 1.0) {
      timer = 0;
      console.log(spellBook.size());
      if (spellBook.size() > 0) {
        boolean spellInvoked = false;
        if(comboChain == 0) {
          for(Spell spell : spellBook) {
            if (spell.name() == "Fireball" && spell.getManaCost() < _mana && !winner && !loser && !stunned && !phased) {
              _mana -= spell.getManaCost();
              spell.invoke(this);
              spellInvoked = true;
              comboChain = 1;
            }
          }
        } else if (comboChain == 1) {
          for(Spell spell : spellBook) {
            if (spell.name() == "Gust" && spell.getManaCost() < _mana && !winner && !loser && !stunned && !phased) {
              _mana -= spell.getManaCost();
              spell.invoke(this);
              spellInvoked = true;
              comboChain = 2;
            }
          }
        } else if (comboChain != -1){          
          for(Spell spell : spellBook) {
            if (spell.name() == "Bubble Shield" && spell.getManaCost() < _mana && !winner && !loser && !stunned && !phased) {
              _mana -= spell.getManaCost();
              spell.invoke(this);
              spellInvoked = true;
              comboChain = 0;
            }
          }
        }
        if(!spellInvoked) {
          comboChain = -1;
          for(Spell spell : spellBook) {
            if (spell.name() == "Mana Orb" && spell.getManaCost() < _mana && !winner && !loser && !stunned && !phased) {
              spell.invoke(this);
            }
          }
          rechargeOrbs ++;
          
          if(rechargeOrbs > 6) {
            rechargeOrbs = 0;
            comboChain = 0;
          }
        }
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
}
