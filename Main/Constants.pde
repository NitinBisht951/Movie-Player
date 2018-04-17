//Constants for CANVAS, VIDEOBAR and INFOBAR
final static float DISPLAY_WIDTH = 1366;
final static float DISPLAY_HEIGHT = 768;
final static float CANVAS_MARGIN = 25;

final static int NO_OF_ROWS = 3;
final static int NO_OF_COLS = 3;
final static int NO_OF_VIDS = NO_OF_ROWS*NO_OF_COLS;

final static float CANVAS_LEFT_MARGIN = 2*CANVAS_MARGIN;
final static float CANVAS_TOP_MARGIN = 7*CANVAS_MARGIN;

final static float VID_LIST_BOX_FACTOR = 2.0/3;              
final static float VID_LIST_BOX_WIDTH = VID_LIST_BOX_FACTOR * DISPLAY_WIDTH;
final static float VID_DISPLAYER_WIDTH = (VID_LIST_BOX_WIDTH - 6*CANVAS_MARGIN)/NO_OF_COLS;
final static float VID_DISPLAYER_HEIGHT = (DISPLAY_HEIGHT - 11*CANVAS_MARGIN)/NO_OF_ROWS;

final static float TITLE_MARGIN_FACTOR = 0.85;

final static float LIGHT_WEIGHT = 3;
final static float HEAVY_WEIGHT = 5;


final static color BACKGROUND_COLOR = #1D0339;
final static color VIDEODISPLAYER_COLOR = #7722D3;   //#7722D3  #0A08FF
final static color VIDEODISPLAYER_STROKE_COLOR = #FFFFFF;

//different viewing modes of videoBars in Canvas
final static boolean GRID_VIEW = true;
final static boolean SINGLE_VIEW = false;



//For Player

final static int SCALE = 5;
final static float HSCALE = SCALE/0.80;
final static float PLAYER_MARGIN = 20;

final static float MIN_PLAYBACK_SPEED = 0.20;
final static float MAX_PLAYBACK_SPEED = 2.00;
final static int THRESHOLD_BAR_COUNT = 200;

final static int NO_OF_SNAPSHOTS = 80;
final static char SPACE = ' ';


//For button
final static String OPEN_BUTTON = "open_button.png";

final static String FOLDER_WHITE_SMALL = "folder_white_small.png";
final static String FOLDER_WHITE_MEDIUM = "folder_white_medium.png";
final static String FOLDER_BLACK_SMALL = "folder_black_small.png";
final static String FOLDER_BLACK_MEDIUM = "folder_black_medium.png";

final static String PLAY_SMALL = "play_small.png";
final static String PLAY_MEDIUM = "play_medium.png";
final static String PLAY_LARGE = "play_large.png";
final static String PLAY_BLACK_SMALL = "play_black_small.png";
final static String PLAY_BLACK_MEDIUM = "play_black_medium.png";
final static String PLAY_CIRCLE_SMALL = "play_circle_small.png";
final static String PLAY_CIRCLE_MEDIUM = "play_circle_medium.png";

final static String CLOSE_SMALL = "close_small.png";
final static String CLOSE_MEDIUM = "close_medium.png";
final static String CLOSE_LARGE = "close_large.png";
final static String CLOSE_CIRCLE_SMALL = "close_circle_small.png";

final static String PAUSE_SMALL = "pause_small.png";
final static String PAUSE_MEDIUM = "pause_medium.png";
final static String PAUSE_LARGE = "pause_large.png";

final static String LEFT_BUTTON = "left_button.png";
final static String RIGHT_BUTTON = "right_button.png";

final static String VIEW_MODE_LARGE = "view_mode_large.png";
final static String VIEW_MODE_SMALL = "view_mode_small.png";