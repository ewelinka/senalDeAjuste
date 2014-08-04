import SimpleOpenNI.*;

SceneManager manager;
ArrayList<Character> numbers =new ArrayList<Character>();
// kinect stuff
SimpleOpenNI context;
PImage imgKinect,bigImg;
float maxRight_x,maxRight_y,middle_x,middle_y,maxLeft_x,maxLeft_y;
float closest_z;
float screen_xLeft,screen_xRight;


void setup(){
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


void draw(){
  manager.actualScene.drawScene(); 
}

void keyReleased(){
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

float map_x(float x){
  if( x < screen_xLeft || x > screen_xRight ) return 0;
  else return map(x,screen_xLeft,screen_xRight,0,1024);
}

float map_y(float y){
  return map(y,0,480,0,768);
}

