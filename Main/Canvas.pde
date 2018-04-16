//This class is for the first screen of the MoviePlayer
//It gives option to open a new movie
//It uses two small Bar : VideoBox and InfoBar
//VideoBox displays different recently played videos as history
//InfoBox displays the information about the video in focus, if there is one

class Canvas extends Activeness {
  private VideosListBox vidBox;

  //buttons
  private Button openVideoButton;
  private Button closeButton;

  //constructor
  Canvas() {
    vidBox = new VideosListBox();
    //buttons
    openVideoButton = new Button(OPEN_BUTTON);
    closeButton = new Button(CLOSE_CIRCLE_SMALL);
  }

  void show() {
    //show open video button at the topleft corner
    openVideoButton.draw(CANVAS_LEFT_MARGIN+openVideoButton.getWidth()/2, CANVAS_LEFT_MARGIN+openVideoButton.getHeight()/2,255);
    //show close button at the topright corner
    closeButton.draw(DISPLAY_WIDTH-closeButton.getWidth()/2, closeButton.getHeight()/2);

    //show video list Box
    vidBox.draw();

    stroke(255);
    strokeWeight(2);
    //line separation between open button and VideoBar
    line(CANVAS_LEFT_MARGIN, 5*CANVAS_MARGIN, VIDEO_BAR_WIDTH - CANVAS_LEFT_MARGIN, 5*CANVAS_MARGIN);
    //line separation between VideoBar and InfoBar
    line(VIDEO_BAR_WIDTH, CANVAS_MARGIN, VIDEO_BAR_WIDTH, DISPLAY_HEIGHT - CANVAS_MARGIN);

    //show info about the active video
    // drawInfoBar();
  }

  void update() {
    vidBox.update();
  }

  void mouseMoved() {
    vidBox.mouseMoved();
  }

  void mouseClicked() {
    if (openVideoButton.isClicked()) {
      //opens a thread to get the path of the video opened
      selectInput("Select a video to open:", "fileSelected");
    } else if (closeButton.isClicked()) {
      exit();
    } else {
      vidBox.mouseClicked();
    }
  }

  void keyPressed() {
    vidBox.keyPressed();
  }
}