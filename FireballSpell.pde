class FireballSpell extends Spell {
  
  public void invoke(Wizard owner) {
    Fireball fireball = new Fireball(owner.x, owner.y, 10, 0, owner);
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
  
  }
}

