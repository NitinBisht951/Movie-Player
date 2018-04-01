class Videos {

  String title;
  String path;

  //coordinates of corner and height and width
  PVector corner;
  float vidWidth = GRID_VID_WIDTH;
  float vidHeight = GRID_VID_HEIGHT;

  Button playButton;

  //constructors
  Videos(String title, String path, PVector corner) {
    this.title = title;
    this.path = path;
    this.corner = corner;
    this.playButton = new Button(PLAY_SMALL);
  }

  Videos(String title, String path, PVector corner, float vidWidth, float vidHeight) {
    this(title, path, corner);
    this.vidWidth = vidWidth;
    this.vidHeight = vidHeight;
    this.playButton.changeImg(PLAY_LARGE);
  }

  void draw() {

    // draw image in place of rect
    fill(100);
    rect(corner.x, corner.y, vidWidth, vidHeight);

    fill(255);
    rect(corner.x, corner.y+TITLE_MARGIN_FACTOR*vidHeight, vidWidth, (1-TITLE_MARGIN_FACTOR)*vidHeight);

    fill(0);
    textSize(80*vidHeight/DISPLAY_HEIGHT);
    float text_X = corner.x + MARGIN*0.3;
    float text_Y = corner.y + vidHeight*0.96;

    text(title, text_X, text_Y);

    playButton.draw(corner.x,corner.y+5);
  }
}
