import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class seda extends PApplet {



SceneManager manager;
ArrayList<Character> numbers =new ArrayList<Character>();

Capture liveVideo;

public void setup(){
  size(1024, 768,P3D);
//  size(displayWidth, displayHeight, P3D);

  numbers.add(0,'0');
  numbers.add(1,'1');
  numbers.add(2,'2');
  numbers.add(3,'3');
  numbers.add(4,'4');
  numbers.add(5,'5');
  numbers.add(6,'6');
  numbers.add(7,'7');
  numbers.add(8,'8');
  numbers.add(9,'9');

  manager = new SceneManager();  

  liveVideo = new Capture(this, 640, 480);

}


public void draw(){
  manager.actualScene.drawScene(); 
}

public void keyReleased(){
  if (keyCode == UP) manager.pressedKey("UP");
  if (keyCode == DOWN) manager.pressedKey("DOWN");
  if (keyCode == LEFT) manager.pressedKey("LEFT");
  if (keyCode == RIGHT) manager.pressedKey("RIGHT");

  if (key == 't') manager.pressedKey("toggle");

  if(numbers.contains(key)) manager.activate(numbers.indexOf(key));

}


public void captureEvent(Capture camera) {
  camera.read();
  
  // Copy the current video frame into an image, so it can be stored in the buffer
  PImage img = createImage(width, height, RGB);
  liveVideo.loadPixels();
  arrayCopy(liveVideo.pixels, img.pixels);
  manager.updateTimeDisplace(img);
  
}

class BigLike implements Scene
{   

  PImage like;
  int likes;
  int fontSize;


  public BigLike(){};

  // main functions
  public void closeScene(){};

  public void initialScene(){
    fontSize = 150;
    textSize(fontSize);
    background(255);
    noStroke();
    like = loadImage("bLike.jpeg");
    likes=0;
    fill(50, 73, 140);
    textAlign(CENTER);
  }

  public void drawScene(){
    background(like);

    likes = mouseX;  
    text(str(likes), 600, 550);
  };

  public String getSceneName(){return "BigLike";};

  public void onPressedKey(String k){
    if(k == "UP"){
      fontSize +=1;
      println("new font size "+fontSize); 
      textSize(fontSize);
    }  

    if(k == "DOWN"){
      fontSize -=1;
      println("new font size "+fontSize); 
      textSize(fontSize);
    }   
  };
  public void onImg(PImage img){};

}

 


class ColorWave implements Scene
{   
  int num =20;
  int sign = 1;
  float strokeW =0;
  float step, sz, offSet, theta, angle;
  int[] colors={ 
    color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192)
  };

  public ColorWave(){};

  public void closeScene(){};
  public void initialScene(){
    strokeWeight(strokeW);
    step = 30;
  };
  public void drawScene(){
    background(0);
    translate(width/2, height*.75f);
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
    theta= mouseX*.0123f;
    strokeW+=0.1f;
    if(strokeW>6){
      strokeW = 0;
      sign*=-1;
    }
  };
  public String getSceneName(){return "ColorWave";};
  public void onPressedKey(String k){};
  public void onImg(PImage img){};

}
class ImgGrid implements Scene
{   
  PImage myImg;
  int[] pixelColors;
  int[] pixelColors2;
  int scanLine;  // vertical position

  // 2D Array of objects
  Cell[][] grid;
  int cellsize = 60;

  // Number of columns and rows in the grid
  int cols;
  int rows;
  public ImgGrid(){};

