/**
 * Flone, The flying phone
 * By Lot Amorós from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//Garvage Collector
import java.lang.management.GarbageCollectorMXBean;
import java.lang.management.ManagementFactory;

import java.util.List;
import java.util.LinkedList;
import controlP5.*;
import java.lang.StringBuffer; // for efficient String concatemation

//required for BT enabling on startup
import android.content.Intent;
import android.os.Bundle;
import ketai.net.bluetooth.*;
/*import ketai.ui.*;
 import ketai.net.*;*/

import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import android.util.DisplayMetrics; 

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.os.Bundle;

// Sensor objects
static SensorManager mSensorManager;
static SensorEventListener sensorEventListener;
static Sensor accelerometer;
static Sensor magnetometer;

static boolean sensorAvailable = false;

static Float azimuth       = 0.0;
static Float pitch         = 0.0;
static Float roll          = 0.0;

//static float m;// = millis();
//static int s;// = second();

//Time control variables
static int cycle = 0;   //Activity
static int lastCycle = 0;
static int cycleAcc = 0;  //Gravity
static int lastCycleAcc = 0;
static int cycleMag = 0;  //MagneticField
static int lastCycleMag = 0;
static int cycleGPS = 0;  //GlobalPosition
static int lastCycleGPS = 0;

//MultiwiiGUI
//Serial g_serial;
//cGraph g_graph;
static final int windowsX    = 1000;       
static final int windowsY    = 540;
static final int xGraph      = 10;         
static final int yGraph      = 325;
static final int xObj        = 520;        
static final int yObj        = 293; //900,450
static int xCompass    = 100;        
static int yCompass    = 8; //760,336
static int xLevelObj   = 20;        
static int yLevelObj   = 20; //760,80
static final int xParam      = 120;        
static final int yParam      = 5;
static int xRC         = 690;        
static int yRC         = 10; //850,10
static final int xMot        = 690;        
static final int yMot        = 155; //850,155
static final int xButton     = 845;        
static final int yButton     = 231; //685,222
static final int xBox        = 415;        
static final int yBox        = 10;
static final int xGPS        = 853;        
static final int yGPS        = 438; //693,438

static int multiType;
static boolean lock = true;

private static int present = 0;
static int time, time2, time3, time4;

//List<Character> payload;

static int version, versionMisMatch;
static float gx, gy, gz, ax, ay, az, magx, magy, magz, alt, head, angx, angy, debug1, debug2, debug3, debug4;
static int GPS_distanceToHome, GPS_directionToHome, 
GPS_numSat, GPS_fix, GPS_update, GPS_altitude, GPS_speed, 
GPS_latitude, GPS_longitude, 
init_com, graph_on, pMeterSum, intPowerTrigger, bytevbat;

static float mot[] = new float[8];

static int servo[] = new int[8], 
rcThrottle = 1500, rcRoll = 1500, rcPitch = 1500, rcYaw =1500, 
rcAUX1=1500, rcAUX2=1500, rcAUX3=1500, rcAUX4=1500;

static final int minRC = 1000, maxRC = 2000, medRC = 1500;

static int cycleTime, i2cError;    

static int  byteRC_RATE, byteRC_EXPO, byteRollPitchRate, byteYawRate, byteDynThrPID, byteThrottle_EXPO, byteThrottle_MID;

static final int byteMP[] = new int[8];  // Motor Pins.  Varies by multiType and Arduino model (pro Mini, Mega, etc).

cDataArray
accPITCH   = new cDataArray(200), accROLL    = new cDataArray(200), accYAW     = new cDataArray(200), 
gyroPITCH  = new cDataArray(200), gyroROLL   = new cDataArray(200), gyroYAW    = new cDataArray(200), 
magxData   = new cDataArray(200), magyData   = new cDataArray(200), magzData   = new cDataArray(200), 
altData    = new cDataArray(200), headData   = new cDataArray(200), 
debug1Data = new cDataArray(200), debug2Data = new cDataArray(200), debug3Data = new cDataArray(200), debug4Data = new cDataArray(200);

