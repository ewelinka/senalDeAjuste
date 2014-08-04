import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sedakinect extends PApplet {



SceneManager manager;
ArrayList<Character> numbers =new ArrayList<Character>();
// kinect stuff
SimpleOpenNI context;
PImage imgKinect,bigImg;
float maxRight_x,maxRight_y,middle_x,middle_y,maxLeft_x,maxLeft_y;
float closest_z;
float screen_xLeft,screen_xRight;


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

  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  //context.setMirror(false);
  context.enableDepth();
  context.enableUser();

  maxRight_x = maxRight_y = closest_z = middle_x = middle_y = maxLeft_x = maxLeft_y = 0;
  screen_xLeft = 58;
  screen_xRight = 640;

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

// boolean sketchFullScreen() {
//   return true;
// }

public float map_x(float x){
  if( x < screen_xLeft || x > screen_xRight ) return 0;
  else return map(x,screen_xLeft,screen_xRight,0,1024);
}

public float map_y(float y){
  return map(y,0,480,0,768);
}

class BigLike implements Scene
{   

  PImage like;
  int likes;


  public BigLike(){};

  // main functions
  public void closeScene(){};

  public void initialScene(){
    textSize(150);
    background(255);
    noStroke();
    like = loadImage("bLike.jpeg");
    likes=0;
    fill(50, 73, 140);
    textAlign(CENTER);
  }

  public void drawScene(){
    background(like);
    getClosest();
    if (closest_z > 0 ){
      likes = (int)closest_z;
    }
 
    text(str(likes), 600, 550);
  };

  public String getSceneName(){return "BigLike";};

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







class Like implements Scene
{   
  //http://processing.org/examples/distance2d.html

  // additional parameters specific for the scene
  float x;
  float y;
  float easing = 0.05f;
  PImage like,dislike;
  boolean positive;
  int likes,dislikes;


  public Like(){};

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
    getMiddle();
    if (maxRight_y > 0 && maxRight_x > 0){
      likes =  (int)(height - maxRight_y);
      dislikes = (int)maxRight_x;
    }
    
  
    float targetX = maxRight_x;
    float dx = targetX - x;
    if(abs(dx) > 1) {
      x += dx * easing;
    }
    
    float targetY = maxRight_y;
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
    drawLine();
  };

  public String getSceneName(){return "Like";};

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
  float dx;

  public MoveImg(){};

  // main functions
  public void closeScene(){};

  public void initialScene(){
    background(0);
    noStroke();
    bg = loadImage("testcard.png");
  };

  public void drawScene(){
    //getMostRightAndImg();
    getMiddle();
    image(bg, 0, 0); 

    if(middle_x>0) dx = (middle_x-bg.width/2) - offset;
    else dx = 0;
    offset += dx * easing; 
    tint(255, 127);  // Display at half opacity
    image(bg, offset, 0);
    //drawDancer();
    drawLine();
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
    scenes[2] = new TvMove();
    scenes[3] = new Slashes();
    scenes[4] = new Like();
    scenes[5] = new BigLike();
    
    scenes[6] = new WordsGrow();
    scenes[7] = new ImgGrid();
    scenes[8] = new TextShake(); 

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
    getMiddle();
    //getMostRightAndImg();
    for (int i=0;i<nb;i++) {
      slash[i].draw();
      //slash[i].draw();
    }
    //drawDancer();
    drawLine();
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
    int homeColor;

    Slash(int _c) {
        c=_c;
        homeColor = _c;
        initSlash();
    }

    public void initSlash() {
        timer=0;
        tMax= (int) random(60, 150);
        vertical=random(1)>.5f;
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
          x1=x2=(int)random(1, PApplet.parseInt(width/40)-1)*40;
          y1=y2=(int)random(1, PApplet.parseInt(height/40)-1)*40;
        }
        
        

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


class TextShake implements Scene
{   
  String message = "Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. ";

  Letter[] letters;
  int h = 20;
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
    getMiddle();
    background(255);
    for (int i = 0; i < letters.length; i++) {

      if ((middle_x + 15 > letters[i].homex)&&(middle_x - 15 < letters[i].homex)) {
        letters[i].shake();
        letters[i].change('d','f');
      } 

      letters[i].display();
      letters[i].home();
    }
    drawLine();
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


class Tv implements Scene
{   
  
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

  public void closeScene(){};

  public void initialScene(){
    background(0);
    tv_width = width;
    tv_height = height;

    imgKinect = new PImage(context.depthWidth(),context.depthHeight(),ARGB); 
    imgKinect.loadPixels();
    bigImg = new PImage(width,height,ARGB); 
    bigImg.loadPixels();

  };

  public void drawScene(){

    drawNoise();
    getMiddle();
    //getMostRightAndImg();
    drawTv(tv_width,tv_height,7,main_bars);
    //drawDancer();
    drawLine();

  };

  public String getSceneName(){return "Tv";};

  public void onPressedKey(String k){};

  public void onImg(PImage img){};

  public void drawNoise(){
    loadPixels();
    // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if(random(100)>50) pixels[x+y*width] = color(255);
        else pixels[x+y*width] = color(40);
      }
    }
    updatePixels();
  }

  public void drawTv(int window_w, int window_h, int bars_nr, int[] colors) {
    noSmooth();
    noStroke();
    int bar_width = window_w / bars_nr +1;

    int whichBar;
    if(middle_x < 1) whichBar = -1;
    else whichBar = (int)(middle_x / bar_width);


    int x1, xM;
    xM = (int)(whichBar * bar_width);
    for (int i = 0; i < bars_nr; i ++) {
      fill(colors[i]);

      x1 = (int)(i * bar_width);
      if(xM != x1) rect(x1, 0, bar_width, window_h); 
    }
  }
}
class TvMove implements Scene
{   
  int tv_width,tv_height;
  int[] main_bars={ 
    color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192)
  };
  float offset = 0;
  float easing = 0.05f;
  PImage bg;
  float dx;
  

  public TvMove(){};

  public void closeScene(){};

  public void initialScene(){
    bg = loadImage("barras.png");
    background(bg);
  };

  public void drawScene(){

    getMiddle();
    background(bg); 

    if(middle_x>0) dx = (middle_x-bg.width/2) - offset;
    else dx = - offset;
    
    offset += dx * easing; 
    tint(255, 127);  // Display at half opacity
    image(bg, offset, 0);
    //drawDancer();
    drawLine();

  };

  public String getSceneName(){return "TvMove";};

  public void onPressedKey(String k){};

  public void onImg(PImage img){};

  public void drawNoise(){
    loadPixels();
    // For every x,y coordinate in a 2D space, calculate a noise value and produce a brightness value
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if(random(100)>50) pixels[x+y*width] = color(255);
        else pixels[x+y*width] = color(40);
      }
    }
    updatePixels();
  }

  public void drawTvMove(int window_w, int window_h, int bars_nr, int[] colors) {
    noSmooth();
    noStroke();
    int bar_width = window_w / bars_nr +1;

    int whichBar;
    if(middle_x < 1) whichBar = -1;
    else whichBar = (int)(middle_x / bar_width);


    int x1, xM;
    xM = (int)(whichBar * bar_width);
    for (int i = 0; i < bars_nr; i ++) {
      fill(colors[i]);

      x1 = (int)(i * bar_width);
      if(xM != x1) rect(x1, 0, bar_width, window_h); 
    }
  }
}
class WordsGrow implements Scene
{   
  String message = "Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. ";
  PFont f;
  Word[] words;
  int h = 20;


