class Points implements Scene
{   
  //http://processing.org/examples/distance2d.html

  // additional parameters specific for the scene
  float max_distance;
  PImage bg;

  public Points(){};

  // main functions
  void closeScene(){};

  void initialScene(){
    background(0);
    noStroke();
    max_distance = dist(0, 0, width, height);
    bg = loadImage("testcard.png");
  };

  void drawScene(){
    background(bg);
    //smooth();
    for(int i = 0; i <= width; i += 20) {
      for(int j = 0; j <= height; j += 20) {
        float size = dist(mouseX, mouseY, i, j);
        size = size/max_distance * 66;
        //fill(random(255),random(255),random(255));
        fill(0);
        ellipse(i, j, size, size);
      }
    }
  };

  String getSceneName(){return "Points";};

  void onPressedKey(String k){};
  void onImg(PImage img){};

}
