import processing.video.*;

MoviePlayer mov;

PApplet mySketch;
String sketchPath;

void setup() {
  fullScreen();
  sketchPath = sketchPath()+"/vids/";


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

void initMovie() {
  mov.player.movieName = getNameFromPath(mov.player.moviePath);
  // Load and play the video in a loop
  mov.player.movie = new Movie(mySketch, mov.player.moviePath);
}

String getNameFromPath(String path) {
  String[] name = splitTokens(path, "\\/");
  println(name[name.length-1]);
  return(name[name.length-1]);
}