  public void closeScene(){};
  public void initialScene(){
    myImg = loadImage("testcard.png");

    cols = width/cellsize;
    rows = height/cellsize;
  
    grid = new Cell[cols][rows];
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Initialize each object
        grid[i][j] = new Cell(i*cellsize,j*cellsize,cellsize,cellsize,i+j);
      }
    }

    pixelColors = new int[cols];
    pixelColors2 = new int[rows];
    scanLine = 0;
    smooth(4);
  };
  public void drawScene(){
    background(0);

    // read the colours for the current scanLine
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        pixelColors[i] = myImg.get(20+i*35, scanLine);
        pixelColors2[j] = myImg.get(j*35, scanLine);
      }
    }

    // draw the image
    image(myImg, 0, 0);
    
    // increment scan line position every second frame
    if (frameCount % 4 == 0) {
      scanLine ++;
    }

    if (scanLine > height) {
      scanLine = 0;
    }

    // draw the sampled pixels as grid
    for (int i=0; i< cols; i++) {
      for (int j=0; j< rows; j++) {
        noStroke();
        if(i % 2 == 0) {
          fill(pixelColors[i], random(100, 255));
        } else {
          fill(pixelColors2[j], random(100, 255));
        }
        //rect(i*cellsize, j*cellsize, cellsize, cellsize);
        rect(i*cellsize-random(15), j*cellsize-random(-5,5), cellsize, cellsize);
      }
    }
    
      // The counter variables i and j are also the column and row numbers and 
    // are used as arguments to the constructor for each object in the grid.  
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Oscillate and display each object
        grid[i][j].oscillate();
        grid[i][j].display();
      }
    }
  };
  public String getSceneName(){return "ImgGrid";};
  public void onPressedKey(String k){};
  public void onImg(PImage img){};

  // A Cell object
  class Cell {
    // A cell object knows about its location in the grid as well as its size with the variables x,y,w,h.
    float x,y;   // x,y location
    float w,h;   // width and height
    float angle; // angle for oscillating brightness

    // Cell Constructor
    Cell(float tempX, float tempY, float tempW, float tempH, float tempAngle) {
      x = tempX;
      y = tempY;
      w = tempW;
      h = tempH;
      angle = tempAngle;
    } 
    
    // Oscillation means increase angle
    public void oscillate() {
      angle += 0.06f; //0.02; 
    }

    public void display() {
  //    stroke(180);
      noStroke();
      // Color calculated using sine wave
  //    fill(127+127*sin(angle));
    for (int i=0; i< cols; i++) {
      fill(pixelColors[i], 180*sin(angle));
    }
      rect(x,y,w,h); 
    }
  }

}







class MediumLike implements Scene
{   
  //http://processing.org/examples/distance2d.html

  // additional parameters specific for the scene
  float x;
  float y;
  float easing = 0.05f;
  PImage like,dislike;
  boolean positive;
  int likes,dislikes;


  public MediumLike(){};

  // main functions
  public void closeScene(){};

  public void initialScene(){
    textSize(32);
    background(255);
    noStroke();
    dislike = loadImage("dislike.jpg");
    like = loadImage("like.png");
    positive = false;
    likes=0;
    dislikes =0;
    fill(50, 73, 140);
    textAlign(LEFT);
  }

  public void drawScene(){
    background(255);

    likes = mouseX;
    dislikes = mouseY;
  
    float targetX = mouseX;
    float dx = targetX - x;
    if(abs(dx) > 1) {
      x += dx * easing;
    }
    
    float targetY = mouseY;
    float dy = targetY - y;
    if(abs(dy) > 1) {
      y += dy * easing;
    }
    if(positive){
      image(like, x-25, y-25);
      text(str(likes), x+35, y+15);
    } 
    else {
      image(dislike, x-25, y-25);
      text(str(dislikes), x+35, y+5);
    }
    //ellipse(x, y, 66, 66);
  };

  public String getSceneName(){return "MediumLike";};

  public void onPressedKey(String k){
    if(k == "toggle") positive = !positive;    
  };
  public void onImg(PImage img){};

}

 


class MoveImg implements Scene
{   
  //http://processing.org/examples/distance2d.html

  // additional parameters specific for the scene
  float offset = 0;
  float easing = 0.05f;
  PImage bg;

  public MoveImg(){};

  // main functions
  public void closeScene(){};

