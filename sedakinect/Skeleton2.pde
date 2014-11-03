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

  //  color[] userClr = new color[] {
  //   color(192,0,0),
  //   color(255,255,255),
  //   color(192,0,0), //azul
  //   color(255,255,255), //amarillo
  //   color(192,0,0),
  //   color(255,255,255)

  // };
  color[] userClr = new color[]{ 
    color(255,0,0),
    color(255,255,255),
    color(0,255,0),
    color(255,255,0),
    color(0,0,255),
    color(255,0,255),
    color(0,255,255)
   };

  boolean isBlack;
  float overlayAlpha;
  color overlayColor;
  int transX;
  int strokeW = 4;

  PVector com;                                   
  PVector com2d; 

  PFont f;

  public Skeleton2(){};

  void closeScene(){};
  void initialScene(){
    colorMode(RGB);
    isBlack = false;
    com = new PVector();
    com2d = new PVector();
    overlayAlpha = 255;
    overlayColor = color(0);
    transX = 100; 
    background(0);
    strokeCap(ROUND);
    strokeJoin(ROUND);

    f = createFont("Arial",40,true);
    textFont(f);
  };
  void drawScene(){

    getDancers();
    drawOverlay();
    scale(1.6);
    trackingSkeleton2();
  };

  String getSceneName(){return "Skeleton2";};
  void onPressedKey(String k){
    if (k == "UP") this.overlayAlpha = min(this.overlayAlpha+2,255);
    if (k == "DOWN") this.overlayAlpha = max(this.overlayAlpha-2, 4);
    if (k == "RIGHT") blackFlash();
    if (k == "LEFT") randomFlash();
    if (k == "exit") transX -=2;
    if (k == "reset") transX +=2;
    if (k == "toggle") isBlack = !isBlack;
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
    int[] userList = context.getUsers();

    for(int i=0;i<userList.length;i++)
    {
      if(context.isTrackingSkeleton(userList[i]))
      {
        //stroke(userClr[ (userList[i] - 1) % userClr.length ] );
        setStroke(i);
        drawSkeleton2(userList[i]);
      }    
      else{
        if(dancers.hasDancer(userList[i])){
          drawAlternative(userList[i],i);
        }
      }  
    } 
  }

  void setStroke(int seqNr){
    if(!isBlack) stroke(userClr[seqNr] );
    else stroke(0);
  }

  void setFill(int seqNr){
    if(!isBlack) fill(userClr[seqNr] );
    else fill(0);
  }

  void drawAlternative(int userNr, int seqNr){
     // setStroke(seqNr);
     // strokeWeight(random(10));
    setFill(seqNr);
    //float my_x = dancers.getDancerMiddle(userNr);
    PVector mt = dancers.getDancerMiddleAndTop(userNr);
    //text(userNr, my_x, random(100,height));
    text(userNr, mt.x, mt.y);
    //line(my_x,0,my_x,height);
  }

  void whiteFlash(){
    fill(255);
    noStroke();   
    rect(0,0, width, height);
  }

  void blackFlash(){
    fill(0);
    noStroke();   
    rect(0,0, width, height);
  }

  void randomFlash(){
    fill(userClr[(int)random(userClr.length-1)]);
    noStroke();   
    rect(0,0, width, height);
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

    pushMatrix();
    translate(transX,0);

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

    popMatrix();
  }

}