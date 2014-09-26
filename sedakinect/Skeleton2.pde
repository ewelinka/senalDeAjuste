class Skeleton2 implements Scene
{   
  // color[] userClr = new color[]{ color(255,0,0),
  //                                color(0,255,0),
  //                                color(0,0,255),
  //                                color(255,255,0),
  //                                color(255,0,255),
  //                                color(0,255,255)
  //                              };

  //  color[] userClr = new color[] {
  //   color(192,192,0), 
  //   color(0,192,192), 
  //   color(0,192,0),
  //   color(192,0,192),
  //   color(192,0,0),
  //   color(0,0,192)
  // };

   color[] userClr = new color[] {

    color(192,0,192),

    color(0,0,192)
  };
  float overlayAlpha;
  color overlayColor;
  int transX;
  int strokeW = 4;

  PVector com;                                   
  PVector com2d; 

  public Skeleton2(){};

  void closeScene(){};
  void initialScene(){
    colorMode(RGB);
    com = new PVector();
    com2d = new PVector();
    overlayAlpha = 255;
    overlayColor = color(0);
    transX = 0; 
    background(0);
    strokeCap(ROUND);
    strokeJoin(ROUND);
  };
  void drawScene(){

    getDancers();
    drawOverlay();
    scale(1.6);
    translate(transX,0);
    trackingSkeleton2();
  };

  String getSceneName(){return "Skeleton2";};
  void onPressedKey(String k){
    if (k == "UP") this.overlayAlpha = min(this.overlayAlpha+2,255);
    if (k == "DOWN") this.overlayAlpha = max(this.overlayAlpha-2, 0);
    // if (k == "RIGHT") this.overlayColor = min(this.overlayColor+5,255);
    // if (k == "LEFT") this.overlayColor = max(this.overlayColor-5, 0);
    if (k == "reset") transX -=2;
    if (k == "toggle") transX+=2;
    if (k == "weight") strokeW +=1;
    if (k == "quit") strokeW = max(strokeW-1,1);

  };
  void onImg(PImage img){};

  void drawOverlay(){
    fill(overlayColor, overlayAlpha);
    noStroke();
    //ellipse(width/2,height/2, this.radius+500,this.radius+500);   
    rect(0,0, width, height);
  }

  void trackingSkeleton2(){

    getDancers();
    boolean hasSkeleton = false;
    int[] userList = context.getUsers();
    for(int i=0;i<userList.length;i++)
    {
      if(context.isTrackingSkeleton(userList[i]))
      {
        stroke(userClr[ (userList[i] - 1) % userClr.length ] );
        drawSkeleton2(userList[i]);
        hasSkeleton = true;
      }    
      else{
        //aca hay que ver como sacar el nro que va y dibujar a solo este
        // TODO hasDancer(userList[i])
        if(dancers.hasDancer(userList[i])){
          drawAlternative(userList[i]);
        }
      }  
    } 
  }

  void drawAlternative(int userNr){
    stroke(userClr[ (userNr - 1) % userClr.length ] );
    strokeWeight(random(10));
    float my_x = dancers.getDancerMiddle(userNr);
    line(my_x,0,my_x,height);

  }

  // draw the Skeleton2 with the selected joints
  void drawSkeleton2(int userId)
  {
    // to get the 3d joint data
    /*
    PVector jointPos = new PVector();
    context.getJointPositionSkeleton2(userId,SimpleOpenNI.SKEL_NECK,jointPos);
    println(jointPos);
    */

    strokeWeight(strokeW);
    
    context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

    context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

    context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

    context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
    context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

    context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
    context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  

  }

}