private static final int ROLL = 0, PITCH = 1, YAW = 2, ALT = 3, VEL = 4, LEVEL = 5, MAG = 6;

//MultiwiiGUI
static ControlP5 cp5;
final int col = color(255);

Slider rcStickThrottleSlider, rcStickRollSlider, rcStickPitchSlider, rcStickYawSlider, rcStickAUX1Slider, rcStickAUX2Slider, 
rcStickAUX3Slider, rcStickAUX4Slider, axSlider, aySlider, azSlider, gxSlider, gySlider, gzSlider, magxSlider, magySlider, 
magzSlider, altSlider, headSlider, debug1Slider, debug2Slider, debug3Slider, debug4Slider;

//Sensor;
static float rotationX=0, rotationY=0, rotationZ=0;
static float minX=0, maxX=0, minY=0, maxY=0;
static final int horizonInstrSize = 100;
static int i, j;

static float angyLevelControl, angCalc;

static int posX=0, posY=0;

static PFont fontFlone;
static PImage floneImg;
static PImage btImg;

static boolean isConfiguring = true;
static KetaiBluetooth bt;

static int lineY;
static int minlineY;
static int maxlineY;

static int lastBTLoop=0;

static float val, inter, a, b, h;
static final int size = 48;

static final int padding = 8;
static final int halfPadding = 4;
static final int doublePadding = 16;

static int c;
static int k;

static boolean overControl = false;
static boolean arm = false;
//int timeBlink = 500;
static boolean floneConnected = false;

static int[] requests = new int[1];
//ArrayList<String> names;
final int levelBallSize = (width/7)-padding*2;
static final int levelSize = 200;
static float angle;
static float x;

static float lastSend =0;

static final int spaceBar = 48;    

void setup()
{  
  //Garvage collector can kill you
  System.gc();

  String[] fontList = PFont.list();
  println(fontList);
  frameRate(60);

  //fontFlone = loadFont("Soviet-12.vlw");
  fontFlone = createFont("Soviet2.ttf", 20);
  textFont(fontFlone, 30);

  DisplayMetrics dm = new DisplayMetrics();
  getWindowManager().getDefaultDisplay().getMetrics(dm);
  float density = dm.density; 
  int densityDpi = dm.densityDpi;
  println("density is " + density); 
  println("densityDpi is " + densityDpi);

  minX = -1;
  minY = -1;
  maxX = 1;
  maxY = 1;

  minlineY = (height/2) - (width/2);
  maxlineY = (height/2) + (width/2);
  xLevelObj = (width/4)-40;
  yLevelObj = (minlineY/2)-padding*4;
  xRC = 2 * (width/3);

  xCompass = width/2;
  yCompass = (minlineY/2)-padding*4;

  imageMode(CENTER);
  floneImg = loadImage("flonesolo-150.png");
  btImg = loadImage("bluetooth-logo.png");

  cp5 = new ControlP5(this); 
  bt.start();
  bt.discoverDevices();

  int buttonWidth =80;
  int buttonHeight=80;

  cp5.addButton("calibrate")
    .setValue(0)
      .setPosition(20, height-100)
        .setSize(buttonWidth, buttonHeight)
          .captionLabel().setFont(fontFlone);  

  cp5.addToggle("arm")
    .setPosition((width/2)-150, maxlineY+(padding*4))
      .setSize( buttonHeight+100, buttonHeight+50)
        .captionLabel().setFont(fontFlone)
          .align(ControlP5.CENTER, ControlP5.CENTER);

  cp5.addToggle("Rec")
    // .setValue(0)
    .setPosition(60 + buttonWidth*2, height-100)
      .setSize(buttonWidth, buttonHeight)
        .captionLabel().setFont(fontFlone);
  /*
  cp5.addButton("BT_info")
   .setPosition(80 + buttonWidth*3, height-100)
   .setSize(buttonWidth, buttonHeight)
   .captionLabel().setFont(fontFlone);
   
   cp5.addToggle("BT_Connected")
   .setPosition(100 + buttonWidth*4, height-100)
   .setSize(buttonWidth, buttonHeight)
   .captionLabel().setFont(fontFlone);*/

  rcStickThrottleSlider = cp5.addSlider("throttle", minRC, maxRC, medRC, xRC, yRC, (width/3)-padding, 32).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickRollSlider = cp5.addSlider("pitch", minRC, maxRC, medRC, xRC, yRC+(spaceBar), (width/3)-padding, 32).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickPitchSlider = cp5.addSlider("roll", minRC, maxRC, medRC, xRC, yRC+(spaceBar*2), (width/3)-padding, 32).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickYawSlider = cp5.addSlider("yaw", minRC, maxRC, medRC, xRC, yRC+(spaceBar*3), (width/3)-padding, 32).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickAUX1Slider = cp5.addSlider("Aux1", minRC, maxRC, medRC, xRC, yRC+(spaceBar*4), (width/3)-padding, 32).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickAUX2Slider = cp5.addSlider("Aux2", minRC, maxRC, medRC, xRC, yRC+(spaceBar*5), (width/3)-padding, 32).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);

  rcStickThrottleSlider.captionLabel().setFont(fontFlone);
  rcStickRollSlider.captionLabel().setFont(fontFlone);
  rcStickPitchSlider.captionLabel().setFont(fontFlone);
  rcStickYawSlider.captionLabel().setFont(fontFlone);
  rcStickAUX1Slider.captionLabel().setFont(fontFlone);
  rcStickAUX2Slider.captionLabel().setFont(fontFlone);

  rcStickThrottleSlider.valueLabel().setFont(fontFlone);
  rcStickRollSlider.valueLabel().setFont(fontFlone);
  rcStickPitchSlider.valueLabel().setFont(fontFlone);
  rcStickYawSlider.valueLabel().setFont(fontFlone);
  rcStickAUX1Slider.valueLabel().setFont(fontFlone);
  rcStickAUX2Slider.valueLabel().setFont(fontFlone);

  rcStickThrottleSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickRollSlider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickPitchSlider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickYawSlider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickAUX1Slider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickAUX2Slider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);

  orientation(PORTRAIT);
  //textAlign(LEFT, TOP);
  // textSize(36);
  calculateRCValues();
}

