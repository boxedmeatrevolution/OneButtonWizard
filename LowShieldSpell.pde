class LowShieldSpell extends Spell {
  
  int[] combination = new int[] { 1, 0 };
  
  public LowShieldSpell() {
  }
  
  public void invoke(Wizard owner) {
    console.log("invoked");
    Shield shieldA = new Shield(owner.x, owner.y, 100, 0, owner);
    if (owner.x < width / 2) {
      
    }
    else {
      shieldA.velocityX = -shieldA.velocityX;
    }
    addEntity(shieldA);
  }
  
  public float getManaCost() {
    return 20.0f;
  }
  
  public int[] getCombination() {
    return combination;
  }
}

