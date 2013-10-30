

void drawFlyActivity(){
   background(78, 93, 75);

lineY = constrain(mouseY,minlineY,maxlineY);

strokeWeight(5);
stroke(255,0,0);
line(0, lineY, width, lineY);
strokeWeight(1);
stroke(255,255,255,255);

  text("Output to flone: \n" + 
    "Throtle: " + throtle + "\n" +
    "Pitch: " + pitch + "\n" +
    "Roll: " + roll  + "\n" +
    "Yaw: " + yaw + "\n" +
    "Aux 1: " + aux1, 10, 10); 
    
  text("Calibration: \n" + 
    "x: min: " + nfp(minX, 1, 2) + "max: " + nfp(maxX, 1, 2) + "\n" +
    "y: min" + nfp(minY, 1, 2) + "max: " + nfp(maxY, 1, 2), 200, 10); 
    
   
  text("Rotation Absolute: \n" + 
    "x: " + nfp(rotationX, 1, 2) + "\n" +
    "y: " + nfp(rotationY, 1, 2) + "\n" +
    "z: " + nfp(rotationZ, 1, 2), 500, 500); 
   
    fill(200,0,0,100);
    ellipse( (width/2) ,(height/2) ,width-60,width-60);
    for (int i=2;i<7;i++){
      ellipse( (width/2) ,(height/2) ,width/i,width/i);
    }

    posX = (int) map(rotationX,minX,maxX,0,width);
    posY = (int) map(rotationY,minY,maxY,0,height);
    
    fill(128);
    //ellipse( (width/2) + relativeX*50,(height/2) +relativeY*50,50,50);
    //ellipse( width-posX,posY,50,50);
    image(floneImg,width-posX,posY);

    fill(0,0,100,100);
    rectMode(CENTER);
    rect((width/2) ,(height/2),width-40,width-40,10);
    
    /*
    if(!phoneCalibrated)
      text("Teléfono no calibrado. Calibralo para volar a Flone",10,height-100);
    else{
      line(0, minThrotle, width, minThrotle);
      line(0, maxThrotle, width, maxThrotle);      
    }*/
    
    
}
