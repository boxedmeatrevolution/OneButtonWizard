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

Wizard player1;
//Wizard player2;
WizardAI player2;

void setup () {  
  InputProcessor input1 = new InputProcessor('z');
  InputProcessor input2 = new InputProcessor('.');
  
  inputProcessors.add(input1);
  inputProcessors.add(input2);
  
  size(1000, 680); 
  player1 = new Wizard(100, 500, 100, 100, false, input1);
  player2 = new WizardAI(width - 100, 500, 100, 100, true, input2);
  addEntity(player1);
  addEntity(player2);
  backgroundImage = loadImage("/assets/desert_background.png");
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
  
  player1HealthPercent = player1._health / player1._maxHealth;
  player1ManaPercent = player1._mana / player1._maxMana;
  player2HealthPercent = player2._health / player2._maxHealth;
  player2ManaPercent = player2._mana / player2._maxMana;
  
  fill(255, 0, 0);
  rect(10, 10, (width / 2 - 20) * player1HealthPercent, 40);
  rect(width / 2 + 10, 10, (width / 2 - 20) * player2HealthPercent, 40);
  
  fill(0, 0, 255);
  rect(10, 60, (width / 2 - 20) * player1ManaPercent, 20);
  rect(width / 2 + 10, 60, (width / 2 - 20) * player2ManaPercent, 20);
  
  ArrayList<Integer> player1Word = new ArrayList<Integer>(player1._inputProcessor.getCurrentWord());
  ArrayList<Integer> player2Word = new ArrayList<Integer>(player2._inputProcessor.getCurrentWord());
  
  int currentX = 20;
  if (player1._inputProcessor._inputState == player1._inputProcessor.WAITING_FOR_KEY_UP || player1._inputProcessor._inputState == player1._inputProcessor.WAITING_FOR_KEY_DOWN) {
    if (player1._inputProcessor._inputState == player1._inputProcessor.WAITING_FOR_KEY_UP) {
      if (player1._inputProcessor._stateTimer <= player1._inputProcessor.DOT_TIME) {
        player1Word.add(0);
      }
      else if (player1._inputProcessor._stateTimer <= player1._inputProcessor.DASH_TIME) {
        player1Word.add(1);
      }
    }
    for (Integer letter : player1Word) {
      if (letter == 0) {
        fill(0, 255, 0);
      }
      else if (letter == 1) {
        fill(255, 0, 0);
      }
      ellipse(currentX, 100, 20, 20);
      currentX += 40;
    }
  }
  
  if (player2._inputProcessor._inputState == player2._inputProcessor.WAITING_FOR_KEY_UP || player2._inputProcessor._inputState == player2._inputProcessor.WAITING_FOR_KEY_DOWN) {
    if (player2._inputProcessor._inputState == player2._inputProcessor.WAITING_FOR_KEY_UP) {
      if (player2._inputProcessor._stateTimer <= player2._inputProcessor.DOT_TIME) {
        player2Word.add(0);
      }
      else if (player2._inputProcessor._stateTimer <= player2._inputProcessor.DASH_TIME) {
        player2Word.add(1);
      }
    }
    currentX = width - 20;
    for (Integer letter : player2Word) {
      if (letter == 0) {
        fill(0, 255, 0);
      }
      else if (letter == 1) {
        fill(255, 0, 0);
      }
      ellipse(currentX, 100, 20, 20);
      currentX -= 40;
    }
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
