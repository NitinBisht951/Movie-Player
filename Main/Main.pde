// A Simple Movie Player
// Do not try to play 1080p and mkv videos

import java.io.BufferedWriter;
import java.io.FileWriter;
import processing.video.*;

MoviePlayer mov;
PApplet mySketch;
PathManager pathManager;
StringList pathLists = new StringList();

PImage background;

PFont LEXIA_FONT;
PFont SEGOEUI_FONT;
PFont COURIER_FONT;

void setup() {
  fullScreen();
  mySketch = this;

  background = loadImage("wall.jpg");
  COURIER_FONT = loadFont("CourierNewPS-BoldMT-32.vlw");
  LEXIA_FONT = loadFont("Lexia-Regular-32.vlw");
  SEGOEUI_FONT = loadFont("SegoeUI-Bold-32.vlw");

  pathManager = new PathManager();
  pathManager.init();
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

void movieSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String newMoviePath = selection.getAbsolutePath();
    boolean validFormat = hasExtension(newMoviePath, ".mp4") || hasExtension(newMoviePath, ".webm") || hasExtension(newMoviePath, ".avi") 
      || hasExtension(newMoviePath, ".mov") || hasExtension(newMoviePath, ".flv") || hasExtension(newMoviePath, ".wmv");
    if (validFormat) {
      println("\nUser selected " + selection.getName()+"\n");
      openNewMovie(newMoviePath);
    } else {
      println("\nINVALID VIDEO FORMAT\n");
    }
  }
}

void subtitleSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    String subtitlePath = selection.getAbsolutePath();
    boolean validFormat = hasExtension(subtitlePath, ".srt");
    if (validFormat) {
      println("\nUser selected " + selection.getName()+"\n");
      mov.playerUpdateSubtitle(subtitlePath);
    } else {
      println("\nINVALID FORMAT\n");
    }
  }
}

void openNewMovie(String newMoviePath) {
  pathManager.openMovie(newMoviePath);
}

// Spits out the file name from the absolute path of the file
String getNameFromPath(String path) {
  String[] name = splitTokens(path, "\\/");
  // println(name[name.length-1]);
  return(name[name.length-1]);
}

// returns time given in seconds in formatted form of hh:mm:ss
String formatTime(int time) {
  String stime = null;
  int hour = time/3600;
  int min = (time - hour*3600)/60;
  int sec = (time - hour*3600 - min*60);
  stime = nf(hour, 2)+":"+nf(min, 2)+":"+nf(sec, 2);
  return stime;
}

boolean hasExtension(String name, String extension) {
  name = name.toLowerCase();
  extension = extension.toLowerCase();
  if ((name.substring(name.length()-extension.length())).equals(extension)) return true;
  else return false;
}

String removeExtension(String string) {
  return string.substring(0, string.length()-4);
}
