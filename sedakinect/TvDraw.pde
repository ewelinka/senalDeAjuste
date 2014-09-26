class TvDraw implements Scene
{   
  int NUM_PARTICLES = 1000;
  ParticleSystem p;
  PImage bg;
  float overlayAlpha;
  FloatList middles;
  PVector posDancer;

  public TvDraw(){};

  void closeScene(){};
  void initialScene(){
    colorMode(RGB);
    smooth();
    p = new ParticleSystem();
    bg = loadImage("testcard.png");
    float overlayAlpha = 250;
    middles = new FloatList();
  };
  void drawScene(){
    drawOverlay();
    getDancers();
    posDancer = dancers.getFirstDancerMiddleAndTop();
    if(dancers.hasDancers()){
      p.update();
      p.render();
    }
  };
  String getSceneName(){return "TvDraw";};
  void onPressedKey(String k){
    if (k == "UP") this.overlayAlpha = min(this.overlayAlpha+5,255);
    if (k == "DOWN") this.overlayAlpha = max(this.overlayAlpha-5, 0);
  };
  void onImg(PImage img){};

  void drawOverlay(){
    fill(0, overlayAlpha);
    noStroke();
    rect(0,0, width, height);
  }

  class ParticleSystem
  {
    Particle[] particles;
    
    ParticleSystem()
    {
      particles = new Particle[NUM_PARTICLES];
      for(int i = 0; i < NUM_PARTICLES; i++){
        particles[i] = new Particle();
      }
    }
    
    void update()
    {
      for(int i = 0; i < NUM_PARTICLES; i++){
        particles[i].update();
      }
    }
    
    void render(){
      for(int i = 0; i < NUM_PARTICLES; i++){
        particles[i].render();
      }
    }
  }

  class Particle
  {
    PVector position, velocity;
    
    Particle()
    {
      position = new PVector(random(width),random(height));
      velocity = new PVector();
    }
    
    void update()
    { 

      velocity.x = 10*(noise(posDancer.x/1+position.y/100)-0.5);
      velocity.y = 10*(noise(posDancer.y/1+position.x/100)-0.5);
      position.add(velocity);
       
      
      if(position.x < 0)position.x = posDancer.x;
      if(position.x>width)position.x=posDancer.x;
      if(position.y<0)position.y = posDancer.y;
      if(position.y>height)position.y = posDancer.y;
      
      if(mousePressed == true){
        stroke(random(255),random(255),random(255));
        position.x = random(1600);
        position.y = random(800);
        velocity.x++;
        velocity.y++;
      }
      
    }
    
    void render()
    {
      color c = bg.get((int)position.x,(int)position.y);
      stroke(c);
      //fill(random(255),random(255),random(255),random(255));
      fill(c);
      line(position.x,position.y,position.x-velocity.x,position.y-velocity.y);
    }
  }
}