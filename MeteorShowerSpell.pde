class MeteorShowerSpell extends Spell {
  
  int[] combination = new int[] { 1, 1, 1 };
  
  public MeteorShowerSpell() {
  }
  
  public String name() {
    return "Meteor Shower";
  }
  
  public void invoke(Wizard owner) {
    addEntity(new MeteorShower(owner));
  }
  
  public float getManaCost() {
    return 10.0f;
  }
  
  public int[] getCombination() {
    return combination;
  }
}
class MeteorShower extends Entity {
  
  int TOTAL_METEORS = 10;
  
  int meteorCount;
  float timer;
  Wizard _owner;
  
  public MeteorShower(Wizard owner) {
    super(0, 0, 0, 0.0, 0.0, owner);
    meteorCount = 0;
    timer = 0;
    _owner = owner;
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
  }
  
  void create() {
    super.create();
  }
  
  void destroy() {
    super.destroy();
  }
  
  void render() {
    super.render();
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    timer += delta;
    if(timer > 0.5) {
      timer = 0;
      meteorCount ++;
      if(!_owner._leftFacing) {
        addEntity(new Meteor(_owner.x + (width / 12)*meteorCount, 0, 0, 150, _owner));   
      } else {
        addEntity(new Meteor(_owner.x - (width / 12)*meteorCount, 0, 0, 150, _owner));   
      }
    }
    if(meteorCount >= TOTAL_METEORS) {
      removeEntity(this);
    }
  }
  
  int depth() {
    return 0;
  }
  
}

class Meteor extends Hazard {
  
  float accelerationY = 400;
  
  public Meteor(float x_, float y_, float velocityX_, float velocityY_, Wizard owner) {
    super(x_, y_, 80.0, 0.0, 0.0, owner);
    this.damage = 2.0f;
    this.velocityX = velocityX_;
    this.velocityY = velocityY_;
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
    if (triggered) {
      removeEntity(this);
    }
  }
  
  void create() {
    super.create();
    if (meteorSpritesheet == null) {
      meteorSpritesheet = loadSpriteSheet("/assets/meteor.png", 2, 1, 250, 250);
    }
    meteorAnimation = new Animation(meteorSpritesheet, 0.25, 0, 1);
  }
  
  void destroy() {
    super.destroy();
  }
  
  void render() {
    super.render();
    if (velocityY < 0) {
      scale(1, -1);
    }
    meteorAnimation.drawAnimation(x - 125, y - 125, 250, 250);
    if (velocityY < 0) {
      scale(1, -1);
    }
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    
    meteorAnimation.update(delta);
    velocityY += delta*accelerationY;
    
    if(y > height) {
      removeEntity(this);
    }
  }
  
  int depth() {
    return 0;
  }
  
  Animation fireballAnimation;
}

SpriteSheet meteorSpritesheet;