void draw()
{
  time = millis();
  fill(0, 0);
  background(0);
  calculateRCValues();

  if (isConnectedtoFlone()) {
    image(btImg, width-50-padding, height-50-padding);
    /*if ((time-time4)>40 ) {
     time4=time;
     accROLL.addVal(ax);accPITCH.addVal(ay);accYAW.addVal(az);gyroROLL.addVal(gx);gyroPITCH.addVal(gy);gyroYAW.addVal(gz);
     magxData.addVal(magx);magyData.addVal(magy);magzData.addVal(magz);
     altData.addVal(alt);headData.addVal(head);
     debug1Data.addVal(debug1);debug2Data.addVal(debug2);debug3Data.addVal(debug3);debug4Data.addVal(debug4);
     }*/
    /*
    if ((time-time2)>40 ) {
     time2=time;
     //int[] requests = {MSP_STATUS, MSP_RAW_IMU, MSP_SERVO, MSP_MOTOR, MSP_RC, MSP_RAW_GPS, MSP_COMP_GPS, MSP_ALTITUDE, MSP_BAT, MSP_DEBUGMSG, MSP_DEBUG};
     requests = new int[1];
     //requests[0] = MSP_STATUS;
     //sendRequestMSP(requestMSP(requests));
     sendRequestMSP(requestMSP(MSP_STATUS));
     }*/

    if ((time-time3)>50) {
      sendRequestMSP(requestMSP(MSP_ATTITUDE));
      time3=time;
    }
  }
  else {
    if ((time - lastBTLoop) > 4000) {  
      bluetoothLoop();
      lastBTLoop = millis();
    }

    if (time % 500 > 250)
      image(btImg, width-50-padding, height-50-padding);
  }
  drawFlyActivity();
  
  //GarbageCollectorMXBean gcBean = ManagementFactory.getGarbageCollectorMXBeans().get(0);
  
  // List<GarbageCollectorMXBean> gcbeans = java.lang.management.ManagementFactory.getGarbageCollectorMXBeans();
  
  //gcBean.getCollectionCount();
  /*
     for (GarbageCollectorMXBean gcBean : ManagementFactory.getGarbageCollectorMXBeans()) {
        System.out.println(gcBean.getCollectionCount());

        com.sun.management.GarbageCollectorMXBean sunGcBean = (com.sun.management.GarbageCollectorMXBean) gcBean;
        System.out.println(sunGcBean.getLastGcInfo().getStartTime());
    }*/
}

