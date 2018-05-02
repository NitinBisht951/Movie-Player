class SubtitleReader extends Activeness {
  String[] subtitle;
  String fullPath;
  PVector centerPosition;

  String currentSubtitle;
  int count;                            //current no. of subtitle
  float startTime;                      //start time of showing current subtitle
  float endTime;                        //end time of showing current subtitle

  int lastIndex;

  SubtitleReader(String fullPath, PVector centerPosition) {
    init(fullPath);
    this.centerPosition = centerPosition;
  }

  void init(String fullPath) {
    this.count = 0;
    this.fullPath = fullPath;
    this.startTime = 0;
    this.endTime = 0;
    this.lastIndex = 0;
    isActive = true;
    subtitle = loadStrings(fullPath);
  }

  private void setTimings(int index) {
    int[] t = int(splitTokens(subtitle[index], ":,-> "));
    startTime = t[0]*3600.0 + t[1]*60.0 + t[2] + t[3]/1000.0;
    endTime = t[4]*3600.0 + t[5]*60.0 + t[6] + t[7]/1000.0;
  }

  void readNextSubtitle() {
    currentSubtitle = "";
    count++;
    for (int i = lastIndex; i < subtitle.length-1; i++) {
      if (int(subtitle[i]) == count || i == 0) {
        setTimings(i+1);
        for (int j = i+2; j < subtitle.length; ) {
          currentSubtitle += subtitle[j] ;
          if (int(subtitle[++j]) == count+1) {
            lastIndex = j;
            break;
          }
          currentSubtitle += "\n";
        }
        break;
      }
    }
  }

  void show(float movieCurrentTime) {
    textAlign(CENTER);
    textSize(28);
    if (movieCurrentTime > startTime && movieCurrentTime < endTime) {
      text(currentSubtitle, centerPosition.x, centerPosition.y);
    } else if (movieCurrentTime <= startTime) {
      //do nothing, just wait
    } else if (movieCurrentTime >= endTime) {
      //get next subtitle, update count, startTime and endTime
      readNextSubtitle();
    }
  }

  //change subtitle if there is wrong one at present 
  void change(String subtitlePath) {
    init(subtitlePath);
  }
}
