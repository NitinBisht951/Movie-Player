//this class is a holder for videoDisplayer showcasing
class VideosListBox {
  private VideoDisplayer[] videoDisplayer = new VideoDisplayer[NO_OF_VIDS];
  private int activeVideoIndex = 0;

  VideosListBox(float offsetX, float offsetY) {
    for (int i = 0; i < NO_OF_VIDS; i++) {
      int col = i % NO_OF_COLS;
      int row = (i - col)/NO_OF_ROWS;
      float x = offsetX + col*(VID_DISPLAYER_WIDTH + CANVAS_MARGIN);
      float y = offsetY + row*(VID_DISPLAYER_HEIGHT + CANVAS_MARGIN);
      videoDisplayer[i] = new VideoDisplayer("Title"+i, "Path", new PVector(x, y));
    }
    update();
  }

  void draw() {
    for (int i = 0; i < NO_OF_VIDS; i++) {
      boolean isActive = (activeVideoIndex==i);
      videoDisplayer[i].draw(isActive);
    }
  }

  void update() {
    int tempSize = pathLists.size();
    for (int i = 0; i < NO_OF_VIDS; i++) {
      if (i == tempSize) return;
      videoDisplayer[i].updateVideo(pathLists.get(tempSize-i-1));
    }
  }

  void mouseMoved() {
    activeVideoIndex = getVideoIndexMouseIsOver();
  }

  void mouseClicked() {
    for (int i = 0; i < NO_OF_VIDS; i++) {
      if (videoDisplayer[i].isEmpty()) return;
      if (videoDisplayer[i].playButtonClicked()) {
        openVideoAtIndex(i);
        break;
      } else if (videoDisplayer[i].removeButtonClicked()) {
        removeVideoAtIndex(i);
        break;
      } 
      //else if (videoDisplayer[i].previewButtonClicked()) {
      //  previewVideoAtIndex(i);
      //  break;
      //}
    }
  }

  void keyPressed() {
    if (key == CODED) {
      if (keyCode == RIGHT) {
        activeVideoIndex = (activeVideoIndex < NO_OF_VIDS-1)?(activeVideoIndex+1):0;
      } else if (keyCode == LEFT) {
        activeVideoIndex = (activeVideoIndex > 0)?(activeVideoIndex-1):NO_OF_VIDS-1;
      } else if (keyCode == UP) {
        activeVideoIndex = (activeVideoIndex < NO_OF_ROWS)?(NO_OF_VIDS+activeVideoIndex-NO_OF_COLS):(activeVideoIndex-NO_OF_COLS);
      } else if (keyCode == DOWN) {
        activeVideoIndex = (activeVideoIndex < NO_OF_VIDS-NO_OF_COLS)?(activeVideoIndex+NO_OF_COLS):(NO_OF_COLS-NO_OF_VIDS+activeVideoIndex);
      }
    } else if (key == ENTER) {
      if (videoDisplayer[activeVideoIndex].isEmpty())  return;
      openVideoAtIndex(activeVideoIndex);
    }
  }

  void openVideoAtIndex(int index) {
    String pathToVideo = videoDisplayer[index].getPath();
    if (new File(dataPath(pathToVideo)).exists()) {
      println(dataPath(pathToVideo)+" is still there");
      openNewMovie(pathToVideo);
    } else {
      println("There is no such file existing");
    }
  }

  void removeVideoAtIndex(int index) {
    println("removed "+pathLists.get(pathLists.size()-1-index));
    pathLists.remove(pathLists.size()-1-index);
    for (int i = index; i < NO_OF_VIDS; i++)
      videoDisplayer[i].clearVideo(i);
    update();
  }

  int getVideoIndexMouseIsOver() {
    for (int i = 0; i< NO_OF_VIDS; i++) {
      if (videoDisplayer[i].isMouseOver()) {
        return i;
      }
    }
    return activeVideoIndex;
  }
}
