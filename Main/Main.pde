//Donot play 1080 and mkv
import processing.video.*;

MoviePlayer mov;
PApplet mySketch;

void setup() {
  fullScreen();

  mySketch = this;
  mov = new MoviePlayer();
}

void draw() {
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

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getName());
    mov.player.updateMovie(selection.getAbsolutePath());
    mov.initActivity('p');
  }
}

String getNameFromPath(String path) {
  String[] name = splitTokens(path, "\\/");
  // println(name[name.length-1]);
  return(name[name.length-1]);
}