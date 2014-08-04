class Slashes implements Scene
{   
  Slash[] slash;
  int nb=20;


  color[] colors = { color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192)
  };

  public Slashes(){};

  void closeScene(){};
  void initialScene(){
    slash=new Slash[nb];
    for(int i=0; i<nb; i++){
        slash[i]=new Slash(colors[i%7]);
    }
  };
  void drawScene(){
    background(0);
    getMiddle();
    //getMostRightAndImg();
    for (int i=0;i<nb;i++) {
      slash[i].draw();
      //slash[i].draw();
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
    
  };
  void onImg(PImage img){};

  void upSpeed(){
    for(int i=0; i<nb; i++){
        slash[i].easing += 0.01 ;
    }
  }
  void downSpeed(){
    for(int i=0; i<nb; i++){
        slash[i].easing = max(0.01, slash[i].easing-0.01);
    }
  }
  class Slash {

    float x1, x2, y1, y2, tarX1, tarX2, tarY1, tarY2, easing = random(0.01,0.1) ;
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
        timer=0;
        tMax= (int) random(60, 150);
        vertical=random(1)>.5;
        taille=(int)random(5,35);

        //x1=x2=(int)random(1, int(width/40)-1)*40;
        
        if (middle_x > 0) {
          //we draw color
          c = homeColor; 
          x1=x2=middle_x;
          y1=y2=middle_y+random(-15, 15);
        }
        else {
          // we draw black
          c = color(0);
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
        fill(c,200);
        if (vertical) quad(x1, y1-taille, x1, y1+taille, x2, y2+taille, x2, y2-taille);
        else quad(x1-taille, y1, x1+taille, y1, x2+taille, y2, x2-taille, y2);
    }

    // a snippet function i often use for animation easing
    float ease(float value, float target, float easingVal) {
        float d = target - value;
        if (abs(d)>1) value+= d*easingVal;
        return value;
    }
  }

}


