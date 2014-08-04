class TextShake implements Scene
{   
  String message = "methodology can also be applied to a sketch where characters from a String move independently of one another. The following TextShake uses object-oriented design to make each character from the original String a Letter object, allowing it to both be a displayed in its proper location as well as move about the screen individually.";
  Letter[] letters;
  int h = 30;
  PFont f;

  public TextShake(){};

  void closeScene(){};

  void initialScene(){
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

  void drawScene(){
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

  String getSceneName(){return "TextShake";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

  // A class to describe a single Letter
  class Letter {
    char letter;
    // The object knows its original "home" location
    float homex,homey;
    char homeletter;
    // As well as its current location
    float x,y;
    color fillHome=color(0);
    color fillValue=fillHome;

    Letter (float x_, float y_, char letter_) {
      homex = x = x_;
      homey = y = y_;
      letter = letter_; 
      homeletter = letter_;
    }

    // Display the letter
    void display() {
      fill(fillValue);
      textAlign(LEFT);
      text(letter,x,y);
    }

    // Move the letter randomly
    void shake() {
      x += random(-2,2);
      y += random(-2,2);
    }

    // Return the letter home
    void home() {
      x = homex;
      y = homey; 
      letter = homeletter;
      fillValue = fillHome;
    }

    void change(char now, char newletter){
      if (now == letter) {
        letter = newletter;
        fillValue = color(255,0,0);
      }

    }
  }
}


