class Player extends Activeness {

  Movie movie;                          // movie to be played
  String moviePath;                     // movie absolute path
  String movieName;

  boolean isFullScreen;                 //to check whether the video is currently fullscreen or not
  boolean isPaused;                     //to check whether the video is currently paused or not
  String durationString;                //to save duration of the video in hh:mm:ss form

  float speed;                          //to control the speed of the movie
  PImage tempImg;                       //used to show small images in between

  int showBarCount;                     //for how long the time bar should be active after the mouse is moved
  int mouseStableCount;
  boolean begun;                        // to start the movie

  Player() {
    resetSettings();
    this.moviePath = null;
    this.movieName = null;
  }

  void resetSettings() {
    moviePath = null;
    begun = false;
    speed = 1.0;
    showBarCount = 0;
    mouseStableCount = 0;
    isFullScreen = false;
    isPaused = false;
    tempImg = createImage(144, 80, RGB);
  }

  void updateMovie(String moviePath) {
    println("updateMovie");
    //if there is still previous movie present, stop it first
    if (movie != null) {
      println("stopped");
      movie.stop();
    }
    resetSettings();
    this.moviePath = moviePath;
    this.movieName = getNameFromPath(moviePath);
    movie = new Movie(mySketch, moviePath);
  }

  void begin() {
    // start the movie and initialize the durationString
    if (begun == false) {
      while (movie == null);
      println("begun");
      if (isActive)  movie.play();
      durationString = formatTime(int(movie.duration()));
      //println(durationString);
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

    // to display the time bar and movie name
    if (showBarCount >= 0) {
      showTimeBar();
      showMovieName();
      showBarCount--;
      if (mouseOnTimeBar()) {
        stroke(0);
        strokeWeight(5);
        noFill();
        rect(mouseX-tempImg.width/2, height-HSCALE*PLAYER_MARGIN, tempImg.width, tempImg.height);
        image(tempImg, mouseX-tempImg.width/2, height-HSCALE*PLAYER_MARGIN);
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
    float durLength = map(movie.time(), 0, movie.duration(), 0, width-4*PLAYER_MARGIN);

    fill(255);
    rect(2*PLAYER_MARGIN, height-1.75*PLAYER_MARGIN, width-4*PLAYER_MARGIN, 0.5*PLAYER_MARGIN, 3);
    stroke(255, 0, 0);
    strokeWeight(7);
    strokeCap(SQUARE);
    line(2*PLAYER_MARGIN, height-1.5*PLAYER_MARGIN, 2*PLAYER_MARGIN+durLength, height-1.5*PLAYER_MARGIN);
  }

  void showMovieName() {
    textSize(40);                                          //settings for showing time and total length of movie
    textAlign(LEFT, TOP);
    text(movieName, 1.4*PLAYER_MARGIN, 3.2*PLAYER_MARGIN);
    textAlign(LEFT, BASELINE);
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
      copyFrame(tempImg, mouseX);
      mouseStableCount = THRESHOLD_STABLE_COUNT;
    }
    if (mouseStableCount > 0 && mouseOnTimeBar()) {
      mouseStableCount--;
    }
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
    } else if (key == 's') {
      increaseSpeed(0.05);
    } else if (key == 'd') {
      decreaseSpeed(0.05);
    } else if (key == 'f') {
      isFullScreen = !isFullScreen;
    } else if (key == BACKSPACE) {
      movie.stop();
      mov.initActivity('c');
    }
  }

  //jumps to specific location by clicking on the time bar
  void jumpTo(float location) {
    float time = map(location, 2*PLAYER_MARGIN, width-2*PLAYER_MARGIN, 0, movie.duration());
    //println(formatTime(int(time)));
    movie.jump(time);
  }

  void copyFrame(PImage img, float location) {
    float newTime = map(location, 2*PLAYER_MARGIN, width-2*PLAYER_MARGIN, 0, movie.duration());
    float pTime = movie.time();
    movie.jump(newTime);
    if (movie.available()) {
      movie.read();
    }
    img.copy(movie, 0, 0, movie.width, movie.height, 0, 0, img.width, img.height);
    movie.jump(pTime);
  }

  void movieForward(int seconds) {
    showBarCount = THRESHOLD_BAR_COUNT;
    if (movie.time() < (movie.duration()-(seconds+0.2)))
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
}