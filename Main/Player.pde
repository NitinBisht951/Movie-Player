class Player extends Activeness {

  private Movie movie;                          // movie to be played
  private String movieName;
  private String path;

  private boolean isFullScreen;                 //to check whether the video is currently fullscreen or not
  private boolean isPaused;                     //to check whether the video is currently paused or not
  private String durationString;                //to save duration of the video in hh:mm:ss form

  private float speed;                          //to control the speed of the movie
  private PImage tempImg;                       //used to show small images in between

  //miscellaneous fields
  private int showBarCount;                     //for how long the time bar should be active after the mouse is moved
  private int lastSnapshotIndex;
  private int currentSnapshotIndex;
  private float snapshotGap;
  private boolean begun;                        // to start the movie

  private float duration;
  private boolean hasSubtitle;
  private SubtitleReader subtitle;

  Player() {
    resetSettings();
    this.movieName = null;
  }

  void resetSettings() {
    begun = false;
    speed = 1.0;
    showBarCount = 0;
    isFullScreen = false;
    isPaused = false;
    lastSnapshotIndex = 0;
    currentSnapshotIndex = 1;
    snapshotGap = 0;
    duration = 100;
    tempImg = createImage(144, 80, RGB);
    hasSubtitle = false;
  }

  void updateMovie(PApplet sketch, String moviePath) {
    //println("updateMovie");
    resetSettings();
    this.path = moviePath;
    this.movieName = removeExtension(getNameFromPath(moviePath));
    movie = new Movie(sketch, moviePath);
    subtitleCheck();
  }

  void begin() {
    // start the movie and initialize the durationString
    if (begun == false) {
      //wait while movie is not initialized
      while (movie == null);
      println("--------- Movie Started ---------");
      movie.loop();
      if (movie.duration() > 1)
        duration = movie.duration();
      durationString = formatTime(int(duration));
      snapshotGap = duration/NO_OF_SNAPSHOTS;
      begun = true;
    }

    //showing the movie frame by frame
    if (isFullScreen)
      image(movie, 0, 0, width, height);
    else {
      imageMode(CENTER);
      image(movie, width/2, height/2);
      imageMode(CORNER);
    }

    //show subtitles
    if (hasSubtitle) {
      if (subtitle.isActive()) subtitle.show(movie.time());
    }

    // to display the time bar and movie name
    if (showBarCount >= 0) {
      showTimeBar();
      showMovieName();
      showBarCount--;
      if (mouseOnTimeBar()) {
        //println(pmouseX, mouseX);
        if (pmouseX == mouseX) {
          //code for short snapshots
          float tempTime = map(mouseX, 2*PLAYER_MARGIN, (width-2*PLAYER_MARGIN), 0, duration);
          currentSnapshotIndex = int(tempTime/snapshotGap);
          if (currentSnapshotIndex != lastSnapshotIndex) copyFrame(currentSnapshotIndex);
          lastSnapshotIndex = currentSnapshotIndex;
        }
        stroke(0);
        strokeWeight(5);
        noFill();
        rect(mouseX-tempImg.width/2, height-HSCALE*PLAYER_MARGIN, tempImg.width, tempImg.height);
        image(tempImg, mouseX-tempImg.width/2, height-HSCALE*PLAYER_MARGIN);
        showBarCount = THRESHOLD_BAR_COUNT;
      }
    }
  }

  void pauseOrPlay() {
    showBarCount = THRESHOLD_BAR_COUNT;
    if (isPaused == false) {
      movie.pause();
      isPaused = true;
    } else {
      movie.play();
      isPaused = false;
    }
  }

  void showTimeBar() {
    stroke(0);
    strokeWeight(1);
    fill(150);
    rect(PLAYER_MARGIN, height-3.2*PLAYER_MARGIN, 10*PLAYER_MARGIN, 1.2*PLAYER_MARGIN, 3);

    fill(0);
    textSize(20);                                          //settings for showing time and total length of movie
    textAlign(LEFT, TOP);
    text(formatTime(int(movie.time()))+"/"+durationString, 1.4*PLAYER_MARGIN, height-3.2*PLAYER_MARGIN);
    textAlign(LEFT, BASELINE);

    stroke(0);
    strokeWeight(2);
    fill(200);
    rect(PLAYER_MARGIN, height-2*PLAYER_MARGIN, width-2*PLAYER_MARGIN, PLAYER_MARGIN, 3);
    float durLength = map(movie.time(), 0, duration, 0, width-4*PLAYER_MARGIN);

    fill(255);
    rect(2*PLAYER_MARGIN, height-1.75*PLAYER_MARGIN, width-4*PLAYER_MARGIN, 0.5*PLAYER_MARGIN, 3);
    stroke(255, 0, 0);
    strokeWeight(8);
    strokeCap(SQUARE);
    line(2*PLAYER_MARGIN, height-1.5*PLAYER_MARGIN, 2*PLAYER_MARGIN+durLength, height-1.5*PLAYER_MARGIN);
    strokeCap(ROUND);                    //set back to default

    stroke(0);
    strokeWeight(3);

    //float snapshotDistance = map(snapshotGap, 0, duration, 0, width-4*PLAYER_MARGIN);
    //for (int i = 0; i <NO_OF_SNAPSHOTS; i++)
    //  point(i*snapshotDistance+2*PLAYER_MARGIN, height-1.5*PLAYER_MARGIN);
  }

  void showMovieName() {
    pushStyle();
    textFont(COURIER_NEW_BOLD_FONT, 40);
    //textSize(40);                                          //settings for showing time and total length of movie
    textAlign(LEFT, TOP);
    text(movieName, 1.4*PLAYER_MARGIN, 2*PLAYER_MARGIN);
    textAlign(LEFT, BASELINE);
    popStyle();
  }

  //tells whether the mouse is over the time bar
  boolean mouseOnTimeBar() {
    if ((mouseY < (height-1.25*PLAYER_MARGIN))&&(mouseY > (height-1.75*PLAYER_MARGIN))&&(mouseX <= (width-2*PLAYER_MARGIN))&&(mouseX >= 2*PLAYER_MARGIN))
      return true;
    else
      return false;
  }

  void mouseMoved() {
    showBarCount = THRESHOLD_BAR_COUNT;
  }

  void mouseClicked() {
    //println(mouseX,mouseY);
    if (mouseOnTimeBar())
      jumpTo(mouseX);
    else if (!((mouseX > PLAYER_MARGIN && mouseX < width-PLAYER_MARGIN) && (mouseY > height-2*PLAYER_MARGIN && mouseY < height-PLAYER_MARGIN)))
      pauseOrPlay();
  }

  void keyPressed() {
    if (key == CODED) {
      if (keyCode == LEFT) {
        movieBackward(5);
      } else if (keyCode == DOWN) {
        movieBackward(30);
      } else if (keyCode == RIGHT) {
        movieForward(5);
      } else if (keyCode == UP) {
        movieForward(30);
      }
    } else if (key == SPACE) {
      pauseOrPlay();
    } else if (key == 'i') {
      increaseSpeed(0.05);
    } else if (key == 'd') {
      decreaseSpeed(0.05);
    } else if (key == 'f') {
      isFullScreen = !isFullScreen;
    } else if (key == BACKSPACE) {
      println("--------- Movie Stopped ---------\n");
      movie.stop();
      mov.initActivity('c');
    }
  }

  //jumps to specific location by clicking on the time bar
  void jumpTo(float location) {
    float time = map(location, 2*PLAYER_MARGIN, width-2*PLAYER_MARGIN, 0, duration);

    //println(formatTime(int(time)));
    movie.jump(time);
  }

  void copyFrame(int snapshotIndex) {
    float newTime = snapshotIndex*snapshotGap;
    float pTime = movie.time();
    movie.jump(newTime);
    if (movie.available()) {
      movie.read();
    }
    tempImg.copy(movie, 0, 0, movie.width, movie.height, 0, 0, tempImg.width, tempImg.height);
    tempImg.updatePixels();
    movie.jump(pTime);
  }

  void movieForward(int seconds) {
    showBarCount = THRESHOLD_BAR_COUNT;
    if (movie.time() < (duration-(seconds+0.2)))
      movie.jump(movie.time()+seconds);
    else movie.jump(0);
  }

  void movieBackward(int seconds) {
    showBarCount = THRESHOLD_BAR_COUNT;
    if (movie.time() > (seconds+0.2))
      movie.jump(movie.time()-seconds);
    else movie.jump(0);
  }

  void decreaseSpeed(float change) {
    if (speed >= MIN_PLAYBACK_SPEED)
      changeSpeed(-change);
  }

  void increaseSpeed(float change) {
    if (speed <= MAX_PLAYBACK_SPEED)
      changeSpeed(change);
  }

  void changeSpeed(float change) {
    speed += change;
    movie.speed(speed);
    println(speed);
  }

  //checks whether current movie has any subtitles or not
  void subtitleCheck() {
    String[] pathParts = split(path, "\\");
    String movieDirectoryPath = "";
    int subtitleFilesCount = 0;
    String subtitleFullPath = "";
    //store the movie Directory path
    for (int i = 0; i < pathParts.length-1; i++) {
      movieDirectoryPath += pathParts[i] + "\\";
    }
    File file = new File(movieDirectoryPath);
    if (file.isDirectory()) {
      String[] names = file.list();
      for (int i = 0; i < names.length; i++) {
        if (hasExtension(names[i], ".srt")) {
          subtitleFilesCount++;
          if (subtitleFilesCount == 1) {
            //take first subtitles as default
            subtitleFullPath = movieDirectoryPath + names[i];
            subtitle = new SubtitleReader(subtitleFullPath, new PVector(DISPLAY_WIDTH/2, DISPLAY_HEIGHT-4*PLAYER_MARGIN));
            println(subtitleFullPath);
            hasSubtitle = true;
          }
        }
      }
      if (subtitleFilesCount < 1) { 
        println("No sububtitles"); 
        hasSubtitle = false;
      }
    } else {
      println("Not a directory !!!");
    }
  }
}
