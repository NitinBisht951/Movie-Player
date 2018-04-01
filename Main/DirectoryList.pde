/**
 * Listing files in directories and subdirectories
 * by Daniel Shiffman.
 *
 * This example has two functions:
 * 1) List the names of files in a directory
 * 2) List the names along with metadata (size, lastModified)
 *    of files in a directory
 */

// This function returns all the files in a directory as an array of Strings
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
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
