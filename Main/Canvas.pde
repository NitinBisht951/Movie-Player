class Canvas extends Activeness {
  VideoDisplayer[][] videos = new VideoDisplayer[NO_OF_ROWS][NO_OF_COLS];
  VideoDisplayer activeVideo;
  int activeVideoIndex = 0;

  //viewing modes for later versions
  boolean viewMode = GRID_VIEW;

  //buttons
  Button openVideoButton;
  Button closeButton;
  Button viewModeButton;

  //constructor
  Canvas() {
    //for grid view initialize the array of videos and for single view initialize only single video( activeVideo)
    for (int row = 0; row < NO_OF_ROWS; row++) {
      for (int col = 0; col < NO_OF_COLS; col++) {
        int i = row * NO_OF_ROWS + col;
        float x = CANVAS_LEFT_MARGIN + col*(GRID_VID_WIDTH + MARGIN);
        float y = CANVAS_TOP_MARGIN + row*(GRID_VID_HEIGHT + MARGIN);
        videos[row][col] = new VideoDisplayer("Title", "Path", new PVector(x, y));
      }
    }
    activeVideo = new VideoDisplayer("Title", "Path", new PVector(CANVAS_LEFT_MARGIN, CANVAS_TOP_MARGIN), VIDEO_BAR_WIDTH-4*MARGIN, DISPLAY_HEIGHT-9*MARGIN);

    //buttons
    openVideoButton = new Button(OPEN_BUTTON);
    closeButton = new Button(CLOSE_SMALL);
    viewModeButton = new Button(VIEW_MODE_SMALL);
  }

  void show() {
    //show open video button at the topleft corner
    openVideoButton.draw(CANVAS_LEFT_MARGIN, CANVAS_LEFT_MARGIN);
    //show close button at the topright corner
    closeButton.draw(DISPLAY_WIDTH-closeButton.getWidth(), 0, 255);
    //show view mode button at the topright corner before close button
    viewModeButton.draw(DISPLAY_WIDTH-closeButton.getWidth()-viewModeButton.getWidth()-5, 0, 255);

    //show list of videos
    drawVideoBar();

    stroke(255);
    strokeWeight(2);
    //line separation between open button and VideoBar
    line(CANVAS_LEFT_MARGIN, 5*MARGIN, VIDEO_BAR_WIDTH - CANVAS_LEFT_MARGIN, 5*MARGIN);
    //line separation between VideoBar and InfoBar
    line(VIDEO_BAR_WIDTH, MARGIN, VIDEO_BAR_WIDTH, DISPLAY_HEIGHT - MARGIN);

    //show info about the active video
    // drawInfoBar();
  }

  void drawVideoBar() {
    if (viewMode == GRID_VIEW) {
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
    } else if (viewMode == SINGLE_VIEW) {
      activeVideo.draw();
    }
  }

  //lists the details of the current active video
  void drawInfoBar() {
  }

  void mouseClicked() {
    if (openVideoButton.isClicked()) {
      // println("opened");
      selectInput("Select a video to open:", "fileSelected");
      
    } else if (viewModeButton.isClicked()) {
      viewMode = !viewMode;
    } else if (closeButton.isClicked()) {
      exit();
    } else if (viewMode == SINGLE_VIEW && activeVideo.playButton.isClicked()) {
      // play the activeVideo
      //activeVideo.playButton.changeImg();
    } else if (viewMode == GRID_VIEW) {
      //for the view grid mode
    }
  }

  void keyPressed() {
    if (key == CODED && viewMode == GRID_VIEW) {
      if (keyCode == RIGHT) {
        activeVideoIndex = (activeVideoIndex < NO_OF_VIDS-1)?(activeVideoIndex+1):0;
      } else if (keyCode == LEFT) {
        activeVideoIndex = (activeVideoIndex > 0)?(activeVideoIndex-1):NO_OF_VIDS-1;
      } else if (keyCode == UP) {
        activeVideoIndex = (activeVideoIndex < NO_OF_ROWS)?(NO_OF_VIDS+activeVideoIndex-NO_OF_COLS):(activeVideoIndex-NO_OF_COLS);
      } else if (keyCode == DOWN) {
        activeVideoIndex = (activeVideoIndex < NO_OF_VIDS-NO_OF_COLS)?(activeVideoIndex+NO_OF_COLS):(NO_OF_COLS-NO_OF_VIDS+activeVideoIndex);
      }
    } else if (key == 'v' || key=='V') {
      viewMode = !viewMode;
    }
  }
}