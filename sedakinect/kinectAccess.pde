// RIGHT
void getMostRight(){
  context.update();
  int[]   userMap = context.userMap();
  int steps = 1;
  int index;
 float  maxRight_x = 0;
 float maxRight_y = 0;

  boolean gotOne =false;
  for(int x=(context.depthWidth()-1);x > 0 && !gotOne;x-=steps)
    {
    for(int y=0;y < context.depthHeight() && !gotOne;y+=steps)
    {
      index = x + y * context.depthWidth();

      if(userMap[index] > 0)
      { 
        maxRight_x = map_x(x);
        maxRight_y = map_y(y);

        gotOne = true;
      }
    }
  }
}


void drawDancer(){
  image(bigImg,0,0);
  stroke(255,255,0);
  //line(maxRight_x,0,maxRight_x,height);
}


void drawLine(){
  stroke(0,255,0);
  for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {
    Dancer da = idancer.getValue();
    float middle_x = da.getMiddle();
    line(middle_x,0,middle_x,height);
    ellipse(middle_x, da.top,10,10);
  }
}

void drawRightLine(){
  stroke(0,255,0);
  PVector pos = dancers.getFirstDancerRight();
  line(pos.x,0,pos.x,height);
  ellipse(pos.x, pos.y,10,10);  
}

void drawRightPoint(){
  stroke(0,255,0);
  fill(255,255,0);
  PVector pos = dancers.getFirstDancerRight();
  ellipse(pos.x, pos.y,10,10);  
}

//DEPTH
void getClosest(){
  context.update();
  int[]   userMap = context.userMap();
  int[]   depthMap = context.depthMap();
 
  int steps = 1;
  int index;
  closest_z = 0;

  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      int d = depthMap[index];
       if(userMap[index] > 0)
       { 
        if((d > 0) && (d > closest_z)) closest_z = d;
       }
    }
  } 
  //closest_z = map(closest_z,300,10000,0,100);
}


void getDancers(){
  dancers.cleanHm();
  context.update();
  int[]   userMap = context.userMap();
  int[]   depthMap = context.depthMap();
  int steps = 1;
  int index;

  for(int x=0;x <context.depthWidth();x+=steps)
  {
    for(int y=0;y < context.depthHeight() ;y+=steps)
    {
      index = x + y * context.depthWidth();
      int d = depthMap[index];
      if(d>0){
        int userNr =userMap[index];
        if( userNr > 0)
        { 
          dancers.updateDancer(userNr,x,y,d);
        }
      }
    }
  }
  dancers.rescale();
}




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













// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}