//This class is for the first screen activity of the MoviePlayer
//It gives option to open a new movie
//It uses two small Bar : VideoBar and InfoBar
//VideoBar displays different recently played videos as history
//InfoBar displays the information about the video in focus, if there is one

class Canvas extends Activeness {
  VideoDisplayer[][] videos = new VideoDisplayer[NO_OF_ROWS][NO_OF_COLS];
  int activeVideoIndex = 0;

  //buttons
  Button openVideoButton;
  Button closeButton;

  //constructor
  Canvas() {
    for (int row = 0; row < NO_OF_ROWS; row++) {
      for (int col = 0; col < NO_OF_COLS; col++) {
        int i = row * NO_OF_ROWS + col;
        float x = CANVAS_LEFT_MARGIN + col*(GRID_VID_WIDTH + CANVAS_MARGIN);
        float y = CANVAS_TOP_MARGIN + row*(GRID_VID_HEIGHT + CANVAS_MARGIN);
        videos[row][col] = new VideoDisplayer("Title"+i, "Path", new PVector(x, y));
      }
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
    for (int row = 0; row < NO_OF_ROWS; row++) {
      for (int col = 0; col < NO_OF_COLS; col++) {
        int i = row * NO_OF_ROWS + col;
        if (activeVideoIndex == i) {
          stroke(255);
          strokeWeight(LIGHT_WEIGHT);
        } else {
          noStroke();
        }
        videos[row][col].draw();
      }
    }
  }

  //lists the details of the current active video
  void drawInfoBar() {
  }

  void updateVideoDisplayer() {
    int tempSize = pathLists.size();
    for (int row = 0; row < NO_OF_ROWS; row++) {
      for (int col = 0; col < NO_OF_COLS; col++) {
        int i = row * NO_OF_ROWS + col;
        if (i == tempSize) return;
        videos[row][col].changeVideo(pathLists.get(tempSize-i-1));
      }
    }
  }

  void mouseClicked() {
    if (openVideoButton.isClicked()) {
      selectInput("Select a video to open:", "fileSelected");
    } else if (closeButton.isClicked()) {
      exit();
    } else {
      for (int row = 0; row < NO_OF_ROWS; row++) {
        for (int col = 0; col < NO_OF_COLS; col++) {
          int i = row * NO_OF_ROWS + col;
          if (videos[row][col].isEmpty()) return;
          if (videos[row][col].mouseClicked()) {
            activeVideoIndex = i;
            openNewMovie(videos[row][col].getPath());
          }
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
      int c = activeVideoIndex % NO_OF_ROWS;
      int r = (activeVideoIndex - c)/NO_OF_ROWS;
      //print(activeVideoIndex, r, c); 
      if (videos[r][c].isEmpty())  return;
      openNewMovie(videos[r][c].getPath());
    }
  }
}