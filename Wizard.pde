class Wizard {
  float maxHealth;
  float maxMana;
  float health;
  float mana;
  
  Wizard(float _maxHealth, float _maxMana) {
    maxHealth = _maxHealth;
    maxMana = _maxMana;
  }
  
  void update() {
  
  }
  
  void damage(float damage) {
    health -= damage;
  }
}

