/**
  Scene
*/
 
interface Scene
{ 
    void initialScene();
    void drawScene();
    void closeScene();
    String getSceneName();
    void onPressedKey(String k);
    void onImg(PImage img);
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
    scenes[9] = new WordsGrow();

    actualScene = scenes[0];
  }

  void updateTimeDisplace(PImage img){
    scenes[6].onImg(img);
  }

  void setBlack(){
    background(0);
  }

  void activate(int sceneNr){
    actualScene.closeScene();
    setBlack();
    actualScene = scenes[sceneNr];
    actualScene.initialScene();
    println(sceneNr+" "+actualScene.getSceneName());
  }

  void pressedKey(String pKey){
    actualScene.onPressedKey(pKey);
  }
}

class Example implements Scene
{   
  public Example(){};

  void closeScene(){};
  void initialScene(){};
  void drawScene(){};
  String getSceneName(){return "Example";};
  void onPressedKey(String k){};
  void onImg(PImage img){};

}