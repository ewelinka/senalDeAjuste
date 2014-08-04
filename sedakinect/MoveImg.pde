class MoveImg implements Scene
{   
  //http://processing.org/examples/distance2d.html

  // additional parameters specific for the scene
  float offset = 0;
  float easing = 0.05;
  PImage bg;
  float dx;

  public MoveImg(){};

  // main functions
  void closeScene(){};

  void initialScene(){
    background(0);
    noStroke();
    bg = loadImage("testcard.png");
  };

  void drawScene(){
    //getMostRightAndImg();
    getMiddle();
    image(bg, 0, 0); 

    if(middle_x>0) dx = (middle_x-bg.width/2) - offset;
    else dx = 0;
    offset += dx * easing; 
    tint(255, 127);  // Display at half opacity
    image(bg, offset, 0);
    //drawDancer();
    drawLine();
  };

  String getSceneName(){return "MoveImg";};

  void onPressedKey(String k){};

  void onImg(PImage img){};

}
