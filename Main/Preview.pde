// This class shows the preview i.e., images from a movie
// like a sample

class Preview {
  private VideoDisplayer activeVideo;

  Preview() {
    activeVideo = new VideoDisplayer("Title", "Path", new PVector(CANVAS_LEFT_MARGIN, CANVAS_TOP_MARGIN), VIDEO_BAR_WIDTH-4*CANVAS_MARGIN, DISPLAY_HEIGHT-9*CANVAS_MARGIN);
  }

  void draw() {
    activeVideo.draw();
  }

}