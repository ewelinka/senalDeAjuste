/*
Test of background substraction in IR
Api of simpleopneni: http://learning.codasign.com/index.php?title=Reference_for_Simple-OpenNI_and_the_Kinect
*/

import SimpleOpenNI.*;

SimpleOpenNI  context;
int irW,irH;
ArrayList<Star> stars;

void setup()
{
  context = new SimpleOpenNI(this);
  context.enableDepth();
  context.enableUser();
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  //willbe 640x480
  irW=640;
  irH=480;
  size(irW, irH,P3D);

  stars = new ArrayList<Star>();
  background(0);

}

void draw()
{
  background(0,22);
  context.update();
  
  //TODO for make this work we need extra IR light
  //image(context.userImage(), 0, 0);
  int[] u = context.userMap();

  for(int y =0; y<height;y+=15){
    for(int x =0; x<width;x+=15){
      int i= y*width + x;

      if(u[i]!=0){
        stars.add(new Star(x,y,0));
      }
    }
  }
   
  drawAndUpdateStars();
}


void drawAndUpdateStars(){
  for(int i = 0; i < stars.size(); i++) {
      Star s = stars.get(i);
      
      if (s.isDead()) stars.remove(i);      
      else s.drawAndUpdate();     
  }
}

class Star
{   
  PVector 
    vel,
    pos; 
  int 
    age;

  public Star(int x, int y, int z)
  {
    pos = new PVector(x,y,z);
    vel = new PVector(0,0,15);
    age = 200;
  }

  boolean isDead() 
    { return (age <= 0 || pos.x < 0 || pos.x >= width || pos.y < 0 || pos.y >= height || pos.z > 150); } 

  void drawAndUpdate() 
  { 
    fill(255,age);
    pushMatrix();
      translate(0, 0, -1 * pos.z);
      ellipse(pos.x, pos.y, 12, 12);
    popMatrix();
    
    pos.add(vel);
    age-=20;
  }
}
