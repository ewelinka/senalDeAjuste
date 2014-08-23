int num = 100, edge = 200;
ArrayList ballCollection;


  
void setup() {
  size(1024, 768,P3D);
  background(0);
  ballCollection = new ArrayList();

}
  
void draw() {
  //background(0);
  fill(0,20);
  noStroke();
  rect(0,0,width,height);
  if(ballCollection.size()<num){
    PVector org = new PVector(mouseX, mouseY);

    float radius = random(50, 150);
    PVector loc = new PVector(org.x+radius, org.y);
    float offSet = random(TWO_PI);
    int dir = 1;
    float r = random(1);
    if (r>.5) dir =-1;
    int c = color(50+50*sin(PI*mouseX/width), 127, 255*sin(PI*mouseY/width));

    Ball myBall = new Ball(org, loc, radius, dir, offSet, c);
    ballCollection.add(myBall);
  }
  for (int i=0; i<ballCollection.size(); i++) {
    Ball mb = (Ball) ballCollection.get(i);
    mb.run();
    if (mb.isDead()) ballCollection.remove(i);  
  }
}
  

  
void mouseReleased() {
  background(0);
  clear();
}
  
void clear() {
  ballCollection.clear();
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
    col = _col;
    age = (int)random(100);
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
