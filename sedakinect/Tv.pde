class Tv implements Scene
{   
  
  color[] main_bars={ 
    color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192)
  };

  int tv_width,tv_height;

  public Tv(){};

  void closeScene(){};

  void initialScene(){
    background(0);
    tv_width = width;
    tv_height = height;

    imgKinect = new PImage(context.depthWidth(),context.depthHeight(),ARGB); 
    imgKinect.loadPixels();
    bigImg = new PImage(width,height,ARGB); 
    bigImg.loadPixels();

  };

  void drawScene(){

    drawNoise();
    getMiddle();
    //getMostRightAndImg();
    drawTv(tv_width,tv_height,7,main_bars);
    //drawDancer();
    drawLine();

  };

  String getSceneName(){return "Tv";};

  void onPressedKey(String k){};

  void onImg(PImage img){};

  void drawNoise(){
    loadPixels();
    // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if(random(100)>50) pixels[x+y*width] = color(255);
        else pixels[x+y*width] = color(40);
      }
    }
    updatePixels();
  }

  void drawTv(int window_w, int window_h, int bars_nr, color[] colors) {
    noSmooth();
    noStroke();
    int bar_width = window_w / bars_nr +1;

    int whichBar;
    if(middle_x < 1) whichBar = -1;
    else whichBar = (int)(middle_x / bar_width);


    int x1, xM;
    xM = (int)(whichBar * bar_width);
    for (int i = 0; i < bars_nr; i ++) {
      fill(colors[i]);

      x1 = (int)(i * bar_width);
      if(xM != x1) rect(x1, 0, bar_width, window_h); 
    }
  }
}
