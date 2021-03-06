class VideoDisplayer {
  private String title;
  private String path;
  //private PImage poster = null;

  //coordinates of corner and height and width
  private PVector corner;
  private float vidWidth = VID_DISPLAYER_WIDTH;
  private float vidHeight = VID_DISPLAYER_HEIGHT;

  private Button playButton;
  //private Button previewButton;
  private Button removeButton;

  private boolean isEmpty;                        //keeps track of the history

  //constructors
  VideoDisplayer(String title, String path, PVector corner) {
    this.title = title;
    this.path = path;
    this.corner = corner;
    this.playButton = new Button(PLAY_CIRCLE_MEDIUM);
    this.removeButton = new Button(REMOVE_BUTTON);
    isEmpty = true;
  }

  VideoDisplayer(String title, String path, PVector corner, float vidWidth, float vidHeight) {
    this(title, path, corner);
    this.vidWidth = vidWidth;
    this.vidHeight = vidHeight;
    this.playButton.changeImg(PLAY_BLACK_MEDIUM);
  }

  void draw(boolean isActive) {
    final float RADII = 2;
    noStroke();
    fill(0, 50);

    if (isActive) {
      //draw shadow of the rect
      rect(corner.x+RADII, corner.y+RADII, vidWidth-2*RADII, vidHeight+4, RADII+4);
      stroke(VIDEODISPLAYER_STROKE_COLOR);
      strokeWeight(LIGHT_WEIGHT);
    } else {
      rect(corner.x+RADII, corner.y+RADII, vidWidth-RADII/2, vidHeight-RADII/2, RADII);
    }

    // draw image in place of rect
    fill(VIDEODISPLAYER_COLOR);
    rect(corner.x, corner.y, vidWidth, vidHeight, RADII);

    fill(VIDEODISPLAYER_STROKE_COLOR);
    rect(corner.x, corner.y+TITLE_MARGIN_FACTOR*vidHeight, vidWidth, (1-TITLE_MARGIN_FACTOR)*vidHeight, 0, 0, RADII, RADII);

    fill(0);
    pushStyle();
    textFont(LEXIA_FONT, 14);
    float text_X = corner.x + CANVAS_MARGIN*0.25;
    float text_Y = corner.y + vidHeight*0.89;
    text(title, text_X, text_Y, vidWidth*0.97, vidHeight*0.1);

    popStyle();
    //places the play button at the center of the VideoBar
    playButton.draw(corner.x+vidWidth/2, corner.y+vidHeight/2-10);
    if (playButton.isOverButton()) playButton.hoverOverButton(true, 35);

    if (isActive && !isEmpty) {
      removeButton.draw(corner.x+vidWidth-removeButton.getWidth()/2-8, corner.y+removeButton.getHeight()/2+8);
      if (removeButton.isOverButton()) removeButton.hoverOverButton(true, 15);
    }
  }

  void updateVideo(String path) {
    this.path = path;
    this.title = removeExtension(getNameFromPath(path));
    this.isEmpty = false;
  }

  void clearVideo(int index) {
    this.path = "Path";
    this.title = "Title "+ index;
    this.isEmpty = true;
  }

  String getPath() {
    if (isEmpty) return null;
    else return path;
  }

  boolean isEmpty() {
    return isEmpty;
  }

  boolean isMouseOver() {
    if (mouseX > corner.x && mouseY > corner.y && (mouseX < corner.x + vidWidth) && (mouseY < corner.y + vidHeight)) {
      return true;
    } else return false;
  }

  boolean playButtonClicked() {
    if (playButton.isClicked()) {
      //play that video
      return true;
    } else return false;
  }

  boolean removeButtonClicked() {
    if (removeButton.isClicked()) {
      //remove that video
      return true;
    } else return false;
  }

  //boolean previewButtonClicked() {
  //  if (previewButton.isClicked()) {
  //    //play that video
  //    return true;
  //  } else return false;
  //}
}
