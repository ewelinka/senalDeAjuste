import processing.video.*;
import SimpleOpenNI.*;

SimpleOpenNI  context;

  int selMode = REPLACE;
  String name = "REPLACE";
  PImage lastFrame;
  Movie hbvideo;
  int picAlpha;

  void closeScene(){
    hbvideo.pause();
  };
  void setup(){
    size(1024,768,P3D);
    hbvideo = new Movie(this, "hb.mp4");
    hbvideo.loop();
    hbvideo.play();
    hbvideo.jump(0);
    lastFrame = hbvideo.get();
    context = new SimpleOpenNI(this);
    context.enableDepth();
    context.enableUser();
    if(context.isInit() == false)
    {
       println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
       exit();
       return;  
    }
  };
  void draw(){
    background(0);
    //fill(0,20);
    //rect(0,0,width,height);
    if (hbvideo.available()) {
      hbvideo.read();
    }  
    lastFrame =getBigImage();
      
    tint(255, 255);
    image(lastFrame, 0, 0, width, height);
    blendMode(selMode);  
    picAlpha = int(map(mouseX, 0, width, 0, 255));
    //tint(random(255),random(255),122,picAlpha);
    tint(255,picAlpha);

   // tint(0,255,0,picAlpha);
    image(hbvideo, 0, 0, width, height);
    //lastFrame = hbvideo.get();
    //lastFrame.copy(hbvideo,0,0,hbvideo.width,hbvideo.height,0,0,1024,768);
    // blendMode(REPLACE); 
    // fill(255);
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


PImage getBigImage(){
  PImage img = new PImage(context.depthWidth(),context.depthHeight()); 
  img.loadPixels();
  PImage bigImg = new PImage(width,height); 
  bigImg.loadPixels();
  context.update();

  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();

  int steps = 1;
  int index;


  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      img.pixels[index] = color(255);
      int d = depthMap[index];
      if( d > 0){
        if(userMap[index]>0){
          float r = map(x, 0, width, 0, 255);
          float b = map(y, 0, height, 0, 255);
          img.pixels[index] = color(r,0,b);
        }
      } 
    }
  } 
  img.updatePixels(); 

  bigImg.copy(img, 0, 0, 640, 480, 0, 0, width, height);
  return bigImg;

}



