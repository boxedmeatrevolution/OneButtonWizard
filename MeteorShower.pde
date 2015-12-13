class MeteorShower extends Entity {
  
  int TOTAL_METEORS = 8;
  
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
    if(timer > 1) {
      timer = 0;
      if(!_owner._leftFacing) {
        addEntity(new Meteor(_owner.x + (width / 12)*meteorCount, 0, 40, 150, _owner));     
       console.log("facing right");   
      } else {
        addEntity(new Meteor(_owner.x - (width / 12)*meteorCount, 0, -40, 150, _owner));   
       console.log("facing left");   
      }
      meteorCount ++;
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
  
  public Meteor(float x_, float y_, float velocityX_, float velocityY_, Wizard owner) {
    super(x_, y_, 40.0, 0.0, 0.0, owner);
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
  }
  
  void destroy() {
    super.destroy();
  }
  
  void render() {
    super.render();
    fill(255, 50, 50);
    ellipse(x, y, radius / 2, radius / 2);
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    
    if(y > height) {
      removeEntity(this);
    }
  }
  
  int depth() {
    return 0;
  }
  
}

