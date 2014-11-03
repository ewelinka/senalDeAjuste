void contextupdate(){
  context.update();
}
// RIGHT
// void getMostRight(){
//   contextupdate();
//   int[]   userMap = context.userMap();
//   int steps = 1;
//   int index;
//  float  maxRight_x = 0;
//  float maxRight_y = 0;

//   boolean gotOne =false;
//   for(int x=(context.depthWidth()-1);x > 0 && !gotOne;x-=steps)
//     {
//     for(int y=0;y < context.depthHeight() && !gotOne;y+=steps)
//     {
//       index = x + y * context.depthWidth();

//       if(userMap[index] > 0)
//       { 
//         maxRight_x = map_x(x);
//         maxRight_y = map_y(y);

//         gotOne = true;
//       }
//     }
//   }
// }


void drawDancer(){
  image(bigImg,0,0);
  stroke(255,255,0);
  //line(maxRight_x,0,maxRight_x,height);
}


void drawLine(){
  // stroke(0,255,0);
  // strokeWeight(1);
  // for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {
  //   Dancer da = idancer.getValue();
  //   float middle_x = da.getMiddle();
  //   line(middle_x,0,middle_x,height);
  //   ellipse(middle_x, da.top,10,10);
  // }
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

void drawFDMiddleAndTopPoint(){
  stroke(0,255,0);
  fill(255,255,0);
  PVector pos = dancers.getFirstDancerMiddleAndTop();
  ellipse(pos.x, pos.y,10,10);  
}


//DEPTH
void getClosest(){
  contextupdate();
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


void getDancersOrg(){
  dancers.cleanHm();
  contextupdate();
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

void getDancers(){
  dancers.cleanHm();
  contextupdate();
  int[]   userMap = context.userMap();
  int[]   depthMap = context.depthMap();
  int [] alternatives = new int[context.depthWidth()];
  int [] alterDepths  = new int[context.depthWidth()];

  int steps = 1;
  int index;

  boolean hasAlternatives = false;

  for(int x=0;x <context.depthWidth();x+=steps)
  {
    // initialize this field with 0
    alternatives[x] = 0;
    alterDepths[x] = 8000;
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
        // alternative
        if((d<3680) && (y < 570)){
          hasAlternatives =true;
          alternatives[x]+=1;
          if (d < alterDepths[x]) alterDepths[x] = d;
        }
      }
    }
  }
  if(!dancers.hasDancers()){
    // we use alternatives
    if(hasAlternatives) getDancersFromAlternatives(alternatives, alterDepths);
  }

  dancers.rescale();
}

void getDancersFromAlternatives(int [] alter, int [] alterZ){
  int dancerIdx = 1;
  boolean hasSomething = true;
  int sizeOfSomething = 0;
  int startIdx = 0;
  int verticalSum = 0;

  for(int x=0;x <context.depthWidth();x+=1){
    if((alter[x]>0) && !(alter[x]==8000)){
      if(!hasSomething) startIdx = x;
      sizeOfSomething+=1;
      hasSomething = true;
      verticalSum+=alter[x];
    }else{
      
      if((sizeOfSomething > 60) && (verticalSum > 1000)){
        dancers.updateDancer(dancerIdx,startIdx + (x-1-startIdx)/2,240,alterZ[x-1]);
        //println("XXX update from alternatives XXX with id "+dancerIdx + " start "+startIdx+" end "+x );
        // fill(255);
        // rect(0,0,width, height);
        if(hasSomething) dancerIdx+=1;
      } 
      verticalSum =0;
      hasSomething = false;
      sizeOfSomething = 0;
      
    }
  }


}


PImage getBigImage(){
  PImage img = new PImage(context.depthWidth(),context.depthHeight()); 
  img.loadPixels();
  PImage bigImg = new PImage(width,height); 
  bigImg.loadPixels();
  contextupdate();

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
  println("onNewUser - userId: " + userId+ " start tracking skeleton");
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