  public WordsGrow(){};

  public void closeScene(){};

  public void initialScene(){
    f = createFont("Arial",h,true);
    textFont(f);

    String[] splittedMsg = message.split(" ");

    words = new Word[splittedMsg.length];

    int x = 16;
    int y = h;
    for (int i = 0; i < splittedMsg.length; i++) {
      boolean canGrow = false;
      if(random(100)<22) canGrow = true;
      String w = splittedMsg[i]+" ";
      words[i] = new Word(x+textWidth(w)/2,y,h,w,canGrow); 
      x += textWidth(w);
      if(x > 1000) {
        x =16;
        y+=h;
      }
    }

    println("initializing done");
  };

  public void drawScene(){

    getMiddle();

    background(255);
    if (middle_x >0){
      for (int i = 0; i < words.length; i++) {
        if ((middle_x + 15 > words[i].homex)&&(middle_x - 15 < words[i].homex)) {
          words[i].growIfYouCan();
        } 
        else words[i].home();

        words[i].display();
        //words[i].home();
      }
      drawLine();
    }else{
      for (int i = 0; i < words.length; i++) {
        words[i].home();
        words[i].display();
      }
    }
  };

  public String getSceneName(){return "WordsGrow";};
  public void onPressedKey(String k){};
  public void onImg(PImage img){};

