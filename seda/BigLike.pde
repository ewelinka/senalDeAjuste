class BigLike implements Scene
{   

  PImage like;
  int likes;
  int fontSize;


  public BigLike(){};

  // main functions
  void closeScene(){};

  void initialScene(){
    fontSize = 150;
    textSize(fontSize);
    background(255);
    noStroke();
    like = loadImage("bLike.jpeg");
    likes=0;
    fill(50, 73, 140);
    textAlign(CENTER);
  }

  void drawScene(){
    background(like);

    likes = mouseX;  
    text(str(likes), 600, 550);
  };

  String getSceneName(){return "BigLike";};

  void onPressedKey(String k){
    if(k == "UP"){
      fontSize +=1;
      println("new font size "+fontSize); 
      textSize(fontSize);
    }  

    if(k == "DOWN"){
      fontSize -=1;
      println("new font size "+fontSize); 
      textSize(fontSize);
    }   
  };
  void onImg(PImage img){};

}

 


