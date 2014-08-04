class BigLike implements Scene
{   

  PImage like;
  int likes;


  public BigLike(){};

  // main functions
  void closeScene(){};

  void initialScene(){
    textSize(150);
    background(255);
    noStroke();
    like = loadImage("bLike.jpeg");
    likes=0;
    fill(50, 73, 140);
    textAlign(CENTER);
  }

  void drawScene(){
    background(like);
    getClosest();
    if (closest_z > 0 ){
      likes = (int)closest_z;
    }
 
    text(str(likes), 600, 550);
  };

  String getSceneName(){return "BigLike";};

  void onPressedKey(String k){};
  void onImg(PImage img){};

}

 