  public void initialScene(){
    background(0);
    noStroke();
    bg = loadImage("testcard.png");
  };

  public void drawScene(){
    image(bg, 0, 0); 
    float dx = (mouseX-bg.width/2) - offset;
    offset += dx * easing; 
    tint(255, 127);  // Display at half opacity
    image(bg, offset, 0);
  };

  public String getSceneName(){return "MoveImg";};

  public void onPressedKey(String k){};

  public void onImg(PImage img){};

}
class Nothing implements Scene
{  
  public Nothing(){};
  public void closeScene(){};
  public void initialScene(){
      background(0);
  };
  public void drawScene(){};
  public String getSceneName(){return "Nothing";};
  public void onPressedKey(String k){};
  public void onImg(PImage img){};
}
class Points implements Scene
{   
  //http://processing.org/examples/distance2d.html

  // additional parameters specific for the scene
  float max_distance;
  PImage bg;

  public Points(){};

  // main functions
  public void closeScene(){};

  public void initialScene(){
    background(0);
    noStroke();
    max_distance = dist(0, 0, width, height);
    bg = loadImage("testcard.png");
  };

  public void drawScene(){
    background(bg);
    //smooth();
    for(int i = 0; i <= width; i += 20) {
      for(int j = 0; j <= height; j += 20) {
        float size = dist(mouseX, mouseY, i, j);
        size = size/max_distance * 66;
        //fill(random(255),random(255),random(255));
        fill(0);
        ellipse(i, j, size, size);
      }
    }
  };

  public String getSceneName(){return "Points";};

  public void onPressedKey(String k){};
  public void onImg(PImage img){};

}
/**
  Scene
*/
 
interface Scene
{ 
    public void initialScene();
    public void drawScene();
    public void closeScene();
    public String getSceneName();
    public void onPressedKey(String k);
    public void onImg(PImage img);
}


class SceneManager{

  Scene[] scenes;  
  Scene actualScene;
  
  SceneManager(){
    scenes = new Scene[10];
    scenes[0] = new Nothing();
    scenes[0].initialScene();
    scenes[1] = new Tv(); 
    scenes[2] = new Slashes();
    scenes[3] = new MoveImg();
    scenes[4] = new Spot();
    scenes[5] = new TextShake();
    
    scenes[6] = new ImgGrid();
    scenes[7] = new BigLike();
    scenes[8] = new Points(); 

    actualScene = scenes[0];
  }

  public void updateTimeDisplace(PImage img){
    scenes[6].onImg(img);
  }

  public void setBlack(){
    background(0);
  }

  public void activate(int sceneNr){
    actualScene.closeScene();
    setBlack();
    actualScene = scenes[sceneNr];
    actualScene.initialScene();
    println(sceneNr+" "+actualScene.getSceneName());
  }

  public void pressedKey(String pKey){
    actualScene.onPressedKey(pKey);
  }
}

class Example implements Scene
{   
  public Example(){};

  public void closeScene(){};
  public void initialScene(){};
  public void drawScene(){};
  public String getSceneName(){return "Example";};
  public void onPressedKey(String k){};
  public void onImg(PImage img){};

}
class Slashes implements Scene
{   
  Slash[] slash;
  int nb=20;


