// This class provides the activeness of a window and provides enabling
//  and disabling the window
class Activeness {
  protected boolean isActive = false;

  void enable() {
    isActive = true;
  }

  void disable() {
    isActive = false;
  }
  
  //returns whether the current window is active on the screen
  boolean isActive() {
    return isActive;
  }
  
  void toggle() {
    isActive = !isActive;
  }
}
