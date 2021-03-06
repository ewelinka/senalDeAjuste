class MultiImg implements Scene
{   
  int DIM, NUMQUADS; // variables to hold the grid dimensions and total grid size
  PImage img; // the image

  public MultiImg(){};

  void closeScene(){};
  void initialScene(){
    img = loadImage("testcard.png"); // load the image (from the /data subdirectory)
    //size(img.width*2, img.height, P2D); // set the width of the sketch to twice the image width
    textureMode(NORMAL); // use normalized (0 to 1) texture coordinates
    noStroke(); // turn off stroke (for the rest of the sketch)
    smooth(6); // set smooth level 6 (default is 2)
  };
  void drawScene(){
    getDancers();
    PVector p = dancers.getFirstDancerRight();
    DIM = (int) map(p.x, 0,width, 1, 40); // set DIM in the range from 1 to 40 according to mouseX
    NUMQUADS = DIM*DIM; // calculate the total number of cells in the grid
    beginShape(QUAD); // draw a Shape of QUADS
    texture(img); // use the image as a texture
    // draw all the QUADS in the grid...
    for (int i=0; i<NUMQUADS; i++) {
      // ...through a custom drawQuad method that takes as input parameters
      // the index for the position and the index for the texture coordinates
      // therefore: drawQuad(i, i); would look like the regular image
      // currently frameCount-based noise determines the index for the texture coordinates
      drawQuad(i, int(i+noise(i+frameCount*0.001)*NUMQUADS)%NUMQUADS);
    }
    endShape(); // finalize the Shape
    //image(img, width/2, 0); // display the regular image on the right side of the sketch
    frame.setTitle(int(frameRate) + " fps"); // the fps remains 60 even with dynamic texture changes and a high-density grid
  };
  String getSceneName(){return "MultiImg";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

  void drawQuad(int indexPos, int indexTex) {
    // calculate the position of the vertices
    float x1 = float(indexPos%DIM)/DIM*width;
    float y1 = float(indexPos/DIM)/DIM*height;
    float x2 = float(indexPos%DIM+1)/DIM*width;
    float y2 = float(indexPos/DIM+1)/DIM*height;

    // calculate the texture coordinates
    float x1Tex = float(indexTex%DIM)/DIM;
    float y1Tex = float(indexTex/DIM)/DIM;
    float x2Tex = float(indexTex%DIM+1)/DIM;
    float y2Tex = float(indexTex/DIM+1)/DIM;

    // use the above calculations for 4 vertex() calls
    vertex(x1, y1, x1Tex, y1Tex);
    vertex(x2, y1, x2Tex, y1Tex);
    vertex(x2, y2, x2Tex, y2Tex);
    vertex(x1, y2, x1Tex, y2Tex);
  }


}

