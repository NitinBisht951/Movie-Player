class SubtitleReader extends Activeness {
  String[] subtitleText;
  String fullPath;
  PVector centerPosition;

  String currentSubtitle;
  int count;                            //current no. of subtitle
  float startTime;                      //start time of showing current subtitle
  float endTime;                        //end time of showing current subtitle

  int lastSubtitleIndex;

  SubtitleReader(String fullPath, PVector centerPosition) {
    init(fullPath);
    this.centerPosition = centerPosition;
  }

  void init(String fullPath) {
    this.count = 0;
    this.fullPath = fullPath;
    this.startTime = 0;
    this.endTime = 0;
    this.lastSubtitleIndex = 0;
    isActive = true;
    subtitleText = loadStrings(fullPath);
  }

  private void setTimings(int index) {
    int[] t = int(splitTokens(subtitleText[index], ":,-> "));
    startTime = t[0]*3600.0 + t[1]*60.0 + t[2] + t[3]/1000.0;
    endTime = t[4]*3600.0 + t[5]*60.0 + t[6] + t[7]/1000.0;
  }

  void readNextSubtitle() {
    currentSubtitle = "";
    count++;
    for (int i = lastSubtitleIndex; i < subtitleText.length-1; i++) {
      //println(int(subtitleText[i]));
      if (count == 2) { 
        println("true"); 
        count = int(subtitleText[i]);
      }
      if (int(subtitleText[i]) == count || i == 0) {
        setTimings(i+1);
        for (int j = i+2; j < subtitleText.length-1; j++) {
          currentSubtitle += subtitleText[j] ;
          if (int(subtitleText[j+1]) == count+1) {
            lastSubtitleIndex = j+1;
            break;
          }
          currentSubtitle += "\n";
        }
        break;
      }
    }
  }

  void show(float movieCurrentTime) {
    pushStyle();
    textAlign(CENTER);
    textFont(SEGOEUI_FONT);
    if (movieCurrentTime > startTime && movieCurrentTime < endTime) {
      text(currentSubtitle, centerPosition.x, centerPosition.y);
    } else if (movieCurrentTime <= startTime) {
      //do nothing, just wait
    } else if (movieCurrentTime >= endTime) {
      //get next subtitle, update count, startTime and endTime
      readNextSubtitle();
    }
    popStyle();
  }

  //change subtitle if there is wrong one at present 
  void change(String subtitlePath) {
    init(subtitlePath);
  }
}
