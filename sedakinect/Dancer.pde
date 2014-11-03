
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
    this.depth = depth;
    middle = left_x;
  }

  PVector getLeft(){ return pos_left; } 
  PVector getRight(){ return pos_right; } 
  float getTop(){ return top;}    

  float getMiddle(){ return middle;}
 // PVector getMiddleTop(){ return PVector(middle,top);}
  int getDepth(){ return this.depth;}

  void checkRightTopDepth(float x, float y, int d){
    if(x > pos_right.x) {
      pos_right.x = x;
      pos_right.y = y;
    }
    if(y < top) top = y;
    if(d < this.depth) this.depth = d;
  }


  void setRescaledValues(){
    pos_left.x = map_x(pos_left.x, this.depth);
    pos_left.y = map_y(pos_left.y);
    pos_right.x = map_x(pos_right.x, this.depth);
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
      dancer = new Dancer( x, y, d);  
      ids.append(nr);   
    }
    hm.put(nr,dancer); 
  }

  Dancer getDancer(int dancerNr){
    return (Dancer)hm.get(dancerNr);
  }

  void cleanHm(){ 
    ids.clear();
    hm.clear();
  }

  void rescale(){
    for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {

      Dancer da = idancer.getValue();
      da.setRescaledValues();
      // println("left: x "+da.pos_left.x +" "+da.pos_left.y);
      // println("right: x "+da.pos_right.x +" "+da.pos_right.y);
      // println("middle:  "+da.middle);
      // println("top:  "+da.top);
    }
  }

  int getDancersNr(){ return hm.size();}

  boolean hasDancers(){return hm.size() > 0 ;}

  boolean hasDancer(int dancerNr){
    return hm.containsKey(dancerNr);
  }

  float getRandomDancerMiddle(){
    float m = 0;
    if(hasDancers()){
      dancers.ids.shuffle();
      int randomId = dancers.ids.get(0);
      m = dancers.hm.get(randomId).getMiddle();
    }
    return m;
  }

  FloatList getAllMiddles(){
    FloatList middles = new FloatList();
    for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {
      Dancer da = idancer.getValue();
      middles.append(da.getMiddle());
    }
    return middles;
  }

  ArrayList<PVector> getAllRightAndLeft(){
    ArrayList<PVector> positionsRL = new ArrayList<PVector>();
    for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {
      Dancer da = idancer.getValue();
      positionsRL.add(da.getRight());
      positionsRL.add(da.getLeft());
    }
    return positionsRL;
  }

  float getDancerMiddle(int dancerNr){
    Dancer d = getDancer(dancerNr);
    return d.getMiddle();
  }

  PVector getDancerMiddleAndTop(int dancerNr){
    Dancer d = getDancer(dancerNr);
    PVector mt = new PVector(d.getMiddle(), d.getTop());
    return mt;
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
      float px = dancers.hm.get(randomId).getMiddle();
      float py = dancers.hm.get(randomId).getTop();
      p.set(px,py);
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