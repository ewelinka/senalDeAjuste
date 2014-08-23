/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/1162*@* */
/* !do not delete the line above, required for linking your tweak if you upload again */
ImgProc imgProc = new ImgProc();

float noiseScale = 0.005;
float noiseZ = 0;

int particleMargin = 64;  
ArrayList<Particle> particles;
int[] currFrame;
int[] prevFrame;
int[] tempFrame;

int maxSize =300;

void setup() {
  size(1024, 768);
  //frameRate(30);
  colorMode(HSB, 255);


  currFrame = new int[width*height];
  prevFrame = new int[width*height];
  tempFrame = new int[width*height];
  for(int i=0; i<width*height; i++) {
    currFrame[i] = color(0, 0, 0);
    prevFrame[i] = color(0, 0, 0);
    tempFrame[i] = color(0, 0, 0);
  }


  particles = new ArrayList<Particle>();
  
}

void draw() {  
  if(particles.size()<maxSize){

    int c = color(50+50*sin(PI*mouseX/width), 127, 255*sin(PI*mouseY/width));
    particles.add(new Particle(mouseX, mouseY, c));
  }
  //noiseZ += 2*noiseScale;
  
  imgProc.blur(prevFrame, tempFrame, width, height);
  imgProc.scaleBrightness(tempFrame, tempFrame, width, height, 0.99);  
  arraycopy(tempFrame, currFrame);
  
  updateParticles();

  imgProc.drawPixelArray(currFrame, 0, 0, width, height);
  arraycopy(currFrame, prevFrame);
}

void updateParticles(){
  for(int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      p.update();
      p.draw();
      if (p.isDead()) particles.remove(i);    

  }
}

class Particle {
  float x;
  float y;
  int c;
  int age;
  float speed = 5;
  Particle(int x, int y, int c) {
    this.x = x;
    this.y = y;
    this.c = c;
    age = 50;
  }
  void update() {
    float noiseVal = noise(x*noiseScale, y*noiseScale, noiseZ);
    float angle = noiseVal*2*PI;
    x += speed * cos(angle);
    y += speed * sin(angle);
    
    if (x < -particleMargin){
      x += width + 2*particleMargin;
    } else if (x > width + particleMargin){
      x -= width + 2*particleMargin;
    }
    
    if (y < -particleMargin){
      y += height + 2*particleMargin;
    } else if (y > height + particleMargin){
      y -= height + 2*particleMargin;
    }

    age--;
  }
  void draw() {
    if ((x >= 0) && (x < width-1) && (y >= 0) && (y < height-1)) {
      int currC = currFrame[(int)x + ((int)y)*width];
      currFrame[(int)x + ((int)y)*width] = c;
    }
  }

  boolean isDead() 
    { return (age == 0 || this.x <= 0 || this.x >= width || this.y <= 0 || this.y >= height); } 
}
