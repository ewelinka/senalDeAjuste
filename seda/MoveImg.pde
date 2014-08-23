class MoveImg implements Scene
{   
  //http://processing.org/examples/distance2d.html

  // additional parameters specific for the scene
  float offset = 0;
  float easing = 0.05;
  PImage bg;

  public MoveImg(){};

  // main functions
  void closeScene(){};

  void initialScene(){
    background(0);
    noStroke();
    bg = loadImage("testcard.png");
  };

  void drawScene(){
    image(bg, 0, 0); 
    float dx = (mouseX-bg.width/2) - offset;
    offset += dx * easing; 
    tint(255, 127);  // Display at half opacity
    image(bg, offset, 0);
  };

  String getSceneName(){return "MoveImg";};

  
  void onPressedKey(String k){
    if (k == "UP") upSpeed();

    if (k == "DOWN") downSpeed();
    //
    // if (k == "RIGHT") this.radius += 5;
    // if (k == "LEFT") this.radius = max(10,this.radius-=5);
    
  };

  void upSpeed(){
    easing +=0.01;
    
  }
  void downSpeed(){
    easing = max(0.01, easing-0.01);
  }

  void onImg(PImage img){};

}
