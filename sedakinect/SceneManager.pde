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

    Scene [] allScenes = {  new Nothing(),
                new Tv(), //1
                new TvNoise(), //2
                new TvMove(), //3
                new Slashes(), //4
                new Skeleton(), //5
                new WordsGrow(), //6
                new Fireworks(), //7
                new Balls(), //8
                new HBVideo(), //9
                new Like(),
                new BigLike(),
                new TextShake()
                
              };

    scenes =allScenes;
    scenes[0].initialScene();
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