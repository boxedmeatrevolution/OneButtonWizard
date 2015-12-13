/* @pjs preload="/assets/standing.png, /assets/desert_background.png; */
class Entity {
  // Called when the entity is added to the game
  void create() {}
  // Called when the entity is removed from the game
  void destroy() {}
  // Called whenever the entity is to be rendered
  void render() {}
  // Called when the entity is to be updated
  void update(int phase, float delta) {}
  // The order in the render and update list of the entity
  int depth() {
    return 0;
  }
  boolean exists = false;
}

ArrayList<InputProcessor> inputProcessors = new ArrayList<InputProcessor>();

ArrayList<Entity> entities = new ArrayList<Entity>();
ArrayList<Entity> entitiesToBeAdded = new ArrayList<Entity>();
ArrayList<Entity> entitiesToBeRemoved = new ArrayList<Entity>();
ArrayList<Collider> colliders = new ArrayList<Collider>();

int firstUpdatePhase = 0;
int lastUpdatePhase = 0;

int lastUpdate = millis();
float timeDelta;

PGraphics backgroundImage;

void addEntity(Entity entity) {
  entitiesToBeAdded.add(entity);
}

void removeEntity(Entity entity) {
  entitiesToBeRemoved.add(entity);
}

void sortEntities() {
  for (int i = 1; i < entities.size(); ++i) {
    Entity x = entities.get(i);
    int j = i;
    while (j > 0 && entities.get(j - 1).depth() < x.depth()) {
      entities.set(j, entities.get(j - 1));
      j -= 1;
    }
    entities.set(j, x);
  }
}

void setup () {
  size(1000, 680); 
  Wizard player = new Wizard(111, 111, false);  
  addEntity(player);
  backgroundImage = loadImage("/assets/desert_background.png");
  
  inputProcessors.add(new InputProcessor('z'));
}

void draw () {    
  
  image(backgroundImage, 0, 0);
  
  int now = millis();
  timeDelta = (now - lastUpdate) / 1000.0f;
  lastUpdate = now;

  for(InputProcessor ip : inputProcessors) {     
    ip.update(timeDelta);
    /*ArrayList<Integer> word = ip.getNextWord();
    if(word != null) {
      String sequence = "";
      for(Integer i : word) {
        sequence += i;
      }
      console.log(sequence);
    }*/
  }
  
  // Add entities in the add queue
  for (Entity entity : entitiesToBeAdded) {
    entities.add(entity);
    if (entity instanceof Collider) {
      colliders.add(entity);
    }
    entity.exists = true;
    entity.create();
  }
  // Remove entities in the remove queue
  for (Entity entity : entitiesToBeRemoved) {
    entities.remove(entity);
    if (entity instanceof Collider) {
      colliders.remove(entity);
    }
    entity.exists = false;
    entity.destroy();
  }
  entitiesToBeAdded.clear();
  entitiesToBeRemoved.clear();
  // Entities are sorted by depth
  sortEntities();
  for (int updatePhase = firstUpdatePhase; updatePhase <= lastUpdatePhase; ++updatePhase) {
    // Update every entity
    for (Entity entity : entities) {
      entity.update(updatePhase, timeDelta);
    }
    // Find and handle collisions
    if (updatePhase == 0) {
      for (int i = 0; i < colliders.size() - 1; ++i) {
        Collider first = colliders.get(i);
        for (int j = i + 1; j < colliders.size(); ++j) {
          Collider second = colliders.get(j);
          if (first.collides(second)) {
            first.onCollision(second, false);
            second.onCollision(first, true);
          }
        }
      }
    }
  }
  // Render every entity
  for (Entity entity : entities) {
    entity.render();
  }
}
  
void keyPressed() {
  for(InputProcessor ip : inputProcessors) {    
    ip.keyPressed();
  }
}

void keyReleased() {
  for(InputProcessor ip : inputProcessors) {    
    ip.keyReleased();
  }
}

void mousePressed() {
}

void mouseReleased() {
}

void mouseDragged() {
}
