class ColorWave implements Scene
{   
  int num =20;
  int sign = 1;
  float strokeW =0;
  float step, sz, offSet, theta, angle;
  color[] colors={ 
    color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192)
  };

  public ColorWave(){};

  void closeScene(){};
  void initialScene(){
    strokeWeight(strokeW);
    step = 30;
  };
  void drawScene(){
    background(0);
    translate(width/2, height*.75);
    angle=0;
    for (int i=0; i<num; i++) {
      stroke(colors[i%7]);
      strokeWeight(10 + sign*strokeW);
      noFill();
      sz = i*step;
      float offSet = TWO_PI/num*i;
      float arcEnd = map(sin(theta+offSet),-1,1, PI, TWO_PI);
      arc(0, 0, sz, sz, PI, arcEnd);
    }
    colorMode(RGB);
    resetMatrix();
    //theta += .0523;
    theta= mouseX*.0123;
    strokeW+=0.1;
    if(strokeW>6){
      strokeW = 0;
      sign*=-1;
    }
  };
  String getSceneName(){return "ColorWave";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

}
