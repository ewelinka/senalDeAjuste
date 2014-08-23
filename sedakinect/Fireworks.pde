class Fireworks implements Scene
{   
  ArrayList fworks;
  boolean isRandom;
  PImage bg;
  int strokeTrans;
  public Fireworks(){};

  void closeScene(){};
  void initialScene(){
    stroke (255);
    strokeWeight (4);
    bg = loadImage("barras.png");
    fworks = new ArrayList();
    for (int i=0; i < 40; i++) {
      float x = random (width);
      float y = random (height);
      fworks.add(new Firework (x, y));
    }
    isRandom =true;
    strokeTrans =20;
  };
  void drawScene(){
    // get kienct
    getDancers();
    PVector pos = dancers.getFirstDancerRight();
    boolean hd = dancers.hasDancers();

    for(int i=0; i < 5;i++) {
      if(hd) fworks.add(new Firework (pos.x, pos.y));
      else fworks.add(new Firework (random(width), random(height)));  
    }

    for (int i=0; i < fworks.size(); i++) {
      Firework fi = (Firework)fworks.get(i);
      if(isRandom) fi.moveRandom();
      else fi.move ();
      color pixelCol = bg.get ((int)fi.position.x, (int)fi.position.y);
      stroke(pixelCol,strokeTrans);
      fill(pixelCol,strokeTrans);
      //point (g.position.x, g.position.y);
      ellipse (fi.position.x, fi.position.y,2,2);
      // if dead or reached target: replace
      // if there is dancer
      if(fi.isDead()){
        fworks.remove(i);
      }
    }
    drawRightPoint();
  };
  String getSceneName(){return "Fireworks";};
  void onPressedKey(String k){
    if (k == "toggle") isRandom = !isRandom;
    if (k == "UP") moreTransparent();
    if (k == "DOWN") lessTransparent();
  };
  void onImg(PImage img){};

  void moreTransparent(){
    strokeTrans-=1;
  }

  void lessTransparent(){
    strokeTrans+=1;
  }


  class Firework {     
    PVector position;
    PVector target;
    PVector direction;
    float spin = 0.15;
    int age;
     
    Firework (float theX, float theY) {
      position = new PVector (theX, theY);
      target   = new PVector ();
      target.x = position.x + random (-50,50);
      target.y = position.y + random (-50,50);

      direction   = new PVector ();
      direction.x = random (-1, 1);
      direction.y = random (-1, 1);

      age = (int)random(50);
    }
     
    void move () {
      PVector step = new PVector ();
      step.set (position);
      step.sub (target);
      step.div (40);
      position.sub (step);
    }

    boolean isDead(){
      boolean isD = false;
      if(isRandom){
        if(age<0) isD = true;
      }else{
        if(position.dist (target) < 3) isD = true;
      }
      return isD; 
    }

    void moveRandom () {
      direction.x += random (-spin, spin);
      direction.y += random (-spin, spin);
      direction.normalize ();
      position.add (direction);
       
      if (position.x < 0 || position.x > width) {
        direction.x *= -1;
      }
      if (position.y < 0 || position.y > height) {
        direction.y *= -1;
      }
      age --; 
    }
  }
}