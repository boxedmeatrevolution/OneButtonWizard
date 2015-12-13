class FireballSpell extends Spell {
  
  int[] combination = new int[] { 0 };
  
  public FireballSpell() {
  }
  
  public void invoke(Wizard owner) {
    console.log("invoked");
    Fireball fireball = new Fireball(owner.x, owner.y, 100, 0, owner);
    if (owner.x < width / 2) {
      fireball.x += 10;
    }
    else {
      fireball.x -= 10;
      fireball.velocityX *= -1;
    }
    addEntity(fireball);
  }
  
  public float getManaCost() {
    return 10.0f;
  }
  
  public int[] getCombination() {
    return combination;
  }
}

