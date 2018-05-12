class Button {
  private PImage buttonImg;
  private PVector center;
  private float bWidth;
  private float bHeight;  

  Button(String imgName) {
    buttonImg = loadImage(imgName);
    bWidth = buttonImg.width;
    bHeight = buttonImg.height;
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
    return bWidth;
  }

  float getHeight() {
    return bHeight;
  }

  boolean isOverButton() {
    return (mouseY < center.y+bHeight/2)&&(mouseY > center.y-bHeight/2)&&(mouseX < center.x+bWidth/2)&&(mouseX > center.x-bWidth/2);
  }

  boolean isClicked() {
    if (isOverButton()) 
      return true;
    else return false;
  }

  void hoverOverButton(boolean circularShape, float outerRadius) {
    fill(255,60);
    noStroke();
    if (circularShape) {
      ellipse(center.x, center.y, outerRadius, outerRadius);
    } else {
      rectMode(CENTER);
      rect(center.x, center.y, buttonImg.width, buttonImg.height, outerRadius);
      rectMode(CORNER);
    }
  }
}
