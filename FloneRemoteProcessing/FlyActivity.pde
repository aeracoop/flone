/**
 * Flone, The flying phone
 * By Lot Amorós from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//Main Fly Activity
static String txtString;
static int millis=0;
static int maxCycle =0;
static float vBat = 0.0;
color cBat = color(255, 0, 0);

//int flyPannelx = width/2;
//int flyPannely = (height-(width/2))/4;//(minlineY/2)+20;
//int flyPannelx = xLevelObj;
//int flyPannely = yLevelObj;

int flypannelSize = height/2 - width/2;

void drawFlyActivity() {
  lastCycle = millis;
  millis = millis();
  cycle = millis - lastCycle;
  if ((cycle>maxCycle) && (millis>5000))
    maxCycle = cycle;

  //drawPitchRoll();
  drawFlyLevel();
  drawCompass();
  drawPilotSurface();
  drawMeta();
  drawBat();
  //drawSat();
  drawState();
  drawBTState();
  updateSliders();
}

// ---------------------------------------------------------------------------------------------
// Fly Level Control Instruments
// ---------------------------------------------------------------------------------------------
void drawPitchRoll() {
  pushMatrix();
  //translate(xLevelObj-(levelBallSize/2)-4, yLevelObj+(levelBallSize)+40);
  //translate(flyPannelx, flyPannely);
  fill(50, 50, 50);
  noStroke();
  ellipse(0, 0, levelBallSize-24, levelBallSize-24);
  rotate(a);
  fill(255, 255, 127);
  //textFont(font12);
  txt=new StringBuffer().append ("ROLL");
  txtString = txt.toString();
  text(txtString, -13, 15);
  strokeWeight(1.5);
  stroke(127, 127, 127);
  line(-30, 1, 30, 1);
  stroke(255, 255, 255);
  line(-30, 0, +30, 0);
  line(0, 0, 0, -10);
  popMatrix();

  pushMatrix();
  translate(xLevelObj+(levelBallSize/2)+4, yLevelObj+(levelBallSize)+40);
  fill(50, 50, 50);
  noStroke();
  ellipse(0, 0, levelBallSize, levelBallSize);
  rotate(b);
  fill(255, 255, 127);
  //textFont(font12);
  txt=new StringBuffer().append("PITCH");
  txtString = "PITCH";
  text(txtString, -18, 15);
  strokeWeight(1.5);
  stroke(127, 127, 127);
  line(-30, 1, 30, 1);
  stroke(255, 255, 255);
  line(-30, 0, 30, 0);
  line(30, 0, 30-size/6, size/6);
  line(+30, 0, 30-size/6, -size/6);  
  popMatrix();

  // info angles
  fill(255, 255, 127);
  // textFont(font12);

  txt=new StringBuffer().append(angy).append(" º");
  txtString = txt.toString();

  // txt = (int)angy + "°";
  text(txtString, xLevelObj+(levelBallSize/2), yLevelObj+padding); //pitch
  //txt = (int)angx + "°";

  txt=new StringBuffer().append((int)angx).append(" º");
  txtString = txt.toString();
  text(txtString, xLevelObj-(levelBallSize/2), yLevelObj+padding); //roll
}

// ---------------------------------------------------------------------------------------------
// Magnetron Combi Fly Level Control
// ---------------------------------------------------------------------------------------------
StringBuffer txt = new StringBuffer();
void drawFlyLevel() {
  //horizonInstrSize=100;//68

  angyLevelControl=((angy<-horizonInstrSize) ? -horizonInstrSize : (angy>horizonInstrSize) ? horizonInstrSize : angy);
  pushMatrix();
  translate(xLevelObj, yLevelObj); 
  // translate(flyPannelx, flyPannely);

  noStroke();
  // instrument background
  fill(50, 50, 50);
  //  ellipse(0,0,150,150);
  //ellipse(0, 0, 200, 200);

  // full instrument
  rotate(-a);
  rectMode(CORNER);
  // outer border
  strokeWeight(1);
  stroke(90, 90, 90);
  //border ext
  //  arc(0,0,140,140,0,TWO_PI);
  arc(0, 0, levelSize, levelSize, 0, TWO_PI);

  stroke(190, 190, 190);
  //border int
  //arc(0,0,138,138,0,TWO_PI);
  arc(0, 0, levelSize-2, levelSize-2, 0, TWO_PI);
  // inner quadrant
  strokeWeight(1);
  stroke(255, 255, 255);
  fill(124, 73, 31);
  //earth
  //float 
  angle = acos(angyLevelControl/horizonInstrSize);
  //arc(0,0,136,136,0,TWO_PI);
  arc(0, 0, levelSize-6, levelSize-6, 0, TWO_PI);
  fill(38, 139, 224); 
  //sky 
  //arc(0,0,136,136,HALF_PI-angle+PI,HALF_PI+angle+PI);
  arc(0, 0, levelSize-6, levelSize-6, HALF_PI-angle+PI, HALF_PI+angle+PI);
  //float 
  x = sin(angle)*horizonInstrSize;
  if (angy>0) 
    fill(124, 73, 31);
  noStroke();   
  triangle(0, 0, x, -angyLevelControl, -x, -angyLevelControl);
  // inner lines
  strokeWeight(1);
  for (i=0; i<8; i++) {
    j=i*15;
    if (angy<=(35-j) && angy>=(-65-j)) {
      stroke(255, 255, 255); 
      line(-30, -15-j-angy, 30, -15-j-angy); // up line
      fill(255, 255, 255);
      //textFont(font9);
      txt=new StringBuffer('+').append(i+1).append('0');
      txtString = txt.toString();

      //txt = "+" + (i+1) + "0"; 
      text(txtString, 34, -12-j-angy); //  up value 34
      //txt = "+" + (i+1) + "0";
      textAlign(RIGHT);
      text(txtString, -37, -12-j-angy); //  up value
      textAlign(LEFT);
    }
    if (angy<=(42-j) && angy>=(-58-j)) {
      stroke(167, 167, 167); 
      line(-20, -7-j-angy, 20, -7-j-angy); // up semi-line
    }
    if (angy<=(65+j) && angy>=(-35+j)) {
      stroke(255, 255, 255); 
      line(-30, 15+j-angy, 30, 15+j-angy); // down line
      fill(255, 255, 255);
      //textFont(font9);    
      //txt = "-" + (i+1) + "0";
      txt=new StringBuffer('-').append(i+1).append('0');
      txtString = txt.toString();

      text(txtString, 34, 17+j-angy); //  down value
      //txt = "-" + (i+1) + "0";
      textAlign(RIGHT);
      text(txtString, -37, 17+j-angy); //  down value
      textAlign(LEFT);
    }
    if (angy<=(58+j) && angy>=(-42+j)) {
      stroke(127, 127, 127); 
      line(-20, 7+j-angy, 20, 7+j-angy); // down semi-line
    }
  }
  strokeWeight(2);
  stroke(255, 255, 255);
  if (angy<=50 && angy>=-50) {
    line(-40, -angy, 40, -angy); //center line
    fill(255, 255, 255);
    //textFont(font9);
    //txt=new StringBuffer('0');
    //txtString = txt.toString();    
    //txt = "0";
    text('0', 34, 4-angy); // center
    textAlign(RIGHT);
    text('0', -37, 4-angy); // center
    textAlign(LEFT);
  }

  // lateral arrows
  strokeWeight(1);
  // down fixed triangle
  stroke(60, 60, 60);
  fill(180, 180, 180, 255);

  triangle(-horizonInstrSize, -8, -horizonInstrSize, 8, -55, 0);
  triangle(horizonInstrSize, -8, horizonInstrSize, 8, 55, 0);

  // center
  strokeWeight(1);
  stroke(255, 0, 0);
  line(-20, 0, -5, 0); 
  line(-5, 0, -5, 5);
  line(5, 0, 20, 0); 
  line(5, 0, 5, 5);
  line(0, -5, 0, 5);
  popMatrix();
}

int floneAngle=0;
void drawCompass() {
  // ---------------------------------------------------------------------------------------------
  // Compass Section
  // ---------------------------------------------------------------------------------------------
  pushMatrix();
  //translate(xCompass, yCompass);
  noFill();
  //stroke(255);
  // rect(xLevelObj-30, 8, 60, 48, 10);
  //line(xLevelObj, 50, xLevelObj, 70);
  floneAngle = int(head<0 ? abs(head) : abs(head-360));
  txt=new StringBuffer().append(floneAngle).append(" º");
  txtString = txt.toString();
  //text(txtString, xCompass-11-(head>=10.0 ? (head>=100.0 ? 6 : 3);
  stroke(255, 255);
  text(txtString, xLevelObj-10, doublePadding);
  translate(xLevelObj, yLevelObj);

  //  translate(flyPannelx, flyPannely);
  //int angle = int(head*PI/180);
  rotate(head*PI/180);    
  image(compassImg, 0, 0, 100*density, 100*density);
  popMatrix();
}

int xPilot=0;
int yPilot= (height/2)-(width/2);
int phoneAngle=0;

void drawPilotSurface() {
  lineY = (int) map(rcThrottle, 1000, 2000, maxlineY-20, minlineY+20);
  lineY = (int) constrain(lineY, minlineY+20, maxlineY-20);

  strokeWeight(15);
  stroke(255, 0, 0);
  line(0, lineY, width, lineY);

  strokeWeight(1);
  stroke(255, 255, 255, 255);
  fill(0, 0, 100, 100);
  rectMode(CENTER);
  rect((width/2), (height/2), width-(padding*2), width-(padding*2), 10);

  fill(200, 0, 0, 100);
  //ellipse( (width/2), (height/2), width-(padding*4), width-(padding*4));
  ellipse( (width/2), (height/2), (width/2)+150, (width/2)+150);
  for (int i=2; i<7; i++) {
    ellipse( (width/2), (height/2), (width/i), (width/i));
  }
  noFill();
  stroke(255, 255, 255, 255);

  //PhoneAngle Box
  phoneAngle = int(azimuth<0 ? abs(360+azimuth) : abs(azimuth));
  txt=new StringBuffer().append(phoneAngle).append(" º");
  txtString = txt.toString();
  fill(0, 0, 0, 100);
  rect(width/2, (height/3)-65, 42, 24, 10);
  fill(255, 255, 255, 255);
  text(txtString, (width/2)-doublePadding, (height/3) - 60);
  strokeWeight(8);
  line(width/2, (height/3)-20, width/2, (height/3)+20);

  pushMatrix();
  translate((width/2), (height/2));
  rotate(-radians(azimuth));
  //rotate(-radians(averageAngle()));
  image(compassImg, 0, 0, (width/2)+(90*density), (width/2)+90*density);
  popMatrix();

  posY = (int) map(rcRoll, minRC, maxRC, height, 0);
  posX = (int) map(rcPitch, minRC, maxRC, width, 0);

  fill(128);
  pushMatrix();
  translate(width-posX, posY);
  rotate (head*PI/180);
  image(floneImg, 0, 0, 200*density, 200*density);
  popMatrix();

  a=radians(angx);
  if (angy<-90) b=radians(-180 - angy);
  else if (angy>90) b=radians(+180 - angy);
  else b=radians(angy);
  h=radians(head);
}

void drawMeta() {
  txt = new StringBuffer().append(int(frameRate)).append("fps/Cycle:").append(cycle).append("ms/MaxCycle:").append(maxCycle).append("ms");
  txtString = txt.toString();
  text(txtString, padding, ((height/2) + (width/2))+padding);

  txt = new StringBuffer("Mag:").append(cycleMag).append("ms/Acc:").append(cycleAcc);
  txtString = txt.toString();
  text(txtString, (width/2)+80, ((height/2)+(width/2))+padding);
}

void drawState() {
 // text("BT Name:", 0, height-padding-buttonHeight);
}

void drawBat() {
  //  image(batImg, (width/2)-70, height-50-padding,50*density,50*density);
  /*txt = new StringBuffer("10.1 V");
   txtString = txt.toString();
   text(txtString, (width/2)+50, height-50);*/

  vBat = bytevbat/10.0f;
  if (vBat < 9.9 )
    cBat = color(220, 0, 0);
  else
    if (vBat < 10.7) 
    cBat = color(220, 220, 50);
  else
    cBat = color(10, 220, 10);
}