  // A class to describe a single Letter
  class Word {
    String word;
    // The object knows its original "home" location
    float homex,homey,homeh;
    boolean canGrow;

    // As well as its current location
    float x,y;
    float fontSize;

    Word (float x_, float y_, float homeh_, String word_, boolean canGrow_) {
      homex = x = x_;
      homey = y = y_;
      word = word_; 
      canGrow = canGrow_;
      homeh = fontSize = homeh_;
    }

    // Display the word
    public void display() {
      fill(0);
      textSize(fontSize);
      textAlign(CENTER);
      text(word,x,y);
    }

    // Return to original size
    public void home() {
      if(fontSize!=homeh) fontSize=max(homeh, fontSize-1);
    }


    public void growIfYouCan(){
      if(canGrow) fontSize= min(fontSize+1,60);
    }


  }
}


// RIGHT
public void getMostRight(){
  context.update();
  int[]   userMap = context.userMap();
  int steps = 1;
  int index;
  maxRight_x = maxRight_y = 0;

  boolean gotOne =false;
  for(int x=(context.depthWidth()-1);x > 0 && !gotOne;x-=steps)
    {
    for(int y=0;y < context.depthHeight() && !gotOne;y+=steps)
    {
      index = x + y * context.depthWidth();

      if(userMap[index] > 0)
      { 
        maxRight_x = map_x(x);
        maxRight_y = map_y(y);

        gotOne = true;
      }
    }
  }
}


public void drawDancer(){
  image(bigImg,0,0);
  stroke(255,255,0);
  line(maxRight_x,0,maxRight_x,height);
}

public void drawLine(){
  stroke(255,255,0);
  line(middle_x,0,middle_x,height);
  ellipse(middle_x, middle_y,10,10);
}

//DEPTH
public void getClosest(){
  context.update();
  int[]   userMap = context.userMap();
  int[]   depthMap = context.depthMap();
 
  int steps = 1;
  int index;
  closest_z = 0;

  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      int d = depthMap[index];
       if(userMap[index] > 0)
       { 
        if((d > 0) && (d > closest_z)) closest_z = d;
       }
    }
  } 
  //closest_z = map(closest_z,300,10000,0,100);
}

public void getMiddle(){
  context.update();
  int[]   userMap = context.userMap();
  int[]   depthMap = context.depthMap();
  int steps = 1;
  int index;
  maxRight_x = maxRight_y = 0;
  maxLeft_x = maxLeft_y = 0;
  middle_x = middle_y = 0;

  boolean gotOne = false;

  for(int x=0;x < context.depthWidth() && !gotOne;x+=steps)
  {
    for(int y=0;y < context.depthHeight() && !gotOne;y+=steps)
    {
      index = x + y * context.depthWidth();
      int d = depthMap[index];
      if(d>0){
        if(userMap[index] > 0)
        { 
          maxLeft_x = map_x(x);
          maxLeft_y = map_y(y);
          //println("got left "+maxLeft_x+" "+maxLeft_y);
          gotOne = true;
        }
      }
    }
  } 
  // if we have found some "user" it make sence to look his most right point
  if(gotOne){
    //println("got left now looking for right");
    gotOne =false;
    for(int x=(context.depthWidth()-1);x > 0 && !gotOne;x-=steps)
    {
      for(int y=0;y < context.depthHeight() && !gotOne;y+=steps)
      {
        index = x + y * context.depthWidth();
        int d = depthMap[index];
        if(d>0){
           if(userMap[index] > 0)
           { 
              maxRight_x = map_x(x);
              maxRight_y = map_y(y);

              middle_x = min(maxLeft_x,maxRight_x) + abs(maxLeft_x - maxRight_x)/2;
              middle_y = min(maxLeft_y,maxRight_y) + abs(maxLeft_y - maxRight_y)/2;
              //println("middle "+middle_x+" "+middle_y);

              gotOne = true;
           }
        }
      }
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sedakinect" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
