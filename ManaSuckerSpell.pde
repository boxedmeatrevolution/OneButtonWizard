class ManaSucker extends Summon {
  
  float lifetime = 15.0;
  float timer = 0.0;
  int shotsFired = -5;
  float timePerShot = 2.0;
  Wizard target = null;
  Wizard owner;
  
  ManaSucker(float x_, float y_, Wizard owner_) {
    super(x_, y_, 32.0f, 0.0f, 1.0f);
    
    if (suckerShotSpritesheet == null) {
      manaSuckerSpritesheet = loadSpriteSheet("/assets/mana_suck.png", 3, 1, 200, 200);
    }
    manaSuckerAnimation = new Animation(manaSuckerSpritesheet, 0.15, 0, 1, 2);
    
    owner = owner_;
    for (Entity entity : entities) {
      if (entity instanceof Wizard) {
        if (entity != owner_) {
          target = entity;
        }
      }
    }
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
    if (other instanceof ManaSucker) {
      if (other.timer > this.timer) {
        removeEntity(other);
      }
      else {
        removeEntity(this);
      }
    }
    if (other instanceof ManaSuckerShot) {
      removeEntity(other);
      target._mana -= 15.0f;
      if (target._mana < 0.0) {
        target._mana = 0.0;
      }
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
    if (owner.x < 500) {    
      manaSuckerAnimation.drawAnimation(x - 100, y - 100, 200, 200);
    } else {
      scale(-1, 1);
      manaSuckerAnimation.drawAnimation(x, y, 200, 200);
      scale(-1, 1);
    }
//    fill(255, 255, 0);
//    ellipse(x, y, 2 * radius, 2 * radius);
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    manaSuckerAnimation.update(delta);
    timer += delta;
    if (timer > lifetime) {
      removeEntity(this);
    }
    if (timer > (shotsFired + 1) * timePerShot && target != null) {
      if (shotsFired > 0 && shotsFired < 4) {
        velocityX_ = (x - target.x) / 3;
        velocityY_ = (y - target.y) / 3;
        shot = new ManaSuckerShot(target.x, target.y, velocityX_, velocityY_);
        addEntity(shot);
      }
      shotsFired += 1;
    }
  }
  
  int depth() {
    return 0;
  }
  
  Animation manaSuckerAnimation;
}

class ManaSuckerSpell extends Spell {
  
  int[] combination = new int[] { 1, 1, 0 };
  
  public ManaSuckerSpell() {
  }
  
  public String name() {
    return "Summon Mana Leech";
  }
  
  public void invoke(Wizard owner) {
    float _x = 260.0f;
    if (owner.x > width / 2) {
      _x = width - _x;
    }
    addEntity(new ManaSucker(_x, 160.0f, owner));
  }
  
  public float getManaCost() {
    return 10.0f;
  }
  
  public int[] getCombination() {
    return combination;
  }
  
}

class ManaSuckerShot extends Collider {
  
  public ManaSuckerShot(float x_, float y_, float velocityX_, float velocityY_) {
    super(x_, y_, 20.0, 0.0);
    this.velocityX = velocityX_;
    this.velocityY = velocityY_;
  }
  
  void onCollision(Collider other, boolean wasHandled) {
    super.onCollision(other, wasHandled);
  }
  
  void create() {
    super.create();
    if (suckerShotSpritesheet == null) {
      suckerShotSpritesheet = loadSpriteSheet("/assets/manaOrb.png", 2, 1, 150, 150);
    }
    suckerShotAnimation = new Animation(suckerShotSpritesheet, 0.05, 0, 1);
  }
  
  void destroy() {
    super.destroy();
  }
  
  void render() {
    super.render();
    float xr = x - 20;
    float xy = y - 20;
    float size = 150;
    
    if(velocityX < 0) {
      scale(-1, 1);
      xr = -((x - 128) + 256);
    }
    
    suckerShotAnimation.drawAnimation(xr, xy, size, size);
     
    if (velocityX < 0) {
      scale(-1, 1);
    }    
  }
  
  void update(int phase, float delta) {
    super.update(phase, delta);
    suckerShotAnimation.update(delta);
  }
  
  int depth() {
    return 0;
  }
  
  Animation suckerShotAnimation;
  
}

SpriteSheet suckerShotSpritesheet;
SpriteSheet manaSuckerSpritesheet;

