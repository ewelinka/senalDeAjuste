
class TvMove implements Scene
{   
  int tv_width,tv_height;
  color[] main_bars={ 
    color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192)
  };
  float offset = 0;
  float easing = 0.05;
  PImage bg;
  float dx;
  

  public TvMove(){};

  void closeScene(){};

  void initialScene(){
    bg = loadImage("barras.png");
    background(bg);
  };

  void drawScene(){

    getDancers();
    // we will take middle value of random dancer
    float middle_x = dancers.getFirstDancerMiddle();
    //float middle_x = dancers.getRandomDancerMiddle()
    
    background(bg); 

    if(middle_x>0) dx = (middle_x-bg.width/2) - offset;
    else dx = - offset;
    
    offset += dx * easing; 
    tint(255, 127);  // Display at half opacity
    image(bg, offset, 0);
    //drawDancer();
    drawLine();

  };

  String getSceneName(){return "TvMove";};

  void onPressedKey(String k){
    if (k == "UP") upSpeed();
    if (k == "DOWN") downSpeed();
    
  };

  void upSpeed(){
    easing +=0.01;
    
  }
  void downSpeed(){
    easing = max(0.01, easing-0.01);
  }

  void onImg(PImage img){};

}
