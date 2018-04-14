class Button {
  PImage buttonImg;
  PVector center;

  Button(String imgName) {
    buttonImg = loadImage(imgName);
  }

  void draw(float centerX, float centerY) {
    center = new PVector(centerX, centerY);
    imageMode(CENTER);
    image(buttonImg, centerX, centerY);
    imageMode(CORNER);              //default
  }

  void draw(float centerX, float centerY, int bgcolor) {
    fill(bgcolor);
    rectMode(CENTER);
    rect(centerX, centerY, buttonImg.width, buttonImg.height);
    rectMode(CORNER);
    draw(centerX, centerY);
  }

  void changeImg(String imgName) {
    buttonImg = loadImage(imgName);
  }

  float getWidth() {
    return buttonImg.width;
  }

  float getHeight() {
    return buttonImg.height;
  }

  boolean isClicked() {
    if ((mouseY < center.y+buttonImg.height/2)&&(mouseY > center.y-buttonImg.height/2)&&(mouseX < center.x+buttonImg.width/2)&&(mouseX > center.x-buttonImg.width/2)) 
      return true;
    else return false;
  }
}