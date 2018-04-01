class Canvas extends Activeness {
  Videos[][] videos = new Videos[NO_OF_ROWS][NO_OF_COLS];
  Videos activeVideo;
  int activeVideoIndex = 0;

  //viewing modes for later versions
  boolean viewMode = GRID_VIEW;

  //buttons
  Button closeButton;
  Button viewModeButton;

  //constructor
  Canvas() {
    //for grid view initialize the array of videos and for single view initialize only single video( activeVideo)
    for (int row = 0; row < NO_OF_ROWS; row++) {
      for (int col = 0; col < NO_OF_COLS; col++) {
        int i = row * NO_OF_ROWS + col;
        float x = 2*MARGIN + col*(GRID_VID_WIDTH + MARGIN);
        float y = 7*MARGIN + row*(GRID_VID_HEIGHT + MARGIN);
        videos[row][col] = new Videos("TITLE"+i, "PATH"+i, new PVector(x, y));
      }
    }
    activeVideo = new Videos("Title", "Path", new PVector(CANVAS_LEFT_MARGIN, CANVAS_TOP_MARGIN), VIDEO_BAR_WIDTH-4*MARGIN, DISPLAY_HEIGHT-9*MARGIN);

    //buttons
    closeButton = new Button(CLOSE_SMALL);
    viewModeButton = new Button(VIEW_MODE_SMALL);
  }

  void show() {

    //show close button at the topright corner
    closeButton.draw(DISPLAY_WIDTH-closeButton.getWidth(), 0, 255);

    //show view mode button at the topright corner before close button
    viewModeButton.draw(DISPLAY_WIDTH-closeButton.getWidth()-viewModeButton.getWidth()-5, 0, 255);

    //show list of videos
    drawVideoBar();

    //line separation between VideoBar and InfoBar
    stroke(255);
    strokeWeight(2);
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
    //check where the mouse is
    if (viewModeButton.isClicked()) {
      viewMode = !viewMode;
    } else if (closeButton.isClicked()) {
      exit();
    } else if (viewMode == SINGLE_VIEW && activeVideo.playButton.isClicked()) {
      // play the activeVideo
      //activeVideo.playButton.changeImg();
    } else if (viewMode == GRID_VIEW) {
      for (int row = 0; row < NO_OF_ROWS; row++) {
        for (int col = 0; col < NO_OF_COLS; col++) {
          if(videos[row][col].playButton.isClicked()) {
          int i = row * NO_OF_ROWS + col;
          activeVideoIndex = i;
          text("pl",50,500);
          //play the i th video
         // videos[row][col].play();
          }
        }
      }
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