void drawSat() {
  //image(satImg, (width/2)+110, height-50-padding, 50*density,50*density );
  /*txt = new StringBuffer("8");
   txtString = txt.toString();
   text(txtString, (width/2)+200, height-50);*/
}


void drawBTState() {
  if (btConnected() == true)
    image(btImg, width-padding-int(25*density), height-padding-int(25*density), 50*density, 50*density);
  else
    image(btNoImg, width-padding-int(25*density), height-padding-int(25*density), 50*density, 50*density);
}


void updateSliders() {
  //Update Sliders    
  rcStickThrottleSlider.setValue(rcThrottle);
  rcStickRollSlider.setValue(rcRoll);
  rcStickPitchSlider.setValue(rcPitch);
  rcStickYawSlider.setValue(rcYaw);
  rcStickAUX1Slider.setValue(rcAUX1);
  rcStickAUX2Slider.setValue(rcAUX2);
  rcStickAUX3Slider.setValue(rcAUX3);
  rcStickAUX4Slider.setValue(rcAUX4);

  batKnob.setValue(vBat);
  //batKnob.setColorForeground(color(255));
  batKnob.setColorBackground(cBat);
} 


/*
  fill(0, 0, 0);
 strokeWeight(3);
 stroke(0);
 rectMode(CORNERS);
 //size=48;
 //rect(-size*2.5,-size*2.5,size*2.5,size*2.5);
 // GPS quadrant
 strokeWeight(1.5);
 if (GPS_update == 1) {
 fill(125);
 stroke(125);
 } 
 else {
 fill(160);
 stroke(160);
 }
 ellipse(0, 0, 4*size+7, 4*size+7);
 // GPS rotating pointer
 rotate(GPS_directionToHome*PI/180);
 strokeWeight(4);
 stroke(255, 255, 100);
 line(0, 0, 0, -2.4*size);
 line(0, -2.4*size, -5, -2.4*size+10); 
 line(0, -2.4*size, +5, -2.4*size+10);  
 rotate(-GPS_directionToHome*PI/180);
 // compass quadrant
 strokeWeight(1.5);
 fill(0);
 stroke(0);
 ellipse(0, 0, 2.6*size+7, 2.6*size+7);
 // Compass rotating pointer
 stroke(255);
 rotate(head*PI/180);
 line(0, size*0.2, 0, -size*1.3); 
 line(0, -size*1.3, -5, -size*1.3+10); 
 line(0, -size*1.3, +5, -size*1.3+10);
 popMatrix();
 // angles 
 for (i=0;i<=12;i++) {
 angCalc=i*PI/6;
 if (i%3!=0) {
 stroke(75);
 line(xCompass+cos(angCalc)*size*2, yCompass+sin(angCalc)*size*2, xCompass+cos(angCalc)*size*1.6, yCompass+sin(angCalc)*size*1.6);
 } 
 else {
 stroke(255);
 line(xCompass+cos(angCalc)*size*2.2, yCompass+sin(angCalc)*size*2.2, xCompass+cos(angCalc)*size*1.9, yCompass+sin(angCalc)*size*1.9);
 }
 }
 //  textFont(font15);
 //txt= "N";
 //txt=new StringBuffer('+').append(i+1).append('0');
 //txtString = txt.toString();   
 text('N', xCompass-5, yCompass-22-size*0.9);
 //txt="S";
 text('S', xCompass-5, yCompass+32+size*0.9);
 //txt= "W";
 text('W', xCompass-33-size*0.9, yCompass+6);
 //txt ="E";
 text('E', xCompass+21+size*0.9, yCompass+6);
 // head indicator
 //  textFont(font12);
 noStroke();
 fill(80, 80, 80, 130);
 rect(xCompass-22, yCompass-8, xCompass+22, yCompass+9);
 fill(255, 255, 127);
 //txt = head + "°"; 
 txt=new StringBuffer("head:").append(head).append('º');
 txtString = txt.toString();
 text(txtString, xCompass-11-(head>=10.0 ? (head>=100.0 ? 6 : 3) : 
 0), yCompass+6);
 // GPS direction indicator
 fill(255, 255, 0);
 //txt = GPS_directionToHome + "°";
 txt=new StringBuffer("GPS_directionToHome").append('º');
 txtString = txt.toString();
 text(txtString, xCompass-6-size*2.1, yCompass+7+size*2);
 // GPS fix
 if (GPS_fix==0) {
 fill(127, 0, 0);
 } 
 else {
 fill(0, 255, 0);
 }
 //ellipse(xCompass+3+size*2.1,yCompass+3+size*2,12,12);
 rect(xCompass-28+size*2.1, yCompass+1+size*2, xCompass+9+size*2.1, yCompass+13+size*2);
 //  textFont(font9);
 if (GPS_fix==0) {
 fill(255, 255, 0);
 } 
 else {
 fill(0, 50, 0);
 }
 txtString = "GPS_fix"; 
 text(txtString, xCompass-27+size*2.1, yCompass+10+size*2);*/

