class Tv implements Scene
{   
  
  color[] main_bars={ 
    color(192,192,192), 
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192)
  };

  IntList excluded;

  int tv_width,tv_height;
  int bars_nr,bar_width;

  public Tv(){};

  void closeScene(){};

  void initialScene(){
    background(0);
    tv_width = width;
    tv_height = height;
    bars_nr =7;
    bar_width = tv_width / bars_nr +1;
    excluded = new IntList();
  };

  void drawScene(){
    
    drawNoise();
    getDancers();
    generateExcluded();
    drawTv(tv_width,tv_height,7,main_bars);
    drawLine();

  };

  String getSceneName(){return "Tv";};

  void onPressedKey(String k){};

  void onImg(PImage img){};

  void drawNoise(){
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

  void drawTv(int window_w, int window_h, int bars_nr, color[] colors) {
    noSmooth();
    noStroke();
    

    int x1;
    for (int i = 0; i < bars_nr; i ++) {
      fill(colors[i]);
      x1 = (int)(i * bar_width);
      if(!excluded.hasValue(i)) rect(x1, 0, bar_width, window_h); 
    }
  }

  void generateExcluded(){
    excluded.clear();
    for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {
      Dancer da = idancer.getValue();
      float middle_x = da.getMiddle();
      excluded.append((int)(middle_x/ bar_width));
    }    
  }
}

