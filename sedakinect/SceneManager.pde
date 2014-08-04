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
    scenes[2] = new TvMove();
    scenes[3] = new Slashes();
    scenes[4] = new Like();
    scenes[5] = new BigLike();
    
    scenes[6] = new WordsGrow();
    scenes[7] = new ImgGrid();
    scenes[8] = new TextShake(); 

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