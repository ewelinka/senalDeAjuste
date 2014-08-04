import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class testBarrasPersonaMiddle extends PApplet {




SimpleOpenNI context;
PImage imgKinect,bigImg;
float middle_x,middle_y,maxRight_x,maxRight_y,maxLeft_x,maxLeft_y;
float raw_x;

// additional parameters specific for the scene
int[] main_bars={ 
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
public void closeScene(){};

public void setup(){
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

public void draw(){

  drawNoise();
  getMiddle();
  drawTv(tv_width,tv_height,7,main_bars);
  image(bigImg,0,0);
  //yellow
  stroke(255,255,0);
  line(middle_x,0,middle_x,height);
    //red
  stroke(255,0,0);
  line(maxRight_x,0,maxRight_x,height);
  if(maxRight_x < 600) textAlign(LEFT);
  else textAlign(RIGHT);
  fill(0);
  text(raw_x,maxRight_x,maxRight_y);
    //green
  stroke(0,255,0);
  line(maxLeft_x,0,maxLeft_x,height);
};

public String getSceneName(){return "Tv";};

public void onPressedKey(String k){};

public void onImg(PImage img){};

public void drawNoise(){
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


public void drawTv(int window_w, int window_h, int bars_nr, int[] colors) {
  noSmooth();
  noStroke();
  int bar_width = window_w / bars_nr +1;

  int whichBar;
  if(middle_x < 1) whichBar = -1;
  else whichBar = (int)(middle_x / bar_width);


  int x1, xM;
  xM = (int)(whichBar * bar_width);
  for (int i = 0; i < bars_nr; i ++) {
    fill(colors[i]);

    x1 = (int)(i * bar_width);
    if(xM != x1) rect(x1, 0, bar_width, window_h); 
  }
}

public void getMiddle(){
  context.update();
  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();
  int steps = 1;
  int index;

  maxRight_x=0;
  maxRight_y = 0;
  maxLeft_x =0;
  maxLeft_y = 0;
  middle_x = middle_y = 0;

  boolean gotOne = false;

  for(int x=0;x < context.depthWidth() && !gotOne;x+=steps)
  {
    for(int y=0;y < context.depthHeight() && !gotOne;y+=steps)
    {
      index = x + y * context.depthWidth();
      int d = depthMap[index];
      if(d>0){
        if(userMap[index] > 0)
        { 
          maxLeft_x = map(x,0,640,0,1024);
          maxLeft_y = map(y,0,480,0,768);
          //println("got left "+maxLeft_x+" "+maxLeft_y);
          gotOne = true;
        }
      }
    }
  } 
  // if we have found some "user" it make sence to look his most right point
  if(gotOne){
    //println("got left now looking for right");
    gotOne =false;
    for(int x=(context.depthWidth()-1);x > 0 && !gotOne;x-=steps)
    {
      for(int y=0;y < context.depthHeight() && !gotOne;y+=steps)
      {
        index = x + y * context.depthWidth();
        int d = depthMap[index];
        if(d>0){
           if(userMap[index] > 0)
           { 
              raw_x = x;
              maxRight_x = map(x,0,640,0,1024);
              maxRight_y = map(y,0,480,0,768);

              middle_x = min(maxLeft_x,maxRight_x) + abs(maxLeft_x - maxRight_x)/2;
              middle_y = min(maxLeft_y,maxRight_y) + abs(maxLeft_y - maxRight_y)/2;
              println("middle "+middle_x+" "+middle_y);

              gotOne = true;
           }
        }
      }
    }
  }

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
         }
      } 
    }
  } 
  imgKinect.updatePixels(); 
  bigImg.copy(imgKinect, 0, 0, 640, 480, 0, 0, width, height);
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "testBarrasPersonaMiddle" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
