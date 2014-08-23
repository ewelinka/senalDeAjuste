class Skeleton implements Scene
{   
  // color[] userClr = new color[]{ color(255,0,0),
  //                                color(0,255,0),
  //                                color(0,0,255),
  //                                color(255,255,0),
  //                                color(255,0,255),
  //                                color(0,255,255)
  //                              };

   color[] userClr = new color[] {
    color(192,192,0), 
    color(0,192,192), 
    color(0,192,0),
    color(192,0,192),
    color(192,0,0),
    color(0,0,192)
  };
  float overlayAlpha;
  color overlayColor;
  int transX;
  int strokeW = 1;

  PVector com;                                   
  PVector com2d; 

  public Skeleton(){};

  void closeScene(){};
  void initialScene(){
    com = new PVector();
    com2d = new PVector();
    float overlayAlpha = 250;
    color overlayColor = color(255);
    transX = 0; 


    background(255);
  };
  void drawScene(){
    drawOverlay();
    scale(1.6);
    translate(transX,0);
    trackingSkeleton();
  };

  String getSceneName(){return "Skeleton";};
  void onPressedKey(String k){
    if (k == "UP") this.overlayAlpha = min(this.overlayAlpha+5,255);
    if (k == "DOWN") this.overlayAlpha = max(this.overlayAlpha-5, 0);
    if (k == "RIGHT") this.overlayColor = min(this.overlayColor+5,255);
    if (k == "LEFT") this.overlayColor = max(this.overlayColor-5, 0);
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

  void trackingSkeleton(){
    context.update();
  
    // draw depthImageMap
    //image(context.depthImage(),0,0);
    //image(context.userImage(),0,0);
    // draw the skeleton if it's available
    int[] userList = context.getUsers();
    for(int i=0;i<userList.length;i++)
    {
      if(context.isTrackingSkeleton(userList[i]))
      {
        stroke(userClr[ (userList[i] - 1) % userClr.length ] );
        drawSkeleton(userList[i]);
      }      
        
      // draw the center of mass
      if(context.getCoM(userList[i],com))
      {
        context.convertRealWorldToProjective(com,com2d);
        stroke(255,0,0);
        strokeWeight(strokeW);
        beginShape(LINES);
          vertex(com2d.x,com2d.y - 5);
          vertex(com2d.x,com2d.y + 5);

          vertex(com2d.x - 5,com2d.y);
          vertex(com2d.x + 5,com2d.y);
        endShape();
        
        fill(255,0,0);
        text(Integer.toString(userList[i]),com2d.x,com2d.y);
      }
    } 
  }

  // draw the skeleton with the selected joints
  void drawSkeleton(int userId)
  {
    // to get the 3d joint data
    /*
    PVector jointPos = new PVector();
    context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
    println(jointPos);
    */
    
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