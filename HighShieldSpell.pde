class HighShieldSpell extends Spell {
  
  int[] combination = new int[] { 1, 1 };
  
  public HighShieldSpell() {
  }
  
  public void invoke(Wizard owner) {
    console.log("invoked");
    Shield shieldC = new Shield(owner.x, owner.y - 50, 0, -100, owner);
    if (owner.x < width / 2) {
      
    }
    else {
      shieldC.velocityX = -shieldC.velocityX;
    }
    addEntity(shieldC);
  }
  
  public float getManaCost() {
    return 20.0f;
  }
  
  public int[] getCombination() {
    return combination;
  }
}
