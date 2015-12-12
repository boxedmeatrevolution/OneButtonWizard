class Spell {
  
  public abstract void invoke(Wizard owner) {
  }
  
  public abstract double getManaCost() {
    return 1.0;
  }
  
  public abstract int[] getCombination() {
    return null;
  }
  
}

