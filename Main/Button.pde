class Button {
  PImage buttonImg;
  PVector topleft;
  PVector bottomright;

  Button(String imgName) {
    buttonImg = loadImage(imgName);
  }

  void draw(float marginX, float marginY) {
    image(buttonImg, marginX, marginY);
    topleft = new PVector(marginX, marginY);
    bottomright = new PVector(marginX+buttonImg.width, marginY+buttonImg.height);
  }

  void draw(float marginX, float marginY, int bgcolor) {
    fill(bgcolor);
    rect(marginX, marginY, buttonImg.width, buttonImg.height);
    image(buttonImg, marginX, marginY);
    topleft = new PVector(marginX, marginY);
    bottomright = new PVector(marginX+buttonImg.width, marginY+buttonImg.height);
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
    if ((mouseY < bottomright.y)&&(mouseY > topleft.y)&&(mouseX < bottomright.x)&&(mouseX > topleft.x)) 
      return true;
    else return false;
  }
}