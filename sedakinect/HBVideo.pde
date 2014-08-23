class HBVideo implements Scene
{   
  PImage bg;

  public HBVideo(){};

  void closeScene(){
    hbvideo.pause();
  };
  void initialScene(){
    bg = loadImage("testcard.png");
    hbvideo.loop();
    hbvideo.play();
    hbvideo.jump(0);
  };
  void drawScene(){
    getDancers();
    if (hbvideo.available()) {
      hbvideo.read();
    }  
    PVector pos = dancers.getFirstDancerRight();
    tint(255,255);
    image(bg,0,0);
    tint(map(pos.x,0,1024,0,255),map(pos.y,0,768,0,255),0,map(pos.x,0,1024,0,255));
    image(hbvideo, 0, 0, width, height);
    drawRightPoint();

  };
  String getSceneName(){return "HBVideo";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

}