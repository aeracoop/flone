/**
 * Flone, The flying phone
 * By Aeracoop
 * GPL v3
 */

import ketai.sensors.*;
import controlP5.*;
//import processing.serial.Serial; // serial library

import processing.opengl.*; 
import java.lang.StringBuffer; // for efficient String concatemation

//required for BT enabling on startup
import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;


//MultiwiiGUI
//Serial g_serial;
int multiType;

//boolean PressA = false;
//boolean PressC= false;
boolean lock = true;

int version, versionMisMatch;
float gx, gy, gz, ax, ay, az, magx, magy, magz, alt, head, angx, angy, debug1, debug2, debug3, debug4;
int GPS_distanceToHome, GPS_directionToHome, 
GPS_numSat, GPS_fix, GPS_update, GPS_altitude, GPS_speed, 
GPS_latitude, GPS_longitude, 
init_com, graph_on, pMeterSum, intPowerTrigger, bytevbat;

float mot[] = new float[8], 
servo[] = new float[8], 
rcThrottle = 1500, rcRoll = 1500, rcPitch = 1500, rcYaw =1500, 
rcAUX1=1500, rcAUX2=1500, rcAUX3=1500, rcAUX4=1500;

int cycleTime, i2cError;    

int  byteRC_RATE, byteRC_EXPO, byteRollPitchRate, byteYawRate, byteDynThrPID, byteThrottle_EXPO, byteThrottle_MID;

int byteMP[] = new int[8];  // Motor Pins.  Varies by multiType and Arduino model (pro Mini, Mega, etc).

cDataArray accPITCH   = new cDataArray(200), accROLL    = new cDataArray(200), accYAW     = new cDataArray(200), 
gyroPITCH  = new cDataArray(200), gyroROLL   = new cDataArray(200), gyroYAW    = new cDataArray(200), 
magxData   = new cDataArray(200), magyData   = new cDataArray(200), magzData   = new cDataArray(200), 
altData    = new cDataArray(200), headData   = new cDataArray(200), 
debug1Data = new cDataArray(200), debug2Data = new cDataArray(200), debug3Data = new cDataArray(200), debug4Data = new cDataArray(200);

private static final int ROLL = 0, PITCH = 1, YAW = 2, ALT = 3, VEL = 4, LEVEL = 5, MAG = 6;

//MultiwiiGUI
ControlP5 cp5;
int col = color(255);

KetaiSensor sensor;
float rotationX=0, rotationY=0, rotationZ=0;
float minX=0, maxX=0, minY=0, maxY=0;

int throtle=0;
int pitch=0;
int roll=0;
int yaw=0;
int aux1=0;

int posX=0, posY=0;

PFont fontFlone;
PImage floneImg;

boolean isConfiguring = true;
KetaiBluetooth bt;

int lineY;
int minlineY;
int maxlineY;

void setup()
{  
  String[] fontList = PFont.list();
  println(fontList);

  minX = -8;
  minY = -8;
  maxX = 8;
  maxY = 8;

  minlineY = (height/2) - (width/2);
  maxlineY = (height/2) + (width/2);

  //fontFlone = loadFont("Soviet-12.vlw");
  fontFlone = createFont("Soviet2", 20);
  textFont(fontFlone, 20);

  imageMode(CENTER);
  floneImg = loadImage("flonesolo-150.png");

  cp5 = new ControlP5(this); 
  bt.start();
  bt.discoverDevices();
 
  int buttonWidth =60;
  int buttonHeight=60;

  cp5.addButton("calibrate_Flone")
    .setValue(0)
      .setPosition(20, height-100)
        .setSize(buttonWidth, buttonHeight);  

  cp5.addToggle("Arm")
    .setPosition(40 + buttonWidth, height-100)
      .setSize(buttonWidth, buttonHeight);

  cp5.addToggle("Rec")
    // .setValue(0)
    .setPosition(60 + buttonWidth*2, height-100)
      .setSize(buttonWidth, buttonHeight);

  cp5.addButton("BT_info")
    .setPosition(80 + buttonWidth*3, height-100)
      .setSize(buttonWidth, buttonHeight);

  cp5.addToggle("BT_Connected")
    .setPosition(100 + buttonWidth*4, height-100)
      .setSize(buttonWidth, buttonHeight);

  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(PORTRAIT);
  textAlign(LEFT, TOP);
  // textSize(36);
}

void draw()
{
  fill(0, 0);
  background(0);
  bluetoothLoop();
  drawFlyActivity();   

  //Send values
  throtle = (int) map(mouseY, minlineY, maxlineY, 2000, 1000);
  pitch = (int) map(rotationX, minX, maxX, 2000, 1000);
  roll = (int) map(rotationY, minY, maxY, 2000, 1000);
  //yaw = (int) map(rotationZ,minY,maxY,2000,1000);


  throtle = constrain(throtle, 1000, 2000);
  pitch = constrain(pitch, 1000, 2000);
  roll = constrain(roll, 1000, 2000);
  yaw=(int)rotationZ;

  //  if(bt.)
}

public void motorsMounted(int theValue) {
  println("Motor state: "+theValue);
}


public void calibrateFlone(int theValue) {
  println("calibrating flone: "+theValue);
}


void onGravityEvent(float x, float y, float z) 
{
  rotationX = x;
  rotationY = y;
}

void onMagneticFieldEvent(float x, float y, float z) {
  rotationZ = x;
}


/*
public boolean onCreateOptionsMenu(Menu menu) {
 MenuInflater inflater = getMenuInflater();
 inflater.inflate(R.menu.game_menu, menu);
 return true;
 }*/
