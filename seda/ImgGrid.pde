class ImgGrid implements Scene
{   
  PImage myImg;
  color[] pixelColors;
  color[] pixelColors2;
  int scanLine;  // vertical position

  // 2D Array of objects
  Cell[][] grid;
  int cellsize = 60;

  // Number of columns and rows in the grid
  int cols;
  int rows;
  public ImgGrid(){};

  void closeScene(){};
  void initialScene(){
    myImg = loadImage("testcard.png");

    cols = width/cellsize;
    rows = height/cellsize;
  
    grid = new Cell[cols][rows];
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Initialize each object
        grid[i][j] = new Cell(i*cellsize,j*cellsize,cellsize,cellsize,i+j);
      }
    }

    pixelColors = new color[cols];
    pixelColors2 = new color[rows];
    scanLine = 0;
    smooth(4);
  };
  void drawScene(){
    background(0);

    // read the colours for the current scanLine
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        pixelColors[i] = myImg.get(20+i*35, scanLine);
        pixelColors2[j] = myImg.get(j*35, scanLine);
      }
    }

    // draw the image
    image(myImg, 0, 0);
    
    // increment scan line position every second frame
    if (frameCount % 4 == 0) {
      scanLine ++;
    }

    if (scanLine > height) {
      scanLine = 0;
    }

    // draw the sampled pixels as grid
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        noStroke();
        if(i % 2 == 0) {
          fill(pixelColors[i], random(100, 255));
        } else {
          fill(pixelColors2[j], random(100, 255));
        }
        //rect(i*cellsize, j*cellsize, cellsize, cellsize);
        rect(i*cellsize-random(15), j*cellsize-random(-5,5), cellsize, cellsize);
      }
    }
    
      // The counter variables i and j are also the column and row numbers and 
    // are used as arguments to the constructor for each object in the grid.  
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Oscillate and display each object
        grid[i][j].oscillate();
        grid[i][j].display();
      }
    }
  };
  String getSceneName(){return "ImgGrid";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

  // A Cell object
  class Cell {
    // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
    float x,y;   // x,y location
    float w,h;   // width and height
    float angle; // angle for oscillating brightness

    // Cell Constructor
    Cell(float tempX, float tempY, float tempW, float tempH, float tempAngle) {
      x = tempX;
      y = tempY;
      w = tempW;
      h = tempH;
      angle = tempAngle;
    } 
    
    // Oscillation means increase angle
    void oscillate() {
      angle += 0.06; //0.02; 
    }

    void display() {
  //    stroke(180);
      noStroke();
      // Color calculated using sine wave
  //    fill(127+127*sin(angle));
    for (int i=0; i< cols; i++) {
      fill(pixelColors[i], 180*sin(angle));
    }
      rect(x,y,w,h); 
    }
  }

}