  int[] colors = { color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192)
  };

  public Slashes(){};

  public void closeScene(){};
  public void initialScene(){
    slash=new Slash[nb];
    for(int i=0; i<nb; i++){
        slash[i]=new Slash(colors[i%7]);
    }
  };
  public void drawScene(){
    background(0);
    
    for (int i=0;i<nb;i++) {
      slash[i].draw();
      slash[i].draw();
    }
  };
  public String getSceneName(){return "Slashes";};
  public void onPressedKey(String k){
    if (k == "UP") upSpeed();

    if (k == "DOWN") downSpeed();
    //
    // if (k == "RIGHT") this.radius += 5;
    // if (k == "LEFT") this.radius = max(10,this.radius-=5);
    
  };
  public void onImg(PImage img){};

  public void upSpeed(){
    for(int i=0; i<nb; i++){
        slash[i].easing += 0.01f ;
    }
  }
  public void downSpeed(){
    for(int i=0; i<nb; i++){
        slash[i].easing = max(0.01f, slash[i].easing-0.01f);
    }
  }
  class Slash {

    float x1, x2, y1, y2, tarX1, tarX2, tarY1, tarY2, easing = random(0.01f,0.1f) ;
    int timer, tMax, taille=(int)random(5,35), delta=240;
    boolean vertical;
    int c;

    Slash(int _c) {
        c=_c;
        initSlash();
    }

    public void initSlash() {
        timer=0;
        tMax= (int) random(60, 150);
        vertical=random(1)>.5f;
        taille=(int)random(5,35);

        //x1=x2=(int)random(1, int(width/40)-1)*40;
        x1=x2=mouseX;
        y1=y2=(int)random(1, PApplet.parseInt(height/40)-1)*40;

        if(x1<width/2) tarX2=x1+delta;
        else tarX2=x1-delta;

        if(y1<height/2) tarY2=y1+delta;
        else tarY2=y1-delta;
    }

    public void draw() {
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
    public float ease(float value, float target, float easingVal) {
        float d = target - value;
        if (abs(d)>1) value+= d*easingVal;
        return value;
    }
  }

}


class Spot implements Scene
{   
  //http://processing.org/examples/distance2d.html

  // additional parameters specific for the scene
  float x;
  float y;
  float easing = 0.05f;
  PImage like,dislike;
  boolean positive;
  int likes,dislikes;


  public Spot(){};

  // main functions
  public void closeScene(){};

  public void initialScene(){
    textSize(32);
    background(255);
    noStroke();
    dislike = loadImage("dislike.jpg");
    like = loadImage("like.png");
    positive = false;
    likes=0;
    dislikes =0;
    fill(50, 73, 140);
    textAlign(LEFT);
  }

  public void drawScene(){
    background(255);

    likes = mouseX;
    dislikes = mouseY;
  
    float targetX = mouseX;
    float dx = targetX - x;
    if(abs(dx) > 1) {
      x += dx * easing;
    }
    
    float targetY = mouseY;
    float dy = targetY - y;
    if(abs(dy) > 1) {
      y += dy * easing;
    }
    if(positive){
      image(like, x-25, y-25);
      text(str(likes), x+35, y+15);
    } 
    else {
      image(dislike, x-25, y-25);
      text(str(dislikes), x+35, y+5);
    }
    //ellipse(x, y, 66, 66);
  };

  public String getSceneName(){return "Spot";};

  public void onPressedKey(String k){
    if(k == "toggle") positive = !positive;    
  };
  public void onImg(PImage img){};

}

 


class TextShake implements Scene
{   
  String message = "methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually.";
  Letter[] letters;
  int h = 30;
  PFont f;

  public TextShake(){};

  public void closeScene(){};

  public void initialScene(){
    f = createFont("Arial",h,true);
    textFont(f);
    
    // Create the array the same size as the String
    letters = new Letter[message.length()];
    // Initialize Letters at the correct x location
    int x = 16;
    int y = h;
    for (int i = 0; i < message.length(); i++) {
      letters[i] = new Letter(x,y,message.charAt(i)); 
      x += textWidth(message.charAt(i));
      if(x > 1000) {
        x =16;
        y+=h;
      }

    }
  };

  public void drawScene(){
    background(255);
    for (int i = 0; i < letters.length; i++) {

      if ((mouseX + 15 > letters[i].homex)&&(mouseX - 15 < letters[i].homex)) {
        letters[i].shake();
        letters[i].change('d','f');
      } 

      letters[i].display();
      letters[i].home();
    }
  };

  public String getSceneName(){return "TextShake";};
  public void onPressedKey(String k){};
  public void onImg(PImage img){};