void calculateRCValues() {
  if (overControl) { //((mouseY > minlineY) && (mouseY < maxlineY))
    rcThrottle =  int(map(mouseY, minlineY, maxlineY, 2000, 1000));
    rcRoll =  int(map(rotationY, minY, maxY, 1000, 2000));
    rcPitch =  int (map(rotationX, minX, maxX, 2000, 1000));
    rcYaw = int( map(mouseX, 0, width, 1000, 2000));
  }

  //rcRoll = 3000 - rcRoll;
  rcPitch = 3000 - rcPitch;

  //rcThrottle = constrain(rcThrottle, 1000, 2000);
  //rcRoll = constrain(rcRoll, 1000, 2000);
  //rcPitch = constrain(rcPitch, 1000, 2000);
  //rcYaw= constrain(rcYaw, 1000, 2000);
  //rcYaw=rotationZ*100;
}

static List<Character> payload;
void sendRCValues() {
  //payload = new ArrayList<Character>();
  payload = new ArrayList<Character>();

  payload.add((char)( (int) rcPitch & 0xFF)); //strip the 'most significant bit' (MSB) and buffer  
  payload.add((char)( ((int) rcPitch>>8) & 0xFF)); //move the MSB to LSB, strip the MSB and buffer

  payload.add((char)( (int) rcRoll & 0xFF));   
  payload.add((char)( ((int)rcRoll>>8) & 0xFF));   

  payload.add((char)( (int) rcYaw & 0xFF));   
  payload.add((char)( ((int)rcYaw>>8) & 0xFF));   

  payload.add((char)( (int) rcThrottle & 0xFF));   
  payload.add((char)( ((int)rcThrottle>>8) & 0xFF));   

  //aux1 
  payload.add((char)( (int) rcAUX1 & 0xFF));   
  payload.add((char)( ((int)rcAUX1>>8) & 0xFF));   

  //aux2
  payload.add((char)( (int) rcAUX2 & 0xFF));   
  payload.add((char)( ((int)rcAUX2>>8) & 0xFF));   

  //aux3
  payload.add((char)( (int) rcAUX3 & 0xFF));   
  payload.add((char)( ((int)rcAUX3>>8) & 0xFF));   

  //aux4
  payload.add((char)( (int) rcAUX4 & 0xFF));   
  payload.add((char)( ((int)rcAUX4>>8) & 0xFF));   

  sendRequestMSP(requestMSP(MSP_SET_RAW_RC, payload.toArray( new Character[payload.size()]) ));
}

void mousePressed() {
  if (mouseY>minlineY)
    overControl = true;
}

void mouseDragged() {
}

void mouseReleased() {

  if (overControl) {
    if (mouseY>maxlineY)
      rcThrottle = minRC;
    else {
      rcThrottle = medRC;
    }
    rcYaw=medRC;
    rcPitch=medRC;
    rcRoll=medRC;
  }
  overControl = false;
}


public static void arm(boolean theValue) {
  if (theValue)
    rcAUX1 = 2000;
  else
    rcAUX1 = 1000;
}

public void calibrate(int theValue) {
  println("calibrating flone: "+theValue);
  sendRequestMSP(requestMSP(MSP_ACC_CALIBRATION));
}

/*
void onGravityEvent(float x, float y, float z) {
 rotationX = x;
 rotationY = y;
 cycleSensor = millis() - lastCycleSensor;
 lastCycleSensor = millis();
 }
 
 void onMagneticFieldEvent(float x, float y, float z) {
 rotationZ = x;
 }
 */

