//This class is for the first screen activity of the MoviePlayer
//It gives option to open a new movie
//It uses two small Bar : VideoBar and InfoBar
//VideoBar displays different recently played videos as history
//InfoBar displays the information about the video in focus, if there is one

class Canvas extends Activeness {
  VideoDisplayer[] videos = new VideoDisplayer[NO_OF_VIDS];
  int activeVideoIndex = 0;

  //buttons
  Button openVideoButton;
  Button closeButton;

  //constructor
  Canvas() {
    for (int i = 0; i < NO_OF_VIDS; i++) {
      int col = i % NO_OF_ROWS;
      int row = (i - col)/NO_OF_ROWS;
      float x = CANVAS_LEFT_MARGIN + col*(GRID_VID_WIDTH + CANVAS_MARGIN);
      float y = CANVAS_TOP_MARGIN + row*(GRID_VID_HEIGHT + CANVAS_MARGIN);
      videos[i] = new VideoDisplayer("Title"+i, "Path", new PVector(x, y));
    }
    updateVideoDisplayer();
    //buttons
    openVideoButton = new Button(FOLDER_OPEN_SMALL);
    closeButton = new Button(CLOSE_SMALL);
  }

  void show() {
    //show open video button at the topleft corner
    openVideoButton.draw(CANVAS_LEFT_MARGIN, CANVAS_LEFT_MARGIN, 255);
    //show close button at the topright corner
    closeButton.draw(DISPLAY_WIDTH-closeButton.getWidth(), 0, 255);
    //show list of videos
    drawVideoBar();

    stroke(255);
    strokeWeight(2);
    //line separation between open button and VideoBar
    line(CANVAS_LEFT_MARGIN, 5*CANVAS_MARGIN, VIDEO_BAR_WIDTH - CANVAS_LEFT_MARGIN, 5*CANVAS_MARGIN);
    //line separation between VideoBar and InfoBar
    line(VIDEO_BAR_WIDTH, CANVAS_MARGIN, VIDEO_BAR_WIDTH, DISPLAY_HEIGHT - CANVAS_MARGIN);

    //show info about the active video
    // drawInfoBar();
  }

  void drawVideoBar() {
    for (int i = 0; i < NO_OF_VIDS; i++) {
      if (activeVideoIndex == i) {
        stroke(VIDEODISPLAYER_STROKE_COLOR);
        strokeWeight(LIGHT_WEIGHT);
      } else {
        noStroke();
      }
      videos[i].draw();
    }
  }

  void updateVideoDisplayer() {
    int tempSize = pathLists.size();
    for (int i = 0; i < NO_OF_VIDS; i++) {
      if (i == tempSize) return;
      videos[i].changeVideo(pathLists.get(tempSize-i-1));
    }
  }

  int getVideoIndexMouseIsOver() {
    int r = 0;
    int c = 0;
    for (; r < NO_OF_ROWS; r++) {
      boolean isInRowZone = (mouseY > CANVAS_TOP_MARGIN + r*(GRID_VID_HEIGHT + CANVAS_MARGIN))
        &&(mouseY < CANVAS_TOP_MARGIN + r*(GRID_VID_HEIGHT + CANVAS_MARGIN)+GRID_VID_HEIGHT);
      if (isInRowZone) {
        break;
      }
    }  

    for (; c < NO_OF_COLS; c++) {
      boolean isInColZone = (mouseX > CANVAS_LEFT_MARGIN + c*(GRID_VID_WIDTH + CANVAS_MARGIN))
        &&(mouseX < CANVAS_LEFT_MARGIN + c*(GRID_VID_WIDTH + CANVAS_MARGIN)+GRID_VID_WIDTH);
      if (isInColZone) {
        break;
      }
    }
    int i = (r*NO_OF_ROWS+c);
    if (r >= NO_OF_ROWS || c >= NO_OF_COLS) i = activeVideoIndex;
    //println("row : ", r, ", col : ", c, ", index : ", i);
    return i;
  }

  void mouseMoved() {
    activeVideoIndex = getVideoIndexMouseIsOver();
  }

  void mouseClicked() {
    if (openVideoButton.isClicked()) {
      selectInput("Select a video to open:", "fileSelected");
    } else if (closeButton.isClicked()) {
      exit();
    } else {
      for (int i = 0; i < NO_OF_VIDS; i++) {
        if (videos[i].isEmpty()) return;
        if (videos[i].mouseClicked()) {
          //activeVideoIndex = i;
          openMovieAtIndex(i);
        }
      }
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
      if (videos[activeVideoIndex].isEmpty())  return;
      openMovieAtIndex(activeVideoIndex);
    }
  }

  void openMovieAtIndex(int index) {
    String pathToVideo = videos[index].getPath();
    if (new File(dataPath(pathToVideo)).exists()) {
      println(dataPath(pathToVideo)+" is still there");
      openNewMovie(pathToVideo);
    } else {
      println("There is no such file existing");
    }
  }
}