  // A class to describe a single Letter
  class Letter {
    char letter;
    // The object knows its original "home" location
    float homex,homey;
    char homeletter;
    // As well as its current location
    float x,y;
    int fillHome=color(0);
    int fillValue=fillHome;

    Letter (float x_, float y_, char letter_) {
      homex = x = x_;
      homey = y = y_;
      letter = letter_; 
      homeletter = letter_;
    }

    // Display the letter
    public void display() {
      fill(fillValue);
      textAlign(LEFT);
      text(letter,x,y);
    }

    // Move the letter randomly
    public void shake() {
      x += random(-2,2);
      y += random(-2,2);
    }

    // Return the letter home
    public void home() {
      x = homex;
      y = homey; 
      letter = homeletter;
      fillValue = fillHome;
    }

    public void change(char now, char newletter){
      if (now == letter) {
        letter = newletter;
        fillValue = color(255,0,0);
      }

    }
  }
}



class TimeDisplace implements Scene
{   

  // additional parameters specific for the scene
  int signal = 0;

  //the buffer for storing liveVideo frames
  ArrayList frames = new ArrayList();
  

  public TimeDisplace(){};

  // main functions
  public void closeScene(){
    liveVideo.stop();
  };

  public void initialScene(){
    liveVideo.start();

  };

  public void drawScene(){
    int currentImage = 0;
    loadPixels();

    // Begin a loop for displaying pixel rows of 4 pixels height
    for (int y = 0; y < liveVideo.height; y+=4) {
      // Go through the frame buffer and pick an image, starting with the oldest one
      if (currentImage < frames.size()) {
        PImage img = (PImage)frames.get(currentImage);
        
        if (img != null) {
          img.loadPixels();
          
          // Put 4 rows of pixels on the screen
          for (int x = 0; x < liveVideo.width; x++) {
            pixels[x + y * width] = img.pixels[x + y * liveVideo.width];
            pixels[x + (y + 1) * width] = img.pixels[x + (y + 1) * liveVideo.width];
            pixels[x + (y + 2) * width] = img.pixels[x + (y + 2) * liveVideo.width];
            pixels[x + (y + 3) * width] = img.pixels[x + (y + 3) * liveVideo.width];
          }  
        }
        
        // Increase the image counter
        currentImage++;
         
      } else {
        break;
      }
    }

    updatePixels();
  };

  public String getSceneName(){return "TimeDisplace";};

  public void onPressedKey(String k){};

  public void onImg(PImage img){
    frames.add(img);
  
    // Once there are enough frames, remove the oldest one when adding a new one
    if (frames.size() > height/4) {
      frames.remove(0);
    }
  }

}
class Tv implements Scene
{   
  //http://processing.org/examples/hue.html

  // additional parameters specific for the scene
  int[] main_bars={ 
    color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192)
  };

  int tv_width,tv_height;

  public Tv(){};

  // main functions
  public void closeScene(){};

  public void initialScene(){
    background(0);
    tv_width = width;
    tv_height = height;

  };

  public void drawScene(){

  loadPixels();
  
  // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      if(random(100)>50) pixels[x+y*width] = color(255);
      else pixels[x+y*width] = color(40);
    }
  }
  
  updatePixels();


    drawTv(tv_width,tv_height,7,main_bars);
    saveFrame("barras.png");
    exit();
  };

  public String getSceneName(){return "Tv";};

  public void onPressedKey(String k){};

  public void onImg(PImage img){};

  public void drawTv(int window_w, int window_h, int bars_nr, int[] colors) {
    noSmooth();
    noStroke();
    int bar_width = window_w / bars_nr +1;
    int whichBar = (int)(mouseX / bar_width);


    int x1, xM;
//    xM = (int)(whichBar * bar_width);
    xM = -1;
    for (int i = 0; i < bars_nr; i ++) {
      fill(colors[i]);

      x1 = (int)(i * bar_width);
      if(xM != x1) rect(x1, 0, bar_width, window_h); 
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "seda" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