void onResume()
{ 
  super.onResume();
  initSensor(); // Initialize sensor objects
}

void onPause()
{ 
  super.onPause();
  exitSensor(); // Unregister sensorEventListener
}


/*
public boolean onCreateOptionsMenu(Menu menu) {
 MenuInflater inflater = getMenuInflater();
 inflater.inflate(R.menu.game_menu, menu);
 return true;
 }*/


/*
public static void installGCMonitoring() {
  //get all the GarbageCollectorMXBeans - there's one for each heap generation
  //so probably two - the old generation and young generation
  List<GarbageCollectorMXBean> gcbeans = java.lang.management.ManagementFactory.getGarbageCollectorMXBeans();
  //Install a notifcation handler for each bean
  for (GarbageCollectorMXBean gcbean : gcbeans) {
    System.out.println(gcbean);
    NotificationEmitter emitter = (NotificationEmitter) gcbean;
    //use an anonymously generated listener for this example
    // - proper code should really use a named class
    NotificationListener listener = new NotificationListener() {
      //keep a count of the total time spent in GCs
      long totalGcDuration = 0;

      //implement the notifier callback handler
      @Override
        public void handleNotification(Notification notification, Object handback) {
        //we only handle GARBAGE_COLLECTION_NOTIFICATION notifications here
        if (notification.getType().equals(GarbageCollectionNotificationInfo.GARBAGE_COLLECTION_NOTIFICATION)) {
          //get the information associated with this notification
          GarbageCollectionNotificationInfo info = GarbageCollectionNotificationInfo.from((CompositeData) notification.getUserData());
          //get all the info and pretty print it
          long duration = info.getGcInfo().getDuration();
          String gctype = info.getGcAction();
          if ("end of minor GC".equals(gctype)) {
            gctype = "Young Gen GC";
          } 
          else if ("end of major GC".equals(gctype)) {
            gctype = "Old Gen GC";
          }
          System.out.println();
          System.out.println(gctype + ": - " + info.getGcInfo().getId()+ " " + info.getGcName() + " (from " + info.getGcCause()+") "+duration + " microseconds; start-end times " + info.getGcInfo().getStartTime()+ "-" + info.getGcInfo().getEndTime());
          //System.out.println("GcInfo CompositeType: " + info.getGcInfo().getCompositeType());
          //System.out.println("GcInfo MemoryUsageAfterGc: " + info.getGcInfo().getMemoryUsageAfterGc());
          //System.out.println("GcInfo MemoryUsageBeforeGc: " + info.getGcInfo().getMemoryUsageBeforeGc());

          //Get the information about each memory space, and pretty print it
          Map<String, MemoryUsage> membefore = info.getGcInfo().getMemoryUsageBeforeGc();
          Map<String, MemoryUsage> mem = info.getGcInfo().getMemoryUsageAfterGc();
          for (Entry<String, MemoryUsage> entry : mem.entrySet()) {
            String name = entry.getKey();
            MemoryUsage memdetail = entry.getValue();
            long memInit = memdetail.getInit();
            long memCommitted = memdetail.getCommitted();
            long memMax = memdetail.getMax();
            long memUsed = memdetail.getUsed();
            MemoryUsage before = membefore.get(name);
            long beforepercent = ((before.getUsed()*1000L)/before.getCommitted());
            long percent = ((memUsed*1000L)/before.getCommitted()); //>100% when it gets expanded

              System.out.print(name + (memCommitted==memMax?"(fully expanded)":"(still expandable)") +"used: "+(beforepercent/10)+"."+(beforepercent%10)+"%->"+(percent/10)+"."+(percent%10)+"%("+((memUsed/1048576)+1)+"MB) / ");
          }
          System.out.println();
          totalGcDuration += info.getGcInfo().getDuration();
          long percent = totalGcDuration*1000L/info.getGcInfo().getEndTime();
          System.out.println("GC cumulated overhead "+(percent/10)+"."+(percent%10)+"%");
        }
      }
    };

    //Add the listener
    emitter.addNotificationListener(listener, null, null);
  }
}*/
