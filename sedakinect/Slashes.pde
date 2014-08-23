class Slashes implements Scene
{   
  Slash[] slash;
  int nb=20;
  int maxTime = 100;
  float maxEasing = 0.2;
  int bgNr;



  color[] colors = { color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192),
    color(0) // black -- just for background
  };

  public Slashes(){};

  void closeScene(){};
  void initialScene(){
    getDancers();
    slash=new Slash[nb];
    for(int i=0; i<nb; i++){
        slash[i]=new Slash(colors[i%7]);
    }
    //background(255);
    bgNr = 0;
  };
  void drawScene(){
    background(colors[bgNr]);
    getDancers();
    //getMostRightAndImg();
    for (int i=0;i<nb;i++) {
      slash[i].draw();
      slash[i].draw();
    }
    //drawDancer();
    drawLine();
  };
  String getSceneName(){return "Slashes";};
  void onPressedKey(String k){
    if (k == "UP") upSpeed();

    if (k == "DOWN") downSpeed();
    //
    // if (k == "RIGHT") this.radius += 5;
    // if (k == "LEFT") this.radius = max(10,this.radius-=5);
    if (k == "reset") {
      initAllSlashes();
    }

    if (k == "toggle") {
      toggleBgColor();
      initAllSlashes();
    }

  };
  void onImg(PImage img){};

  void toggleBgColor(){
    bgNr = (bgNr+1)%8;
  }

  void initAllSlashes(){
    for(int i=0; i<nb; i++){
      slash[i].initSlash();
    }
  }

  void upSpeed(){
    for(int i=0; i<nb; i++){
        slash[i].easing += 0.01 ;
        slash[i].tMax -= 1 ;
        maxTime = max(40, maxTime-2) ;
        maxEasing += 0.01 ;
    }
  }
  void downSpeed(){
    for(int i=0; i<nb; i++){
        slash[i].easing = max(0.01, slash[i].easing-0.01);
        slash[i].tMax+=2; 
        maxTime = maxTime +2;
        maxEasing = max(0.01, maxEasing-0.01);
    }
  }
  class Slash {

    float x1, x2, y1, y2, tarX1, tarX2, tarY1, tarY2, easing = random(0.01,maxEasing) ;
    int timer, tMax, taille=(int)random(5,35), delta=240;
    boolean vertical;
    color c;
    color homeColor;

    Slash(color _c) {
        c=_c;
        homeColor = _c;
        initSlash();
    }

    void initSlash() {
      //println("in init slash!!");
      timer=0;
      tMax= (int) random(40, maxTime);
      vertical=random(1)>.5;
      taille=(int)random(5,35);

      //x1=x2=(int)random(1, int(width/40)-1)*40;
      //float middle_x = dancers.getRandomDancerMiddle();
      //getFirstDancerMiddleAndTop
      PVector pos = dancers.getFirstDancerMiddleAndTop();
      
      if (pos.x > 0) {
        //we draw color
       // println("draw color!pos x "+pos.x+" y "+pos.y);
        c = homeColor; 
        //x1=x2=pos.x;
        x1=x2= (pos.x + random(-100,100));
       // y1=y2=(pos.y+random(-20, 20));
        y1=y2=random(pos.y,height);

        println("x1 "+ x1 + " ,y1 "+y1);
        //y1=y2=pos.y+random(-20, 20);
        //y1=y2=pos.y;
      }
      else {
        // we draw in background color
        c = colors[bgNr];
        x1=x2=(int)random(1, int(width/40)-1)*40;
        y1=y2=(int)random(1, int(height/40)-1)*40;
      }
      
      if(x1<width/2) tarX2=x1+delta;
      else tarX2=x1-delta;

      if(y1<height/2) tarY2=y1+delta;
      else tarY2=y1-delta;
    }

    void draw() {
        x2=ease(x2, tarX2, easing);
        y2=ease(y2, tarY2, easing);
        if (abs(x2-tarX2)<=1) {
            timer++;

            if (timer>tMax) {
                tarX1=tarX2;
                tarY1=tarY2;
                x1=ease(x1, tarX1, easing);//
                y1=ease(y1, tarY1, easing);

                if (abs(x1-tarX1)<=1) {
                    initSlash();
                }
            }
        }

        noStroke();
        fill(c, 200);
        if (vertical) quad(x1, y1-taille, x1, y1+taille, x2, y2+taille, x2, y2-taille);
        else quad(x1-taille, y1, x1+taille, y1, x2+taille, y2, x2-taille, y2);
    }

    // a snippet function i often use for animation easing
    float ease(float value, float target, float easingVal) {
        float d = target - value;
        if (abs(d)>1) value+= d*easingVal;
        return value;
    }

    // void toggleColor(){
    //   if(c==homeColor) c = color(0);
    //   else c = homeColor; 
    // }
  }

}


