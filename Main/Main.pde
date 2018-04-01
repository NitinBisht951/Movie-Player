import processing.video.*;

MoviePlayer mov;

void setup() {
  fullScreen();
  mov = new MoviePlayer(this);
  mov.init();
}

void draw() {
  background(0);
  mov.start();
}

void movieEvent(Movie m) {
  m.read();
}

void mouseClicked() {
  mov.mouseClicked();
}

void keyPressed() {
  mov.keyPressed();
}

void mouseMoved() {
  mov.mouseMoved();
}
