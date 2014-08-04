import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 
import blobDetection.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class testDepthMap extends PApplet {




SimpleOpenNI context;
PImage img,bigImg;


public void setup()
{
  size(1024,768,P3D);  // strange, get drawing error in the cameraFrustum if i use P3D, in opengl there is no problem
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  // disable mirror
  //context.setMirror(false);

  // enable depthMap generation 
  context.enableDepth();
  context.enableUser();
  // enable skeleton generation for all joints
  img = new PImage(context.depthWidth(),context.depthHeight()); 
  img.loadPixels();
  bigImg = new PImage(width,height); 
  bigImg.loadPixels();


  println("setup ready, w: "+width+" h: "+height);
}

public void draw()
{
  background(0,22);
  context.update();

  int[]   depthMap = context.depthMap();
  int[]   userMap = context.userMap();

  int steps = 1;
  int index;

  int maxH = height;

  float maxR = 0;
  int maxR_raw =0;
  float maxRight_y =0;


  for(int y=0;y < context.depthHeight();y+=steps)
  {
    for(int x=0;x < context.depthWidth();x+=steps)
    {
      index = x + y * context.depthWidth();
      int d = depthMap[index];
      if( d > 0){
        img.pixels[index] = color(map(d,353,10000,0,255));
         if(userMap[index] > 0)
         { 
           img.pixels[index] = color(map(d,353,10000,0,255),0,0);
           if (y < maxH){
             maxH = y;
           }
           if (x> maxR_raw){

              maxR = map(x,0,640,0,1024);
              maxR_raw = x;
              maxRight_y = map(y,0,480,0,768);
              println("new maxR "+maxR_raw);

           }
         }
      } 
      else img.pixels[index] = color(0,0,0);
    }
  } 
  img.updatePixels(); 


  bigImg.copy(img, 0, 0, 640, 480, 0, 0, width, height);
  image(bigImg,0,0);

  stroke(255,255,0);
  float newH = map(maxH,0,480,0,768);
  line(0,newH,width,newH);
  line(maxR,0,maxR,height);
  if(maxR < 600) textAlign(LEFT);
  else textAlign(RIGHT);
  fill(255,0,0);
  text(maxR_raw,maxR,maxRight_y);

}


// void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
// {
//   noFill();
//   Blob b;
//   EdgeVertex eA,eB;
//   for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
//   {
//     b=theBlobDetection.getBlob(n);
//     if (b!=null)
//     {
//       // Edges
//       if (drawEdges)
//       {
//         strokeWeight(3);
//         stroke(0,255,0);
//         for (int m=0;m<b.getEdgeNb();m++)
//         {
//           eA = b.getEdgeVertexA(m);
//           eB = b.getEdgeVertexB(m);
//           if (eA !=null && eB !=null)
//             line(
//               eA.x*width, eA.y*height, 
//               eB.x*width, eB.y*height
//               );
//         }
//       }

//       // Blobs
//       if (drawBlobs)
//       {
//         strokeWeight(1);
//         stroke(255,0,0);
//         rect(
//           b.xMin*width,b.yMin*height,
//           b.w*width,b.h*height
//           );
//       }

//     }

//       }
// }

// int getBiggestBlobIndex(){
//   Blob b;
//   EdgeVertex eA,eB;
//   int index = -1;
//   float maxBlobSize = 0;
//   for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
//   {
//     b=theBlobDetection.getBlob(n);
//     if (b!=null)
//     {
//       // if the we found bigger then biggest until now
//       if (b.w*width*b.h*height > maxBlobSize){
//         index = n;
//       }
//     }
//   }
//   return index;
// }


// void drawArroundBiggest(){
//   int index = getBiggestBlobIndex();
//   // we draw in new position if there is a blob
//   if(index > -1){
//     Blob b=theBlobDetection.getBlob(index);
//     float r = b.w*width;
//     if(b.h*height> r){
//       r=b.h*height;
//     }
//     drawWords(b.x*width,b.y*height,r);

//   }
// }


// // ==================================================
// // Super Fast Blur v1.1
// // by Mario Klingemann 
// // <http://incubator.quasimondo.com>
// // ==================================================
// void fastblur(PImage img,int radius)
// {
//  if (radius<1){
//     return;
//   }
//   int w=img.width;
//   int h=img.height;
//   int wm=w-1;
//   int hm=h-1;
//   int wh=w*h;
//   int div=radius+radius+1;
//   int r[]=new int[wh];
//   int g[]=new int[wh];
//   int b[]=new int[wh];
//   int rsum,gsum,bsum,x,y,i,p,p1,p2,yp,yi,yw;
//   int vmin[] = new int[max(w,h)];
//   int vmax[] = new int[max(w,h)];
//   int[] pix=img.pixels;
//   int dv[]=new int[256*div];
//   for (i=0;i<256*div;i++){
//     dv[i]=(i/div);
//   }

//   yw=yi=0;

//   for (y=0;y<h;y++){
//     rsum=gsum=bsum=0;
//     for(i=-radius;i<=radius;i++){
//       p=pix[yi+min(wm,max(i,0))];
//       rsum+=(p & 0xff0000)>>16;
//       gsum+=(p & 0x00ff00)>>8;
//       bsum+= p & 0x0000ff;
//     }
//     for (x=0;x<w;x++){

//       r[yi]=dv[rsum];
//       g[yi]=dv[gsum];
//       b[yi]=dv[bsum];

//       if(y==0){
//         vmin[x]=min(x+radius+1,wm);
//         vmax[x]=max(x-radius,0);
//       }
//       p1=pix[yw+vmin[x]];
//       p2=pix[yw+vmax[x]];

//       rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
//       gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
//       bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
//       yi++;
//     }
//     yw+=w;
//   }

//   for (x=0;x<w;x++){
//     rsum=gsum=bsum=0;
//     yp=-radius*w;
//     for(i=-radius;i<=radius;i++){
//       yi=max(0,yp)+x;
//       rsum+=r[yi];
//       gsum+=g[yi];
//       bsum+=b[yi];
//       yp+=w;
//     }
//     yi=x;
//     for (y=0;y<h;y++){
//       pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
//       if(x==0){
//         vmin[y]=min(y+radius+1,hm)*w;
//         vmax[y]=max(y-radius,0)*w;
//       }
//       p1=x+vmin[y];
//       p2=x+vmax[y];

//       rsum+=r[p1]-r[p2];
//       gsum+=g[p1]-g[p2];
//       bsum+=b[p1]-b[p2];

//       yi+=w;
//     }
//   }

// }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "testDepthMap" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
