class MeteorShowerSpell extends Spell {
  
  int[] combination = new int[] { 1, 0, 0, 0, 1};
  
  public MeteorShowerSpell() {
  }
  
  public void invoke(Wizard owner) {
    addEntity(new MeteorShower(owner));
  }
  
  public float getManaCost() {
    return 40.0f;
  }
  
  public int[] getCombination() {
    return combination;
  }
}

