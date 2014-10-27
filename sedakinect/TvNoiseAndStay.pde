class TvNoiseAndStay implements Scene
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


  AudioPlayer tuuu ;
  AudioPlayer whiteNoise;
  AudioPlayer third;

  boolean isWhite;
  boolean first;

  public TvNoiseAndStay(){};

  void closeScene(){
    tuuu.close();
    whiteNoise.close();
    third.close();
    minim.stop();
    //super.stop();
  };

  void initialScene(){
    first = true;
    colorMode(RGB);
    background(0);

    tv_width = width;
    tv_height = height;
    bars_nr =7;
    bar_width = tv_width / bars_nr +1;
    excluded = new IntList();

    //minim = new Minim (this);
    tuuu = minim.loadFile ("1.mp3");
    tuuu.loop();
    whiteNoise  = minim.loadFile ("ruido1.mp3");
    third = minim.loadFile ("ruido2.mp3");
    isWhite = false;

  };

  void drawScene(){
    drawNoise();
    getDancers();
        // esta va solo para probar si mejora el macaquito!!!
   // int[] userList = context.getUsers();
    // ---------------------------------------
    // we draw just one snow stripe or we cover the surface
    if(first == true) drawScene1();
    else drawScene2();
    drawTv(tv_width,tv_height,7,main_bars);
    drawLine();
  }

  void drawScene1(){
    generateExcluded();
    playNoise();
  };

  void drawScene2(){
    addExcluded();
    playNoise2();
  };

  String getSceneName(){return "TvNoiseAndStay";};

  void onPressedKey(String k){
    if (k == "toggle") first = !first;
  };

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

  void addExcluded(){
    for (Entry<Integer,Dancer> idancer : dancers.hm.entrySet()) {
      Dancer da = idancer.getValue();
      float middle_x = da.getMiddle();
      int newVal = (int)(middle_x/ bar_width);
      // if not present we add
      if(!excluded.hasValue(newVal)) excluded.append(newVal);
    }    
  }

  void playNoise(){
    if(excluded.size()==1){
      tuuu.pause();
      third.pause();
      if(whiteNoise.isPlaying() == false){
        whiteNoise.rewind();
        whiteNoise.play();
      }
    } else if(excluded.size()==2){
      tuuu.pause();
      whiteNoise.pause();
      if(third.isPlaying()== false){
        third.rewind();
        third.play();
      }
    }else{
      whiteNoise.pause();
      third.pause();
      if(tuuu.isPlaying() == false){
        tuuu.rewind();
        tuuu.play();
      }
    }
  }

  void playNoise2(){
    if(excluded.size()>0){
      tuuu.pause();
      if(whiteNoise.isPlaying() == false){
        whiteNoise.rewind();
        whiteNoise.play();
      }
    }else{
      whiteNoise.pause();
      if(tuuu.isPlaying() == false){
        tuuu.rewind();
        tuuu.play();
      }
    }
  }

}

