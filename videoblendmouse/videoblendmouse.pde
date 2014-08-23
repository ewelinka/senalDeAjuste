import processing.video.*;
  
  int selMode = REPLACE;
  String name = "REPLACE";
  PImage lastFrame;
  Movie hbvideo;
  int picAlpha;

  void closeScene(){
    hbvideo.pause();
  };
  void setup(){
    size(1024,768);
    hbvideo = new Movie(this, "hb.mp4");
    hbvideo.loop();
    hbvideo.play();
    hbvideo.jump(0);
    lastFrame = hbvideo.get();
  };
  void draw(){
    //background(0);
    //fill(0,20);
    //rect(0,0,width,height);
    if (hbvideo.available()) {
      hbvideo.read();
    }  

      
    tint(255, 255);
    image(lastFrame, 0, 0, width, height);
    blendMode(selMode);  
    picAlpha = int(map(mouseX, 0, width, 0, 255));
    //tint(random(255),random(255),122,picAlpha);
    //tint(255,picAlpha);

    tint(map(mouseX,0,1024,0,255),map(mouseY,0,768,0,255),255,picAlpha);
    image(hbvideo, 0, 0, width, height);
    lastFrame = hbvideo.get();
    //lastFrame.copy(hbvideo,0,0,hbvideo.width,hbvideo.height,0,0,1024,768);
    blendMode(REPLACE); 
    fill(255);
  };

  String getSceneName(){return "HBVideo";};
  void keyReleased(){
    if (key == 't') {
      if (selMode == REPLACE) { 
        selMode = BLEND;
        name = "BLEND";
      } else if (selMode == BLEND) { 
        selMode = ADD;
        name = "ADD";
      } else if (selMode == ADD) { 
        selMode = SUBTRACT;
        name = "SUBTRACT";
      } else if (selMode == SUBTRACT) { 
        selMode = LIGHTEST;
        name = "LIGHTEST";
      } else if (selMode == LIGHTEST) { 
        selMode = DARKEST;
        name = "DARKEST";
      } else if (selMode == DARKEST) { 
        selMode = DIFFERENCE;
        name = "DIFFERENCE";
      } else if (selMode == DIFFERENCE) { 
        selMode = EXCLUSION;  
        name = "EXCLUSION";
      } else if (selMode == EXCLUSION) { 
        selMode = MULTIPLY;  
        name = "MULTIPLY";
      } else if (selMode == MULTIPLY) { 
        selMode = SCREEN;
        name = "SCREEN";
      } else if (selMode == SCREEN) { 
        selMode = REPLACE;
        name = "REPLACE";
      }
    }
  }

  void onImg(PImage img){};

