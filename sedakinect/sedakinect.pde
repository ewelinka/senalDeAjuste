import SimpleOpenNI.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import ddf.minim.*;
import processing.video.*;

Movie hbvideo;

SceneManager manager;
DancersManager dancers;
ArrayList<Character> numbers =new ArrayList<Character>();
// kinect stuff
SimpleOpenNI context;
PImage imgKinect,bigImg;

float closest_z;
float screen_xLeft,screen_xRight;
Minim minim;
float globalAlpha;

void setup(){
  size(1024, 768,P3D);
//  size(displayWidth, displayHeight, P3D);
  minim = new Minim (this);
  hbvideo = new Movie(this, "hb.mp4");


  globalAlpha = 0;

  numbers.add(0,'0');
  numbers.add(1,'1');
  numbers.add(2,'2');
  numbers.add(3,'3');
  numbers.add(4,'4');
  numbers.add(5,'5');
  numbers.add(6,'6');
  numbers.add(7,'7');
  numbers.add(8,'8');
  numbers.add(9,'9');

  manager = new SceneManager();  

  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  //context.setMirror(false);
  context.enableDepth();
  context.enableUser();

  closest_z =0;
  screen_xLeft = 38;
  screen_xRight = 768;

  dancers = new DancersManager(); 

}


void draw(){
  manager.actualScene.drawScene(); 
  drawGlobalAlpha();
}

void keyReleased(){
  if (keyCode == UP) manager.pressedKey("UP");
  if (keyCode == DOWN) manager.pressedKey("DOWN");
  if (keyCode == LEFT) manager.pressedKey("LEFT");
  if (keyCode == RIGHT) manager.pressedKey("RIGHT");

  if (key == 't') manager.pressedKey("toggle");
  if (key == 'r') manager.pressedKey("reset");

  if (key == 'q') manager.pressedKey("quit");
  if (key == 'w') manager.pressedKey("weight");

  if (key == 'm'){
    globalAlpha = max(globalAlpha-5, 0);
    println("globalAlpha "+globalAlpha);
  }
  if (key == 'n') {
    globalAlpha = min(globalAlpha+5,255);
    println("globalAlpha "+globalAlpha);
  }
  if (key == 'b') globalAlpha = 255;
  if (key == 'l') globalAlpha = 0;

  if(numbers.contains(key)) manager.activate(numbers.indexOf(key));

}

boolean sketchFullScreen() {
  return true;
}

float map_x(float x){
  if( x < screen_xLeft || x > screen_xRight ) return 0;
  else return map(x,screen_xLeft,screen_xRight,0,1024);
}

float map_y(float y){
  return map(y,0,480,0,768);
}

void drawGlobalAlpha(){
  fill(0, globalAlpha);
  noStroke();
  rect(0,0,width,height);
}
