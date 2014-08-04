import SimpleOpenNI.*;


SimpleOpenNI context;
PImage imgKinect,bigImg;
float maxR;

// additional parameters specific for the scene
color[] main_bars={ 
  color(192,192,192), 
  color(192,192,0), 
  color(0,192,192), 
  color(0,192,0),
  color(192,0,192),
  color(192,0,0),
  color(0,0,192)
};

int tv_width,tv_height;



// main functions
void closeScene(){};

void setup(){
  size(1024, 768,P3D);
  background(0);
  tv_width = width;
  tv_height = height;
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  // disable mirror
  //context.setMirror(false);

  // enable depthMap generation 
  context.enableDepth();
  context.enableUser();

  imgKinect = new PImage(context.depthWidth(),context.depthHeight(),ARGB); 
  imgKinect.loadPixels();
  bigImg = new PImage(width,height,ARGB); 
  bigImg.loadPixels();

};

void draw(){

  drawNoise();
  getMostRight();
  drawTv(tv_width,tv_height,7,main_bars);
  image(bigImg,0,0);
  stroke(255,255,0);

  line(maxR,0,maxR,height);
};

String getSceneName(){return "Tv";};

void onPressedKey(String k){};

void onImg(PImage img){};

void drawNoise(){
  loadPixels();
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      if(random(100)>50) pixels[x+y*width] = color(255);
      else pixels[x+y*width] = color(40);
    }
  }
  updatePixels();
}

void getMostRight(){
  context.update();
  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();

  int steps = 1;
  int index;
  maxR = 0;

  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      int d = depthMap[index];
      imgKinect.pixels[index] = color(255,255,255,0);
      if( d > 0){      
         if(userMap[index] > 0)
         { 
           imgKinect.pixels[index] = color(map(d,353,10000,0,255),0,0,100);
           if (x > maxR) maxR = x;
         }
      } 
    }
  } 
  maxR = map(maxR,0,640,0,1024);
  imgKinect.updatePixels(); 
  bigImg.copy(imgKinect, 0, 0, 640, 480, 0, 0, width, height);

}

void drawTv(int window_w, int window_h, int bars_nr, color[] colors) {
  noSmooth();
  noStroke();
  int bar_width = window_w / bars_nr +1;

  int whichBar;
  if(maxR < 1) whichBar = -1;
  else whichBar = (int)(maxR / bar_width);


  int x1, xM;
  xM = (int)(whichBar * bar_width);
  for (int i = 0; i < bars_nr; i ++) {
    fill(colors[i]);

    x1 = (int)(i * bar_width);
    if(xM != x1) rect(x1, 0, bar_width, window_h); 
  }
}

