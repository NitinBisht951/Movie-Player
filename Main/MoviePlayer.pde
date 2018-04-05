// This is the ultimate class of the program which
// encompasses all the other small activity

class MoviePlayer {
  Canvas canvas;                      //the first open video activity
  Player player;                      // the video playing video

  String[] movienames;
  Movie[] movies = new Movie[NO_OF_VIDS];
  Movie tempMovie;

  MoviePlayer() {
    movienames = listFileNames(sketchPath);
    int i = 0;
    if (movienames[i].indexOf(".mp4") >= 0 || movienames[i].indexOf(".MP4") >= 0 );
    else exit();

    String movieFullPath = sketchPath + movienames[i];

    println(movieFullPath);
    canvas = new Canvas();
    player = new Player(movieFullPath);
    initActivity('c');
  }

  void start() {
    background(0);
    if (canvas.isActive()) {
      canvas.show();
    } else if (player.isActive()) {
      player.begin();
    }
  }

  void initActivity(char choice) {
    if (choice == 'c') {
      canvas.enable();
      player.disable();
    } else if (choice =='p') { 
      canvas.disable();
      player.enable();
    }
  }

  void mouseClicked() {
    if (canvas.isActive()) canvas.mouseClicked();
    else if (player.isActive()) player.mouseClicked();
  }

  void keyPressed() {
    if (canvas.isActive()) canvas.keyPressed();
    else if (player.isActive()) player.keyPressed();
  }

  void mouseMoved() {
    if (player.isActive()) player.mouseMoved();
  }
}