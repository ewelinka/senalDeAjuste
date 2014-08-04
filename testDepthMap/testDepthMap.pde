import SimpleOpenNI.*;
import blobDetection.*;

SimpleOpenNI context;
PImage img,bigImg;


void setup()
{
  size(1024,768,P3D);  // strange, get drawing error in the cameraFrustum if i use P3D, in opengl there is no problem
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
  // enable skeleton generation for all joints
  img = new PImage(context.depthWidth(),context.depthHeight()); 
  img.loadPixels();
  bigImg = new PImage(width,height); 
  bigImg.loadPixels();


  println("setup ready, w: "+width+" h: "+height);
}

void draw()
{
  background(0,22);
  context.update();

  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();

  int steps = 1;
  int index;

  int maxH = height;

  float maxR = 0;
  int maxR_raw =0;
  float maxRight_y =0;


  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      int d = depthMap[index];
      if( d > 0){
        img.pixels[index] = color(map(d,353,10000,0,255));
         if(userMap[index] > 0)
         { 
           img.pixels[index] = color(map(d,353,10000,0,255),0,0);
           if (y < maxH){
             maxH = y;
           }
           if (x> maxR_raw){

              maxR = map(x,0,640,0,1024);
              maxR_raw = x;
              maxRight_y = map(y,0,480,0,768);
              println("new maxR "+maxR_raw);

           }
         }
      } 
      else img.pixels[index] = color(0,0,0);
    }
  } 
  img.updatePixels(); 


  bigImg.copy(img, 0, 0, 640, 480, 0, 0, width, height);
  image(bigImg,0,0);

  stroke(255,255,0);
  float newH = map(maxH,0,480,0,768);
  line(0,newH,width,newH);
  line(maxR,0,maxR,height);
  if(maxR < 600) textAlign(LEFT);
  else textAlign(RIGHT);
  fill(255,0,0);
  text(maxR_raw,maxR,maxRight_y);

}


