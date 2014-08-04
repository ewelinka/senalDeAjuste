// RIGHT
void getMostRight(){
  context.update();
  int[]   userMap = context.userMap();
  int steps = 1;
  int index;
  maxRight_x = maxRight_y = 0;

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
  line(maxRight_x,0,maxRight_x,height);
}

void drawLine(){
  stroke(255,255,0);
  line(middle_x,0,middle_x,height);
  ellipse(middle_x, middle_y,10,10);
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

void getMiddle(){
  context.update();
  int[]   userMap = context.userMap();
  int[]   depthMap = context.depthMap();
  int steps = 1;
  int index;
  maxRight_x = maxRight_y = 0;
  maxLeft_x = maxLeft_y = 0;
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
          maxLeft_x = map_x(x);
          maxLeft_y = map_y(y);
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
              maxRight_x = map_x(x);
              maxRight_y = map_y(y);

              middle_x = min(maxLeft_x,maxRight_x) + abs(maxLeft_x - maxRight_x)/2;
              middle_y = min(maxLeft_y,maxRight_y) + abs(maxLeft_y - maxRight_y)/2;
              //println("middle "+middle_x+" "+middle_y);

              gotOne = true;
           }
        }
      }
    }
  }
}