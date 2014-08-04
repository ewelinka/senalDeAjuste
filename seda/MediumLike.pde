class MediumLike implements Scene
{   
  //http://processing.org/examples/distance2d.html

  // additional parameters specific for the scene
  float x;
  float y;
  float easing = 0.05;
  PImage like,dislike;
  boolean positive;
  int likes,dislikes;


  public MediumLike(){};

  // main functions
  void closeScene(){};

  void initialScene(){
    textSize(32);
    background(255);
    noStroke();
    dislike = loadImage("dislike.jpg");
    like = loadImage("like.png");
    positive = false;
    likes=0;
    dislikes =0;
    fill(50, 73, 140);
    textAlign(LEFT);
  }

  void drawScene(){
    background(255);

    likes = mouseX;
    dislikes = mouseY;
  
    float targetX = mouseX;
    float dx = targetX - x;
    if(abs(dx) > 1) {
      x += dx * easing;
    }
    
    float targetY = mouseY;
    float dy = targetY - y;
    if(abs(dy) > 1) {
      y += dy * easing;
    }
    if(positive){
      image(like, x-25, y-25);
      text(str(likes), x+35, y+15);
    } 
    else {
      image(dislike, x-25, y-25);
      text(str(dislikes), x+35, y+5);
    }
    //ellipse(x, y, 66, 66);
  };

  String getSceneName(){return "MediumLike";};

  void onPressedKey(String k){
    if(k == "toggle") positive = !positive;    
  };
  void onImg(PImage img){};

}

 


