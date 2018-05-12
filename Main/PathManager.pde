class PathManager {
  String pathTextFile;

  PathManager() {
    pathTextFile = sketchPath()+"/path.txt";
  }


  void init() {
    // first check whether the path.txt exists or not
    // if it doesn't create one
    checkFileExistence(pathTextFile);
    pathLists.append(loadStrings(dataPath(pathTextFile)));
    verifyPaths(pathLists);
  }

  void openMovie(String newMoviePath) {
    if (doesAlreadyExist(pathLists, newMoviePath)) {
      pathLists.append(newMoviePath);
      saveData(pathTextFile, pathLists.get(0), false);
      for (int i = 1; i < pathLists.size(); i++) saveData(pathTextFile, pathLists.get(i), true);
    } else {
      pathLists.append(newMoviePath);
      saveData(pathTextFile, newMoviePath, true);
    }
    mov.canvasUpdate();
    mov.playerUpdateMovie(mySketch, newMoviePath);
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
}
