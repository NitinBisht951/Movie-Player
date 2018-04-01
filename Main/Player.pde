class Player  extends Activeness {

  Movie movie;
  String moviePath;
  boolean notStarted;
  boolean isActive;
  boolean isFullScreen;
  boolean paused;
  String durationString;
  //to control the speed of the movie
  float speed;
  //coordinate of topleft corner of the screen
  PVector start;
  //used to show small images in between
  PImage tempImg;

  //for how long the time bar should be active after the mouse is moved
  int showBarCount;
  int mouseStableCount;

  Player(PApplet sketch, String path) {
    resetSettings();
    moviePath = path;
    // Load and play the video in a loop
    movie = new Movie(sketch, moviePath);
    if(isActive)
    movie.loop();

    tempImg = createImage(144, 80, RGB);
    //format duration time
    durationString = formatTime(int(movie.duration()));
  }

  void resetSettings() {
    moviePath = null;
    notStarted = true;
    start = new PVector(0, 0);
    speed = 1.0;
    showBarCount = 0;
    mouseStableCount = 0;
    isFullScreen = false;
    paused = false;
    //settings for showing time and total length of movie
    textSize(20);
  }

  void updateMovie(Movie newMov) {
    movie = newMov;
    if(isActive) movie.loop();
    else movie.stop();
  }

  void play() {
    //background(0);
    //println(start.x, start.y, movie.width);
    if (notStarted == true) {
      //find proper start values to layout the video in the middle of the screen
      start.x = (width-movie.width)/2;
      start.y = (height-movie.height)/2;
      if (!(movie.width < 5))
        notStarted = false;
    }

    if (isFullScreen)
      image(movie, 0, 0, width, height);
    else
      image(movie, start.x, start.y);

    if (showBarCount >= 0) {
      showTimeBar(movie);
      if (mouseOnTimeBar()) {
        stroke(0);
        strokeWeight(5);
        noFill();
        rect(mouseX-tempImg.width/2, height-HSCALE*PLAYER_MARGIN, tempImg.width, tempImg.height);
        image(tempImg, mouseX-tempImg.width/2, height-HSCALE*PLAYER_MARGIN);
      }
    }
  }

  void movieForward(Movie movie, int seconds) {
    showBarCount = THRESHOLD_BAR_COUNT;
    if (movie.time() < (movie.duration()-(seconds+0.2)))
      movie.jump(movie.time()+seconds);
    else movie.jump(0);
  }

  void movieBackward(Movie movie, int seconds) {
    showBarCount = THRESHOLD_BAR_COUNT;
    if (movie.time() > (seconds+0.2))
      movie.jump(movie.time()-seconds);
    else movie.jump(0);
  }

  void decreaseSpeed(Movie movie, float change) {
    if (speed >= MIN_PLAYBACK_SPEED)
      changeSpeed(movie, -change);
  }

  void increaseSpeed(Movie movie, float change) {
    if (speed <= MAX_PLAYBACK_SPEED)
      changeSpeed(movie, change);
  }

  void changeSpeed(Movie movie, float change) {
    speed += change;
    movie.speed(speed);
    println(speed);
  }

  void pauseOrPlay(Movie movie) {
    showBarCount = THRESHOLD_BAR_COUNT;
    if (paused == false) {
      movie.pause();
      paused = true;
    } else {
      movie.play();
      paused = false;
    }
  }

  void showTimeBar(Movie movie) {
    stroke(0);
    strokeWeight(1);
    fill(255);
    rect(PLAYER_MARGIN, height-3.2*PLAYER_MARGIN, 10*PLAYER_MARGIN, 1.2*PLAYER_MARGIN, 3);

    fill(0);
    textAlign(LEFT, TOP);
    text(formatTime(int(movie.time()))+"/"+durationString, 1.4*PLAYER_MARGIN, height-3.2*PLAYER_MARGIN);
    textAlign(LEFT, BASELINE);

    stroke(0);
    strokeWeight(2);
    fill(255);
    rect(PLAYER_MARGIN, height-2*PLAYER_MARGIN, width-2*PLAYER_MARGIN, PLAYER_MARGIN, 3);
    float durLength = map(movie.time(), 0, movie.duration(), 0, width-4*PLAYER_MARGIN);

    rect(2*PLAYER_MARGIN, height-1.75*PLAYER_MARGIN, width-4*PLAYER_MARGIN, 0.5*PLAYER_MARGIN, 3);
    stroke(255, 0, 0);
    strokeWeight(8);
    line(2*PLAYER_MARGIN, height-1.5*PLAYER_MARGIN, 2*PLAYER_MARGIN+durLength, height-1.5*PLAYER_MARGIN);

    showBarCount--;
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

    if (mouseOnTimeBar() && mouseStableCount==0) {
      copyFrame(movie, tempImg, mouseX);
      mouseStableCount = THRESHOLD_STABLE_COUNT;
    }
    if (mouseStableCount > 0 && mouseOnTimeBar())
      mouseStableCount--;
  }

  void mouseClicked() {
    if (mouseOnTimeBar())
      jumpTo(movie, mouseX);
    else
      pauseOrPlay(movie);
  }

  void keyPressed() {
    if (key == CODED) {
      if (keyCode == LEFT) {
        movieBackward(movie, 5);
      } else if (keyCode == DOWN) {
        movieBackward(movie, 30);
      } else if (keyCode == RIGHT) {
        movieForward(movie, 5);
      } else if (keyCode == UP) {
        movieForward(movie, 30);
      }
    } else if (key == SPACE) {
      pauseOrPlay(movie);
    } else if (key == 's') {
      increaseSpeed(movie, 0.05);
    } else if (key == 'd') {
      decreaseSpeed(movie, 0.05);
    } else if (key == 'f') {
      isFullScreen = !isFullScreen;
    }
  }

  //jumps to specific location by clicking on the time bar
  void jumpTo(Movie movie, float x) {
    float time = map(x, 2*PLAYER_MARGIN, width-2*PLAYER_MARGIN, 0, movie.duration());
    //println(formatTime(int(time)));
    movie.jump(time);
  }

  void copyFrame(Movie copyMovie, PImage img, float x) {
    float newTime = map(x, 2*PLAYER_MARGIN, width-2*PLAYER_MARGIN, 0, copyMovie.duration());
    float pTime = copyMovie.time();
    copyMovie.jump(newTime);
    if (copyMovie.available()) {
      copyMovie.read();
    }
    img.copy(copyMovie, 0, 0, copyMovie.width, copyMovie.height, 0, 0, img.width, img.height);
    copyMovie.jump(pTime);
  }
}