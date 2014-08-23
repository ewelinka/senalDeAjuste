
class Balls implements Scene
{   
  int num = 60;
  int bgNr = 0;
  ArrayList ballCollection;
  color[] colors = { color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192),
    color(0) // black -- just for background
  };
  
  public Balls(){};

  void closeScene(){};
  void initialScene(){
    background(0);
    ballCollection = new ArrayList();
  };
  void drawScene(){

    fill(colors[bgNr],20);
    noStroke();
    rect(0,0,width,height);
    getDancers();
    // updateBalls();
    // drawRightPoint();
    updateRLBalls();

  };
  String getSceneName(){return "Balls";};
  void onPressedKey(String k){
    if (k == "reset"){
      clear();
    }
    if (k == "toggle") {
        toggleBgColor();
    }
  };
  void onImg(PImage img){};

  void updateRLBalls(){
    //PVector pos = dancers.getFirstDancerMiddleAndTop();
    ArrayList<PVector> allPoints = dancers.getAllRightAndLeft();
    if (dancers.hasDancers()) {
      // wer have something to add!
      for(int p = 0; p < allPoints.size();p++){
        PVector newPos = allPoints.get(p);
        for(int i=0; i < 5;i++) addBall(newPos);
      }
      
    }
    for (int i=0; i<ballCollection.size(); i++) {
      Ball mb = (Ball) ballCollection.get(i);
      mb.run();
      if (mb.isDead()) ballCollection.remove(i);  
    }
  }

  void updateBalls(){
    //PVector pos = dancers.getFirstDancerMiddleAndTop();
    PVector pos = dancers.getFirstDancerRight();
    if (dancers.hasDancers()) {
      // wer have something to add!
      for(int i=0; i < 5;i++) addBall(pos);
    }
    for (int i=0; i<ballCollection.size(); i++) {
      Ball mb = (Ball) ballCollection.get(i);
      mb.run();
      if (mb.isDead()) ballCollection.remove(i);  
    }
  }


  void addBall(PVector org){

    float radius = random(50, 150);
    PVector loc = new PVector(org.x+radius, org.y);
    float offSet = random(TWO_PI);
    int dir = 1;
    float r = random(1);
    if (r>.5) dir =-1;
    int c = color(50+50*sin(PI*org.x/width), 127, 255*sin(PI*org.y/width));

    Ball myBall = new Ball(org, loc, radius, dir, offSet, c);
    ballCollection.add(myBall);

  }

  void clear() {
    background(0);
    ballCollection.clear();
  }

  void toggleBgColor(){
    bgNr = (bgNr+1)%8;
  }

  class Ball {
    
    PVector org, loc;
    float sz = 10;
    float theta, radius, offSet;
    int s, dir, d = 60;
    int col;
    int age;
    
    Ball(PVector _org, PVector _loc, float _radius, int _dir, float _offSet, int _col) {
      org = _org;
      loc = _loc;
      radius = _radius;
      dir = _dir;
      offSet = _offSet;
      //col = _col;
      col = color(random(255),random(255),0);
      age = (int)random(30);
    }
    
    void run() {
      move();
      display();
      lineBetween();
    }
    
    void move() {
      loc.x = org.x + sin(theta+offSet)*radius;
      loc.y = org.y + cos(theta+offSet)*radius;
      theta += (0.0523/2*dir);
      age--;
    }
    
    void lineBetween() {
      for (int i=0; i<ballCollection.size(); i++) {
        Ball other = (Ball) ballCollection.get(i);
        float distance = loc.dist(other.loc);
        if (distance >0 && distance < d) {
          stroke(col,150);
          line(loc.x, loc.y, other.loc.x, other.loc.y);      
        }
      }
    }
    
    void display() {
      noStroke();
      for (int i=0; i<10; i++) {
        fill(col, i*50);
        ellipse(loc.x, loc.y, sz-2*i, sz-2*i);
      }
    }

    boolean isDead() 
      { return ( age < 1 || loc.x <= 0 || loc.x >= width || loc.y <= 0 || loc.y >= height); } 
  }
}