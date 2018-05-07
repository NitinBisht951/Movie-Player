// A Simple Movie Player
// Do not try to play 1080p and mkv videos

import java.io.BufferedWriter;
import java.io.FileWriter;
import processing.video.*;

MoviePlayer mov;
PApplet mySketch;
String pathTextFile;
StringList pathLists = new StringList();

PFont GEORGIA_FONT;
PFont CALIBRI_FONT;

void setup() {
  fullScreen();
  pathTextFile = sketchPath()+"/path.txt";
  GEORGIA_FONT = createFont("Georgia", 32);
  CALIBRI_FONT = createFont("Calibri", 32);
  
  moviePathsInit();

  mySketch = this;
  mov = new MoviePlayer();
}

void draw() {
  mov.start();
}

void moviePathsInit() {
  // first check whether the path.txt exists or not
  // if it doesn't create one
  checkFileExistence(pathTextFile);
  pathLists.append(loadStrings(dataPath(pathTextFile)));
  verifyPaths(pathLists);
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
  if (doesAlreadyExist(pathLists, newMoviePath)) {
    pathLists.append(newMoviePath);
    saveData(pathTextFile, pathLists.get(0), false);
    for (int i = 1; i < pathLists.size(); i++) saveData(pathTextFile, pathLists.get(i), true);
  } else {
    pathLists.append(newMoviePath);
    saveData(pathTextFile, newMoviePath, true);
  }
  mov.canvasUpdate();
  mov.playerUpdateMovie(this, newMoviePath);
  mov.initActivity('p');
}

/* --------------------------------------------------------------
 checks whether the path text file exists or not, if not,
 then create one with the given name
 filePath = path of the text file
 --------------------------------------------------------------
 */
void checkFileExistence(String filePath) {
  if (new File(dataPath(filePath)).exists()) {
    println(dataPath(filePath));
  } else {
    createWriter(filePath);
  }
}

/* --------------------------------------------------------------
 verifies whether all files listed in the path.txt file have not
 been deleted, if it has been, remove its all appearances from the text file
 pList = list of the paths in the text file
 --------------------------------------------------------------
 */
void verifyPaths(StringList pList) {
  boolean somethingDeleted = false;
  for (int i = 0; i < pList.size(); i++) {
    if (!(new File(dataPath(pList.get(i))).exists())) {
      println(dataPath(pList.get(i))+" doesn't exist!!\n Deleting it");
      pList.remove(i);
      i--;
      somethingDeleted = true;
    }
  }
  if (somethingDeleted) {
    saveData(pathTextFile, pList.get(0), false);
    for (int i = 1; i < pList.size(); i++) saveData(pathTextFile, pList.get(i), true);
  }
}

/* --------------------------------------------------------------
 checks whether newly opened file path already exists in the path.txt file
 if it does, remove its all appearances from the text file
 pList = list of the paths in the text file
 newPath = path of the newly opened movie
 --------------------------------------------------------------
 */
boolean doesAlreadyExist(StringList pList, String newPath) {
  if (pList.hasValue(newPath)) {
    for (int i = 0; i < pList.size(); i++) {
      String[] stringArray = pList.array();
      //print(i, parent.size());
      //println(",", getNameFromPath(stringArray[i]), getNameFromPath(parent.get(i)));
      if (stringArray[i].equals(newPath)) {
        pList.remove(i);
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
        e.printStackTrace();
      }
    }
  }
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
