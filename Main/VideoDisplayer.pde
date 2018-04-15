class VideoDisplayer {
  private String title;
  private String path;

  //coordinates of corner and height and width
  private PVector corner;
  private float vidWidth = GRID_VID_WIDTH;
  private float vidHeight = GRID_VID_HEIGHT;

  private Button playButton;
  private Button previewButton;
  private Button removeButton;

  private boolean isEmpty;                        //keeps track of the history

  //constructors
  VideoDisplayer(String title, String path, PVector corner) {
    this.title = title;
    this.path = path;
    this.corner = corner;
    this.playButton = new Button(PLAY_BLACK_SMALL);
    isEmpty = true;
  }

  VideoDisplayer(String title, String path, PVector corner, float vidWidth, float vidHeight) {
    this(title, path, corner);
    this.vidWidth = vidWidth;
    this.vidHeight = vidHeight;
    this.playButton.changeImg(PLAY_BLACK_MEDIUM);
  }

  void draw() {
    // draw image in place of rect
    fill(VIDEODISPLAYER_COLOR);
    rect(corner.x, corner.y, vidWidth, vidHeight);

    fill(VIDEODISPLAYER_STROKE_COLOR);
    rect(corner.x, corner.y+TITLE_MARGIN_FACTOR*vidHeight, vidWidth, (1-TITLE_MARGIN_FACTOR)*vidHeight);

    fill(0);
    textSize(60*vidHeight/DISPLAY_HEIGHT);
    float text_X = corner.x + CANVAS_MARGIN*0.25;
    float text_Y = corner.y + vidHeight*0.87;
    text(title, text_X, text_Y, vidWidth*0.97, vidHeight*0.1);

    //places the play button at the center of the VideoBar
    playButton.draw(corner.x+vidWidth/2, corner.y+vidHeight/2-10);
  }

  void changeVideo(String path) {
    this.path = path;
    this.title = getNameFromPath(path);
    this.isEmpty = false;
  }
  
  String getPath() {
    if(isEmpty) return null;
    else return path;
  }

  boolean isEmpty() {
    return isEmpty;
  }
 
  boolean mouseClicked() {
    if (playButton.isClicked()) {
      //play that video
      return true;
    } else return false;
    // else if (previewButton.isClicked()) {
    //  //preview that video
    //}
  }
}