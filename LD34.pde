/* @pjs preload="/assets/character_spritesheet.png, /assets/ui.png, /assets/mana_suck.png, /assets/shield.png, /assets/desert_background.png, /assets/blueFireball.png, /assets/meteor.png, /assets/gravityWell.png, /assets/healthOrb.png, /assets/manaOrb.png, /assets/spinningFireball.png, /assets/piercer.png, /assets/wind.png; */
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

int MENU_STATE = 0, GAME_START_STATE = 1, IN_GAME_STATE = 2, GAME_OVER_STATE = 3;
int state = 0;

ArrayList<Entity> entities = new ArrayList<Entity>();
ArrayList<Entity> entitiesToBeAdded = new ArrayList<Entity>();
ArrayList<Entity> entitiesToBeRemoved = new ArrayList<Entity>();
ArrayList<Collider> colliders = new ArrayList<Collider>();

int firstUpdatePhase = 0;
int lastUpdatePhase = 0;

int lastUpdate = millis();
float timeDelta;

PGraphics backgroundImage;
PImage userInterface;

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
Wizard player2;

int state = STATE_MAIN_MENU;

int STATE_PRE_DUEL = -1, STATE_DUEL = 0, STATE_POST_DUEL = 1, STATE_MAIN_MENU = 2, STATE_PRE_FIGHT = 3, STATE_FIGHT = 4, STATE_POST_FIGHT_LOSE = 5, STATE_POST_FIGHT_WIN = 6;

void cleanState() {
  entities.clear();
  entitiesToBeAdded.clear();
  entitiesToBeRemoved.clear();
  colliders.clear();
  inputProcessors.clear();
}

Wizard getFight(int n) {
  return new WizardAI(width - 100, 500, 50, 100, true, new InputProcessor('.'));
}

int currentFight = 0;

float timer = 10.0f;

void gotoMainMenuState() {
  state = STATE_MAIN_MENU;
}

void gotoPreDuelState() {
  
  state = STATE_PRE_DUEL;
  
  InputProcessor input1 = new InputProcessor('z');
  InputProcessor input2 = new InputProcessor('.');
  
  inputProcessors.add(input1);
  inputProcessors.add(input2);
  
  player1 = new Wizard(100, 500, 50, 100, false, inputProcessors.get(0));
  player2 = new Wizard(width - 100, 500, 50, 100, true, inputProcessors.get(1));
  
  addEntity(player1);
  addEntity(player2);
  
  timer = 3.0f;
}

void gotoDuelState() {
  state = STATE_DUEL;
  
  player1._inputProcessor.reset();
  player2._inputProcessor.reset();
  
  player1.preFight = false;
  player2.preFight = false;
}

void gotoPostDuelState() {
  state = STATE_POST_DUEL;
  
  player1.loser = player1._health < 0;
  player1.winner = !player1.loser;
  
  player2.loser = player2._health < 0;
  player2.winner = !player2.loser;
  
  timer = 3.0f;
}

void gotoPreFightState() {
  
  state = STATE_PRE_FIGHT;
  
  InputProcessor input1 = new InputProcessor('z');
  
  inputProcessors.add(input1);
  
  player1 = new Wizard(100, 500, 50, 100, false, inputProcessors.get(0));
  player2 = getFight(currentFight);
  
  addEntity(player1);
  addEntity(player2);
  
  timer = 3.0f;
}

void gotoFightState() {
  state = STATE_FIGHT;
  player1._inputProcessor.reset();
  
  player1.preFight = false;
  player2.preFight = false;
}

void gotoPostFightWinState() {
  state = STATE_POST_FIGHT_WIN;
  player1.winner = true;
  player1.loser = false;
  player2.winner = false;
  player2.loser = true;
  timer = 3.0f;
}

void gotoPostFightLoseState() {
  state = STATE_POST_FIGHT_LOSE;
  player1.winner = false;
  player1.loser = true;
  player2.winner = true;
  player2.loser = false;
  timer = 3.0f;
}

void setup () {  
  size(1000, 680);
  
  backgroundImage = loadImage("/assets/desert_background.png");
  userInterface = loadImage("/assets/ui.png");
  
  gotoMainMenuState();
}

