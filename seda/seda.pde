import processing.video.*;

SceneManager manager;
ArrayList<Character> numbers =new ArrayList<Character>();

Capture liveVideo;

void setup(){
  size(1024, 600,P3D);
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


void captureEvent(Capture camera) {
  camera.read();
  
  // Copy the current video frame into an image, so it can be stored in the buffer
  PImage img = createImage(width, height, RGB);
  liveVideo.loadPixels();
  arrayCopy(liveVideo.pixels, img.pixels);
  manager.updateTimeDisplace(img);
  
}

