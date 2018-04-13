//Donot play 1080 and mkv
import java.io.BufferedWriter;
import java.io.FileWriter;
import processing.video.*;

MoviePlayer mov;
PApplet mySketch;
String pathTextFile;
StringList pathLists = new StringList();

void setup() {
  fullScreen();

  pathTextFile = sketchPath()+"/path.txt";
  if (new File(dataPath(pathTextFile)).exists()) {
    println(dataPath(pathTextFile));
  } else {
    createWriter(pathTextFile);
  }
  pathLists.append(loadStrings(dataPath(pathTextFile)));
  
  pathLists.print();
  verifyPaths(pathLists);
  println("\n After changes");
  pathLists.print();

  mySketch = this;
  mov = new MoviePlayer();
}

void draw() {
  mov.start();
}

void verifyPaths(StringList list) {
  boolean somethingDeleted = false;
  for (int i = 0; i < list.size(); i++) {
    if (!(new File(dataPath(list.get(i))).exists())) {
      println(dataPath(list.get(i))+" doesn't exist!!\n Deleting it");
      list.remove(i);
      i--;
      somethingDeleted = true;
    }
  }
  if (somethingDeleted) {
    saveData(pathTextFile, list.get(0), false);
    for (int i = 1; i < list.size(); i++) saveData(pathTextFile, list.get(i), true);
  }
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
    String newMoviePath = selection.getAbsolutePath();
    println("\nUser selected " + selection.getName()+"\n");
    openNewMovie(newMoviePath);
  }
}

void openNewMovie(String newMoviePath) {
  if (isAlreadyExists(pathLists, newMoviePath)) {
    pathLists.append(newMoviePath);
    saveData(pathTextFile, pathLists.get(0), false);
    for (int i = 1; i < pathLists.size(); i++) saveData(pathTextFile, pathLists.get(i), true);
  } else {
    pathLists.append(newMoviePath);
    saveData(pathTextFile, newMoviePath, true);
  }
  mov.canvas.update();
  mov.player.updateMovie(newMoviePath);
  mov.initActivity('p');
}

boolean isAlreadyExists(StringList parent, String child) {
  if (parent.hasValue(child)) {
    for (int i = 0; i < parent.size(); i++) {
      String[] stringArray = parent.array();
      //print(i, parent.size());
      //println(",", getNameFromPath(stringArray[i]), getNameFromPath(parent.get(i)));
      if (stringArray[i].equals(child)) {
        parent.remove(i);
        i--;
        //print("del ");
      }
    }
    return true;
  } else return false;
}

/* --------------------------------------------------------------
 SaveData:
 - This code is used to create/append data to a designated file.
 - fileName = the location of the output data file (String)  
 - newData = the data to be stored in the file (String)
 - appendData = true if you want to append
 = false if you want to create a new file
 --------------------------------------------------------------*/
void saveData(String fileName, String newData, boolean appendData) {
  BufferedWriter bw = null;
  try {  
    FileWriter fw = new FileWriter(fileName, appendData);
    bw = new BufferedWriter(fw);
    bw.write(newData + System.getProperty("line.separator"));
  } 
  catch (IOException e) {
  } 
  finally {
    if (bw != null) {
      try { 
        bw.close();
      } 
      catch (IOException e) {
      }
    }
  }
}

String getNameFromPath(String path) {
  String[] name = splitTokens(path, "\\/");
  // println(name[name.length-1]);
  return(name[name.length-1]);
}