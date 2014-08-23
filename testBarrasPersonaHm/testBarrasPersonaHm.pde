import SimpleOpenNI.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

SimpleOpenNI context;
PImage imgKinect,bigImg;
DancersManager dancers;
float screen_xLeft=0;
float screen_xRight=640;
void setup(){
  size(1024, 768,P3D);
  background(255);

  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }

  context.enableDepth();
  context.enableUser();

  imgKinect = new PImage(context.depthWidth(),context.depthHeight(),ARGB); 
  imgKinect.loadPixels();
  bigImg = new PImage(width,height,ARGB); 
  bigImg.loadPixels();

  dancers = new DancersManager(); 
};

void draw(){
  dancers.cleanHm();
  background(255);
  getDancers();
  image(bigImg,0,0);
  drawLine4();
};


void drawLine(){
  stroke(0,255,0);
  for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {
    Dancer da = idancer.getValue();
    float middle_x = da.getMiddle();
    line(da.middle,0,middle_x,height);
    ellipse(middle_x, da.top,10,10);
  }
}

void drawLine2(){
  stroke(0,255,0);
  float middle_x = dancers.getFirstDancerMiddle();
  line(middle_x,0,middle_x,height);
  
}
void drawLine3(){
  stroke(0,255,0);
  float middle_x = dancers.getRandomDancerMiddle();
  line(middle_x,0,middle_x,height);
  
}

void drawLine4(){
  stroke(0,255,0);
  PVector p = dancers.getRandomDancerMiddleAndTop();
  line(p.x,0,p.x,height);
  ellipse(p.x, p.y,10,10);
}



void getDancers(){
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


class Dancer 
{   
  PVector 
    pos_left, 
    pos_right;
  float top,middle;
  int depth;
  
  //not projection positions but positions in kinect image
  public Dancer(float left_x, float left_y, int depth)
  {
    pos_left = new PVector(left_x,left_y);
    pos_right = new PVector(left_x, left_y);
    top = left_y;
    depth = depth;
    middle = left_x;
  }

  PVector getLeft(){ return pos_left; } 
  PVector getRight(){ return pos_right; } 
  float getTop(){ return top;}    

  float getMiddle(){ return middle;}
  int getDepth(){ return depth;}

  void checkRightTopDepth(float x, float y, int d){
    if(x > pos_right.x) {
      pos_right.x = x;
      pos_right.y = y;
    }
    if(y < top) top = y;
    if(d < depth) depth = d;
  }

  void setRescaledValues(){
    pos_left.x = map_x(pos_left.x);
    pos_left.y = map_y(pos_left.y);
    pos_right.x = map_x(pos_right.x);
    pos_right.y = map_y(pos_right.y);
    top = map_y(top);
    middle = min(pos_left.x,pos_right.x) + abs(pos_left.x - pos_right.x)/2;
  }

} 

class DancersManager {
  HashMap<Integer,Dancer> hm;
  IntList ids;

  DancersManager(){
    hm = new HashMap<Integer,Dancer>();
    ids = new IntList();
  }
 
  void updateDancer(int nr, float x, float y, int d ) {
    //println("in update dancer with "+nr);
    Dancer dancer;
    if (hm.containsKey(nr)) {
      dancer = (Dancer)hm.get(nr);
      // we check if it is a value number
      dancer.checkRightTopDepth(x,y,d);

    } else {
      // it has to be most left point because of the algorithm
      // now we just have to look for most right and top
      println("new key!! "+nr);
      dancer = new Dancer( x, y, d);  
      ids.append(nr);   
    }
    hm.put(nr,dancer); 
  }

  void cleanHm(){ 
    ids.clear();
    hm.clear();
  }

  void rescale(){
    for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {

      Dancer da = idancer.getValue();
      da.setRescaledValues();
      println("left: x "+da.pos_left.x +" "+da.pos_left.y);
      println("right: x "+da.pos_right.x +" "+da.pos_right.y);
      println("middle:  "+da.middle);
      println("top:  "+da.top);
    }
  }

  int getDancersNr(){ return hm.size();}

  boolean hasDancers(){return hm.size() > 0 ;}

  float getRandomDancerMiddle(){
    float m = 0;
    if(hasDancers()){
      dancers.ids.shuffle();
      int randomId = dancers.ids.get(0);
      m = dancers.hm.get(randomId).getMiddle();
    }
    return m;
  }

  float getFirstDancerMiddle(){
    float m = 0;
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      m = dancers.hm.get(firstId).getMiddle();
    }
    return m;
  }

  PVector getRandomDancerMiddleAndTop(){
    PVector p = new PVector(0,0);
    if(hasDancers()){
      dancers.ids.shuffle();
      int randomId = dancers.ids.get(0);
      p.x = dancers.hm.get(randomId).getMiddle();
      p.y = dancers.hm.get(randomId).getTop();
    }
    return p;
  }


  PVector getFirstDancerMiddleAndTop(){
    PVector p = new PVector(0,0);
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      p.x = dancers.hm.get(firstId).getMiddle();
      p.y = dancers.hm.get(firstId).getTop();
    }
    return p;
  }

  PVector getFirstDancerRight(){
    PVector p = new PVector(0,0);
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      p = dancers.hm.get(firstId).pos_right;
    }
    return p;
  }     

  int getFirstDancerDepth(){
    int d = 0;
    if(hasDancers()){
      int firstId = dancers.ids.get(0);
      d = dancers.hm.get(firstId).getDepth();
    }
    return d;
  } 
}

float map_x(float x){
  if( x < screen_xLeft || x > screen_xRight ) return 0;
  else return map(x,screen_xLeft,screen_xRight,0,1024);
}

float map_y(float y){
  return map(y,0,480,0,768);
}

