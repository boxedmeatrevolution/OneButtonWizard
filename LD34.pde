int lastUpdate = millis();
float timeDelta;

void setup () {
  size(600, 600);
}

void draw () {  
  int now = millis();
  timeDelta = (now - lastUpdate) / 1000.0f;
  lastUpdate = now;
}

void mousePressed() {
}

void mouseReleased() {
}

void mouseDragged() {
}
