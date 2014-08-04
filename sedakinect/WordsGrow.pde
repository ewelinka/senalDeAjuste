class WordsGrow implements Scene
{   
  String message = "Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. Methodology can also be applied to a sketch where characters from a String move independently of one another. The following WordsGrow uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually. ";
  PFont f;
  Word[] words;
  int h = 20;


  public WordsGrow(){};

  void closeScene(){};

  void initialScene(){
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

  void drawScene(){

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

  String getSceneName(){return "WordsGrow";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

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
    void display() {
      fill(0);
      textSize(fontSize);
      textAlign(CENTER);
      text(word,x,y);
    }

    // Return to original size
    void home() {
      if(fontSize!=homeh) fontSize=max(homeh, fontSize-1);
    }


    void growIfYouCan(){
      if(canGrow) fontSize= min(fontSize+1,60);
    }


  }
}


