// This is the ultimate class of the program which
// encompasses all the other small activity

class MoviePlayer {
  Canvas canvas;
  Player player;

  String[] movienames;
  Movie[] movies = new Movie[NO_OF_VIDS];

  MoviePlayer(PApplet sketch) {
    String path = sketchPath()+"/vids/";
    movienames = listFileNames(path);
    String movieFullPath = path + movienames[0];
    println(movieFullPath);
    canvas = new Canvas();
    player = new Player(sketch, movieFullPath);
  }

  void init() {
    initActivity();
  }

  void start() {
    if (canvas.isActive()) {
      canvas.show();
    } else if (player.isActive()) {
      player.play();
    }
  }

  void initActivity() {
    canvas.enable();
    player.disable();
    //preview.disable();
  }

  void mouseClicked() {
    if (canvas.isActive()) canvas.mouseClicked();
    //else if(preview.isActive()) preview.mouseClicked();
    else if (player.isActive()) player.mouseClicked();
  }

  void keyPressed() {
    if (canvas.isActive()) canvas.keyPressed();
    //else if(preview.isActive()) preview.keyPressed();
    else if (player.isActive()) player.keyPressed();
  }

  void mouseMoved() {
    if (player.isActive()) player.mouseMoved();
  }
}