
class TimeDisplace implements Scene
{   

  // additional parameters specific for the scene
  int signal = 0;

  //the buffer for storing liveVideo frames
  ArrayList frames = new ArrayList();
  

  public TimeDisplace(){};

  // main functions
  void closeScene(){
    liveVideo.stop();
  };

  void initialScene(){
    liveVideo.start();

  };

  void drawScene(){
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

  String getSceneName(){return "TimeDisplace";};

  void onPressedKey(String k){};

  void onImg(PImage img){
    frames.add(img);
  
    // Once there are enough frames, remove the oldest one when adding a new one
    if (frames.size() > height/4) {
      frames.remove(0);
    }
  }

}