void draw () {
  
  image(backgroundImage, 0, 0);
  
  int now = millis();
  timeDelta = (now - lastUpdate) / 1000.0f;
  lastUpdate = now;

  for(InputProcessor ip : inputProcessors) {     
    ip.update(timeDelta);
  }
  
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
  
  timer -= timeDelta;
  
  if (timer < 0.0f) {
    if (state == STATE_PRE_DUEL) {
      gotoDuelState();
    }
    else if (state == STATE_POST_DUEL) {
      cleanState();
      gotoMainMenuState();
    }
    else if (state == STATE_PRE_FIGHT) {
      gotoFightState();
    }
    else if (state == STATE_POST_FIGHT_WIN) {
      cleanState();
      currentFight += 1;
      gotoPreFightState();
    }
    else if (state == STATE_POST_FIGHT_LOSE) {
      cleanState();
      currentFight = 0;
      gotoMainMenuState();
    }
  }
  
  if (state == STATE_MAIN_MENU) {
    text("Main menu. Press 'z' to play duel mode. Press '.' to play single player.", 50, 50);
  }
  else if (state == STATE_PRE_DUEL || state == STATE_PRE_FIGHT) {
    if (timer >= 2.25) {
      text("3", 50, 50);
    }
    else if (timer >= 1.5) {
      text("2", 50, 50);
    }
    else if (timer >= 0.75) {
      text("1", 50, 50);
    }
    else {
      text("Fight!", 50, 50);
    }
  }
  else if (state == STATE_POST_FIGHT_LOSE) {
    text("You lose! Game over.", 50, 50);
  }
  else if (state == STATE_POST_FIGHT_WIN) {
    text("You win!", 50, 50);
  }
  else if (state == STATE_POST_DUEL) {
    if (player1.winner) {
      text("Player 1 wins!", 50, 50);
    }
    else if (player2.winner) {
      text("Player 2 wins!", 50, 50);
    }
    else {
      text("You both lose!", 50, 50);
    }
  }
  /*
  draw the ui
  */
  else if (state == STATE_DUEL || state == STATE_FIGHT) {
    
    player1HealthPercent = player1._health / player1._maxHealth;
    player1ManaPercent = player1._mana / player1._maxMana;
    player2HealthPercent = player2._health / player2._maxHealth;
    player2ManaPercent = player2._mana / player2._maxMana;
    
    fill(255, 0, 0);
    rect(32 + 5, 32, (width / 2 - 32 - 4 - 4) * player1HealthPercent, 64);
    rect(width / 2 + 5, 32, (width / 2 - 32 - 4 - 4) * player2HealthPercent, 64);
    
    fill(0, 0, 255);
    rect(32 + 5, 65, (width / 2 - 32 - 4 - 4) * player1ManaPercent, 32);
    rect(width / 2 + 5, 60, (width / 2 - 32 - 4 - 4) * player2ManaPercent, 32);
    
    image(userInterface, 0, 0);
    
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
    
    if (state == STATE_DUEL) {
      if (player1._health < 0 || player2._health < 0) {
        gotoPostDuelState();
      }
    }
    else if (state == STATE_FIGHT) {
      if (player1._health < 0) {
        gotoPostFightLoseState();
      }
      else if (player2._health < 0) {
        gotoPostFightWinState();
      }
    }
  
  }
  
}

void keyPressed() {
  if (state == STATE_DUEL || state == STATE_FIGHT) {
    for(InputProcessor ip : inputProcessors) {     
      ip.keyPressed();
    }
  }
  if (state == STATE_MAIN_MENU) {
    if (key == 'z') {
      cleanState();
      gotoPreDuelState();
    }
    else if (key == '.') {
      cleanState();
      gotoPreFightState();
    }
  }
}

void keyReleased() {
  if (state == STATE_DUEL || state == STATE_FIGHT) {
    for(InputProcessor ip : inputProcessors) {     
      ip.keyReleased();
    }
  }
}

void mousePressed() {
}

void mouseReleased() {
}

void mouseDragged() {
}
