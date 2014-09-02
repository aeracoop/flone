package net.aeracoop.flone.remote;

import processing.core.*; 
//import processing.data.*; 
//import processing.event.*; 
//import processing.opengl.*; 

import java.util.List; 
import java.util.LinkedList; 
import java.lang.StringBuffer; 
import controlP5.*; 
import android.util.DisplayMetrics; 
import android.os.Bundle; 
import android.content.BroadcastReceiver; 
import android.content.Context; 
import android.content.IntentFilter; 
import android.content.Intent; 
import android.widget.Toast; 
import android.hardware.Sensor; 
import android.hardware.SensorEvent; 
import android.hardware.SensorEventListener; 
import android.hardware.SensorManager; 
import android.bluetooth.BluetoothAdapter; 
import android.bluetooth.BluetoothDevice; 
import android.bluetooth.BluetoothSocket; 
//import android.R; 
import android.view.inputmethod.InputMethodManager; 
import java.io.IOException; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.lang.reflect.InvocationTargetException; 
import java.lang.reflect.Method; 
//import android.bluetooth.BluetoothAdapter; 
//import android.bluetooth.BluetoothDevice; 
//import android.bluetooth.BluetoothSocket; 
import android.util.Log; 

//import java.util.HashMap; 
//import java.util.ArrayList; 
//import java.io.File; 
//import java.io.BufferedReader; 
//import java.io.PrintWriter; 
//import java.io.InputStream; 
//import java.io.OutputStream; 
//import java.io.IOException; 

public class FloneRemote extends PApplet {

/**
 * Flone, The flying phone
 * By Lot Amoros from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

/*
Mac OSX: Do this in terminal in each Processing update
 ln -s /Library/Java/JavaVirtualMachines/jdk1.7.0_51.jdk/Contents/Home/bin/javac /Applications/Processing.app/Contents/PlugIns/jdk1.7.0_51.jdk/Contents/Home/jre/bin/javac
 */

//For Manage Garvage Collector
//import java.lang.management.GarbageCollectorMXBean;
//import java.lang.management.ManagementFactory;

// P control implementation.
/*
Kp = constant proporcional;// (el que li tocarem nosaltres) 1000 y 2000
 angleMobil;
 angleFlone;
 
 float speedPControl(float angleFlone, float angleMovil, float Kp)
 {
 float error;
 error = angleMovil-angleFlone;
 return(Kp*error);
 }
 
 GirFlone=speedPControl(angleFlone, angleMobil, KP);
 GirFlone = constrain(GirFlone,-500,500); //limitem la eixida
 yaw = 1500 + GirFlone;
 */


//Java


 // for efficient String concatenation
//import java.util.UUID; 
//import java.lang.Object.Looper;

//Processing


//Android
 
//import android.app.Activity;
//import android.app.AlertDialog;





//import android.content.DialogInterface;
//import android.content.DialogInterface.OnClickListener;


//Sensors





//Bluetooth




//static BluetoothAdapter adaptador;
//static BluetoothDevice dispositivo;
//static BluetoothSocket socket;
//static InputStream ins;
//static OutputStream ons;
//boolean registrado = false;

// Sensor objects
static SensorManager mSensorManager;
static SensorEventListener sensorEventListener;
static Sensor accelerometer;
static Sensor magnetometer;
static Sensor gravity;

// Bluetooth manager
static TBlue tBlue; 

static boolean sensorAvailable = false;

static float azimuth       = 0.0f;
static float pitch         = 0.0f;
static float roll          = 0.0f;

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
//static int xCompass    = 100;        
//static int yCompass    = 8; //760,336
static int xLevelObj   = 0;//int(width/2);        
static int yLevelObj   = 0; //760,80
static final int xParam      = 120;        
static final int yParam      = 5;
static int xRC         = 690;        
static int yRC         = 4; //850,10
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

static int version, versionMisMatch;
static float gx, gy, gz, ax, ay, az, magx, magy, magz, alt, head, angx, angy, debug1, debug2, debug3, debug4;
static int GPS_distanceToHome, GPS_directionToHome, 
GPS_numSat, GPS_fix, GPS_update, GPS_altitude, GPS_speed, 
GPS_latitude, GPS_longitude, 
init_com, graph_on, pMeterSum, intPowerTrigger, bytevbat;

static float mot[] = new float[8];
static final int minRC = 1000, maxRC = 2000, medRC = 1500;

static int servo[] = new int[8], 
rcThrottle = minRC, rcRoll = medRC, rcPitch = medRC, rcYaw =medRC, 
rcAUX1=minRC, rcAUX2=minRC, rcAUX3=minRC, rcAUX4=minRC;

static int cycleTime, i2cError;    

static int  byteRC_RATE, byteRC_EXPO, byteRollPitchRate, byteYawRate, byteDynThrPID, byteThrottle_EXPO, byteThrottle_MID;

static final int byteMP[] = new int[8];  // Motor Pins.  Varies by multiType and Arduino model (pro Mini, Mega, etc).

//private static final int ROLL = 0, PITCH = 1, YAW = 2, ALT = 3, VEL = 4, LEVEL = 5, MAG = 6;

//MultiwiiGUI
static ControlP5 cp5;
final int col = color(255);

Slider rcStickThrottleSlider, rcStickRollSlider, rcStickPitchSlider, rcStickYawSlider, rcStickAUX1Slider, rcStickAUX2Slider, 
rcStickAUX3Slider, rcStickAUX4Slider, axSlider, aySlider, azSlider, gxSlider, gySlider, gzSlider, magxSlider, magySlider, 
magzSlider, altSlider, headSlider, debug1Slider, debug2Slider, debug3Slider, debug4Slider;

Toggle armToggle;

//Sensor;
static float rotationX=0, rotationY=0, rotationZ=0;
static float minX=0, maxX=0, minY=0, maxY=0;
static int horizonInstrSize = 100;
static int i, j;

static float angyLevelControl, angCalc;

static int posX=0, posY=0;

//Images
static PFont fontFlone;
static PImage floneImg;
static PImage btImg;
static PImage btNoImg;
static PImage compassImg;
static PImage mobileImg;
//static PImage satImg;
//static PImage batImg;

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
//static boolean floneConnected = false;

static int[] requests = new int[1];
final int levelBallSize = (width/7)-padding*3;
static int levelSize = 200;
static float angle;
static float x;

static float lastSend =0;
int spaceBar = 32;

private static RadioButton flightMode;
private static Knob batKnob;
private static Knob satKnob;
//private static Knob btKnob;

private static String floneId;
private static Button txtId;

private static Textlabel btName;

float density = 2; 
int densityDpi = 320;

int buttonWidth = PApplet.parseInt(44* 2);
int buttonHeight = PApplet.parseInt (28 * 2);


public void setup()
{  
  //Garbage collector can kill your drone
  System.gc();
  floneId = "flone1";

  String[] fontList = PFont.list();
  println(fontList);
  frameRate(15);

  //fontFlone = loadFont("Soviet-12.vlw");
  fontFlone = createFont("Soviet2.ttf", 20);


  DisplayMetrics dm = new DisplayMetrics();
  getWindowManager().getDefaultDisplay().getMetrics(dm);
  density = dm.density; 
  densityDpi = dm.densityDpi;
  println("Density of screen is " + density +" densityDpi is " + densityDpi);
  textFont(fontFlone, PApplet.parseInt(10*density));
  spaceBar = PApplet.parseInt(15*density);
  levelSize = PApplet.parseInt(78 * density); 
  horizonInstrSize = PApplet.parseInt(45* density);
  buttonWidth =PApplet.parseInt(44* density);
  buttonHeight=PApplet.parseInt (28 * density);


  minX = -1;
  minY = -1;
  maxX = 1;
  maxY = 1;

  minlineY = (height/2) - (width/2);
  maxlineY = (height/2) + (width/2);

  xLevelObj = (width/2);
  //yLevelObj = (minlineY/2)-padding*4;
  yLevelObj = (minlineY/2)+PApplet.parseInt(10*density);

  xRC = 2*(width/3)+PApplet.parseInt(14*density);

  //xCompass = width/2;
  //yCompass = (minlineY/2)-padding*4;

  imageMode(CENTER);
  floneImg = loadImage("airframe.png");
  btImg = loadImage("bluetooth-logo.png");
  btNoImg = loadImage("bluetooth-logo-no.png");

  compassImg = loadImage("windrose.png");
  //mobileImg = loadImage("windrose-mobile.png");
  //satImg = loadImage("satelite.png");
  //batImg = loadImage("battery.png");


  cp5 = new ControlP5(this); 
  cp5.setFont(fontFlone);


  armToggle = new Toggle(cp5, "arm");
  armToggle.setMode(ControlP5.SWITCH)
    //.setColor(100)
    .setColorActive(color(0, 240, 0))
      .setColorForeground(color(120, 120, 120))
        .setColorBackground(color(30, 30, 30))
          .setPosition(padding, padding)
            .setSize( (width/3)-padding * 4, height/16)
              .setCaptionLabel("disarmed")
                .setColorCaptionLabel(color(255, 255, 255))
                  .captionLabel().setFont(fontFlone)
                    .setSize(PApplet.parseInt(20*density))
                      .align(ControlP5.CENTER, ControlP5.CENTER);


  flightMode = cp5.addRadioButton("flightMode")
    .setPosition(padding*2, padding*2 + (height/16))
      .setSize((width/8)-padding * 2, height/30)
        .setColorForeground(color(20, 200, 20))
          //.setColorActive(color(10, 2, 200))
          .setColorLabel(color(255))
            .setItemsPerRow(1)
              .setSpacingRow(PApplet.parseInt(6*density))
                .addItem("Stabilized", 1)
                  .addItem("Alt Hold", 2)
                    .addItem("Loiter", 3)
                      ;

  flightMode.getItem(0).captionLabel().setColorBackground(color(255, 80, 80));
  flightMode.getItem(1).captionLabel().setColorBackground(color(55, 200, 80));
  flightMode.getItem(2).captionLabel().setColorBackground(color(55, 80, 255));

  for (Toggle t : flightMode.getItems ()) {
    t.captionLabel().setFont(fontFlone);    
    t.captionLabel().setSize(PApplet.parseInt(12*density));
    /*      
     t.captionLabel().style().moveMargin(-7, 0, 0, -3);
     t.captionLabel().style().movePadding(7, 0, 0, 3);*/
    t.captionLabel().style().backgroundWidth = (width/6)+padding;
  }
  flightMode.activate(0);

  txtId = cp5.addButton("floneId")
    .setPosition((width/8)+20, height-padding-buttonHeight-(10*density))
      .setSize((width/3)-10, buttonHeight)
        .setCaptionLabel(floneId)
          //.captionLabel()
          //.setSize(28)
          ;

  cp5.addButton("connect")
    //        s.setValue(0)
    .setPosition((width/2)+10, height-padding-buttonHeight-(10*density))
      .setSize(buttonWidth, buttonHeight)
        .captionLabel().setFont(fontFlone);  

  /*  cp5.addToggle("action")
   // .setValue(0)
   .setPosition(padding*2, height-100)
   .setSize(buttonWidth, buttonHeight)
   .captionLabel().setFont(fontFlone);*/

  batKnob = cp5.addKnob("battery")
    .setRange(9, 13)
      //.setValue(0)
      .setPosition(width-PApplet.parseInt(100*density), height-padding-PApplet.parseInt(48*density))
        .setRadius(PApplet.parseInt(16*density))
          .setDragDirection(Knob.VERTICAL)
            // .valueLabel()
            //             .setFont(fontFlone)
            //    .setSize(20)
            ;

  btName = cp5.addTextlabel("btName")
    .setText("bt Name:")
      .setPosition(padding, height-doublePadding-PApplet.parseInt(buttonHeight/2)-(10*density))
        .setFont(fontFlone)  
          ;


  /* satKnob = cp5.addKnob("satellites")
   .setRange(0, 20)
   .setNumberOfTickMarks(20)
   //.setValue(0)
   .setPosition(width-180, height-90)
   .setRadius(int(16*density))
   .setDragDirection(Knob.VERTICAL)
   // .captionLabel().setSize(20)
   //.setFont(fontFlone);
   ;*/

  //28
  int rxButonHeight = ((height-(width/2))/2)/16;
  int rxButonWidth = (width/3)-PApplet.parseInt(14*density);

  rcStickThrottleSlider = cp5.addSlider("throttle", minRC, maxRC, medRC, xRC, yRC, rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickRollSlider = cp5.addSlider("pitch", minRC, maxRC, medRC, xRC, yRC+(spaceBar), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickPitchSlider = cp5.addSlider("roll", minRC, maxRC, medRC, xRC, yRC+(spaceBar*2), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickYawSlider = cp5.addSlider("yaw", minRC, maxRC, medRC, xRC, yRC+(spaceBar*3), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickAUX1Slider = cp5.addSlider("Aux 1", minRC, maxRC, medRC, xRC, yRC+(spaceBar*4), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickAUX2Slider = cp5.addSlider("Aux 2", minRC, maxRC, medRC, xRC, yRC+(spaceBar*5), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickAUX3Slider = cp5.addSlider("Aux 3", minRC, maxRC, medRC, xRC, yRC+(spaceBar*6), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickAUX4Slider = cp5.addSlider("Aux 4", minRC, maxRC, medRC, xRC, yRC+(spaceBar*7), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);


  rcStickThrottleSlider.captionLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickRollSlider.captionLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickPitchSlider.captionLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickYawSlider.captionLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickAUX1Slider.captionLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickAUX2Slider.captionLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickAUX3Slider.captionLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickAUX4Slider.captionLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));


  rcStickThrottleSlider.valueLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickRollSlider.valueLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickPitchSlider.valueLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickYawSlider.valueLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickAUX1Slider.valueLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickAUX2Slider.valueLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickAUX3Slider.valueLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));
  rcStickAUX4Slider.valueLabel().setFont(fontFlone).setSize(PApplet.parseInt(8*density));

  rcStickThrottleSlider.getCaptionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickRollSlider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickPitchSlider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickYawSlider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickAUX1Slider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickAUX2Slider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickAUX3Slider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);
  rcStickAUX4Slider.captionLabel().align(ControlP5.RIGHT, ControlP5.CENTER).setPaddingX(10);

  orientation(PORTRAIT);
  //Looper.prepare();
  //getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
  maxCycle =0;
}

public void draw()
{  
  time = millis();
  fill(0, 0);
  background(0);
  calculateRCValues();
  if (btConnected()==true) {
    tBlue.read();
    image(btImg, width-50-padding, height-50-padding, 50*density, 50*density);
    /*if ((time-time4)>40 ) {
     time4=time;
     accROLL.addVal(ax);accPITCH.addVal(ay);accYAW.addVal(az);gyroROLL.addVal(gx);gyroPITCH.addVal(gy);gyroYAW.addVal(gz);
     magxData.addVal(magx);magyData.addVal(magy);magzData.addVal(magz);
     altData.addVal(alt);headData.addVal(head);
     debug1Data.addVal(debug1);debug2Data.addVal(debug2);debug3Data.addVal(debug3);debug4Data.addVal(debug4);
     }*/

    if ((time-time2)>1000 ) {
      time2=time;
      //int[] requests = {MSP_STATUS, MSP_RAW_IMU, MSP_SERVO, MSP_MOTOR, MSP_RC, MSP_RAW_GPS, MSP_COMP_GPS, MSP_ALTITUDE, MSP_BAT, MSP_DEBUGMSG, MSP_DEBUG};
      //requests = new int[1];
      int[] requests = {
        MSP_STATUS, MSP_BAT
      };
      //requests[0] = MSP_STATUS;
      sendRequestMSP(requestMSP(requests));
      //sendRequestMSP(requestMSP(MSP_STATUS));
    }

    if ((time-time3)>200) {
      sendRequestMSP(requestMSP(MSP_ATTITUDE));
      time3=time;
    }
  } else {
    if ((time - lastBTLoop) > 5000) {  //Try to connect each 3 seconds
      //bluetoothLoop(); 
      lastBTLoop = millis();
    }
  }
  drawFlyActivity();

  //GarbageCollectorMXBean gcBean = ManagementFactory.getGarbageCollectorMXBeans().get(0);
  // List<GarbageCollectorMXBean> gcbeans = java.lang.management.ManagementFactory.getGarbageCollectorMXBeans();
  //gcBean.getCollectionCount();
  /*for (GarbageCollectorMXBean gcBean : ManagementFactory.getGarbageCollectorMXBeans()) {
   System.out.println(gcBean.getCollectionCount());
   
   com.sun.management.GarbageCollectorMXBean sunGcBean = (com.sun.management.GarbageCollectorMXBean) gcBean;
   System.out.println(sunGcBean.getLastGcInfo().getStartTime());}*/
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
 */
/**
 * Flone, The flying phone
 * By Lot Amor\u00f3s from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

/* Android Status
 
 1. onCreate
 2. onStart
 3. onResume
 
 3.1 onPause
 3.2 onResume
 
 4. onStop
 4.1 onRestart
 4.2 onStart
 4.3 onResume
 
 5. onDestroy()
 */

public void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  IntentFilter filter1 = new IntentFilter(BluetoothDevice.ACTION_ACL_CONNECTED);
  IntentFilter filter2 = new IntentFilter(BluetoothDevice.ACTION_ACL_DISCONNECT_REQUESTED);
  IntentFilter filter3 = new IntentFilter(BluetoothDevice.ACTION_ACL_DISCONNECTED);
  this.registerReceiver(BTReceiver, filter1);
  this.registerReceiver(BTReceiver, filter2);
  this.registerReceiver(BTReceiver, filter3);
}

public void onActivityResult (int requestCode, int resultCode, Intent data) {
  if (resultCode == RESULT_OK) {
    tBlue.connect();
  }
  else {
    println("No se ha activado el bluetooth");
  }
}

public void onStart() {
  super.onStart();
  println("onStart");
  //comprobar adaptador bluetooth conectado
  initSensor();
  tBlue = new TBlue();
}

public void onStop() {
  exitSensor();
  if (tBlue!= null)
    tBlue.close();
  super.onStop();
}

public void onResume()
{ 
  super.onResume();
  //initSensor(); // Initialize sensor objects
}

public void onPause()
{ 
  super.onPause();
  //exitSensor(); // Unregister sensorEventListener
}

public void onDestroy()
{
  this.unregisterReceiver(BTReceiver);
}

/**
 * Flone, The flying phone
 * By Lot Amor\u00f3s from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//Bluetooth.pde

public void bluetoothLoop() {
  try {    
    if (!tBlue.streaming()) {
      tBlue.connect();
    }
  }
  catch (NullPointerException ex) {
    println("Bluetooth Warning: Can not connect");
  }
}

public boolean btConnected() {  
  //floneConnected = socket.isConnected();
  boolean btConnected = false;
  try {
    btConnected = tBlue.streaming();
  }
  catch(Exception ex) {
    btConnected = false;
  }     
  return btConnected;
}

//The BroadcastReceiver that listens for bluetooth broadcasts
private final BroadcastReceiver BTReceiver = new BroadcastReceiver() {
  @Override
    public void onReceive(Context context, Intent intent) {
    String action = intent.getAction();

    if (BluetoothDevice.ACTION_ACL_CONNECTED.equals(action)) {
      //Do something if connected
      Toast.makeText(getApplicationContext(), "flone connected", Toast.LENGTH_SHORT).show();
      println("flone connected");
      // floneConnected = true;
    }
    else if (BluetoothDevice.ACTION_ACL_DISCONNECTED.equals(action)) {
      //Do something if disconnected
      Toast.makeText(getApplicationContext(), "flone disconnected", Toast.LENGTH_SHORT).show();
      println("flone disconnnected");
      //floneConnected = false;
      try {
        tBlue.close();
        
      }
      catch (Exception e) {
        println("No se ha podido cerrar el socket" + e);
      }
    }
    else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action)) {
      //Done searching
      println("Bluetooth discovery finished.");
    }
    else if (BluetoothDevice.ACTION_FOUND.equals(action)) {
      //Device found
      println("Found Bluetooth device.");
    }
  }
};

/**
 * Flone, The flying phone
 * By Lot Amor\u00f3s from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//Main Fly Activity
static String txtString;
static int millis=0;
static int maxCycle =0;
static float vBat = 0.0f;
int cBat = color(255, 0, 0);

//int flyPannelx = width/2;
//int flyPannely = (height-(width/2))/4;//(minlineY/2)+20;
//int flyPannelx = xLevelObj;
//int flyPannely = yLevelObj;

int flypannelSize = height/2 - width/2;

public void drawFlyActivity() {
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
public void drawPitchRoll() {
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
  strokeWeight(1.5f);
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
  strokeWeight(1.5f);
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

  txt=new StringBuffer().append(angy).append(" \u00ba");
  txtString = txt.toString();

  // txt = (int)angy + "\u00b0";
  text(txtString, xLevelObj+(levelBallSize/2), yLevelObj+padding); //pitch
  //txt = (int)angx + "\u00b0";

  txt=new StringBuffer().append((int)angx).append(" \u00ba");
  txtString = txt.toString();
  text(txtString, xLevelObj-(levelBallSize/2), yLevelObj+padding); //roll
}

// ---------------------------------------------------------------------------------------------
// Magnetron Combi Fly Level Control
// ---------------------------------------------------------------------------------------------
StringBuffer txt = new StringBuffer();
public void drawFlyLevel() {
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
public void drawCompass() {
  // ---------------------------------------------------------------------------------------------
  // Compass Section
  // ---------------------------------------------------------------------------------------------
  pushMatrix();
  //translate(xCompass, yCompass);
  noFill();
  //stroke(255);
  // rect(xLevelObj-30, 8, 60, 48, 10);
  //line(xLevelObj, 50, xLevelObj, 70);
  floneAngle = PApplet.parseInt(head<0 ? abs(head) : abs(head-360));
  txt=new StringBuffer().append(floneAngle).append(" \u00ba");
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

public void drawPilotSurface() {
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
  phoneAngle = PApplet.parseInt(azimuth<0 ? abs(360+azimuth) : abs(azimuth));
  txt=new StringBuffer().append(phoneAngle).append(" \u00ba");
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

public void drawMeta() {
  txt = new StringBuffer().append(PApplet.parseInt(frameRate)).append("fps/Cycle:").append(cycle).append("ms/MaxCycle:").append(maxCycle).append("ms");
  txtString = txt.toString();
  text(txtString, padding, ((height/2) + (width/2))+padding);

  txt = new StringBuffer("Mag:").append(cycleMag).append("ms/Acc:").append(cycleAcc);
  txtString = txt.toString();
  text(txtString, (width/2)+80, ((height/2)+(width/2))+padding);
}

public void drawState() {
 // text("BT Name:", 0, height-padding-buttonHeight);
}

public void drawBat() {
  //  image(batImg, (width/2)-70, height-50-padding,50*density,50*density);
  /*txt = new StringBuffer("10.1 V");
   txtString = txt.toString();
   text(txtString, (width/2)+50, height-50);*/

  vBat = bytevbat/10.0f;
  if (vBat < 9.9f )
    cBat = color(220, 0, 0);
  else
    if (vBat < 10.7f) 
    cBat = color(220, 220, 50);
  else
    cBat = color(10, 220, 10);
}

public void drawSat() {
  //image(satImg, (width/2)+110, height-50-padding, 50*density,50*density );
  /*txt = new StringBuffer("8");
   txtString = txt.toString();
   text(txtString, (width/2)+200, height-50);*/
}


public void drawBTState() {
  if (btConnected() == true)
    image(btImg, width-padding-PApplet.parseInt(25*density), height-padding-PApplet.parseInt(25*density), 50*density, 50*density);
  else
    image(btNoImg, width-padding-PApplet.parseInt(25*density), height-padding-PApplet.parseInt(25*density), 50*density, 50*density);
}


public void updateSliders() {
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
 //txt = head + "\u00b0"; 
 txt=new StringBuffer("head:").append(head).append('\u00ba');
 txtString = txt.toString();
 text(txtString, xCompass-11-(head>=10.0 ? (head>=100.0 ? 6 : 3) : 
 0), yCompass+6);
 // GPS direction indicator
 fill(255, 255, 0);
 //txt = GPS_directionToHome + "\u00b0";
 txt=new StringBuffer("GPS_directionToHome").append('\u00ba');
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

/**
 * Flone, The flying phone
 * By Lot Amor\u00f3s from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */
 
 //Multiwii Serial Protocol


/******************************* Multiwii Serial Protocol **********************/

private static final String MSP_HEADER = "$M<";
private static final byte[] MSP_HEADER_BYTE = MSP_HEADER.getBytes();
private static final int headerLength = MSP_HEADER_BYTE.length;

private static final int
MSP_IDENT                =100, 
MSP_STATUS               =101, 
MSP_RAW_IMU              =102, 
MSP_SERVO                =103, 
MSP_MOTOR                =104, 
MSP_RC                   =105, 
MSP_RAW_GPS              =106, 
MSP_COMP_GPS             =107, 
MSP_ATTITUDE             =108, 
MSP_ALTITUDE             =109, 
MSP_BAT                  =110, 
MSP_RC_TUNING            =111, 
MSP_PID                  =112, 
MSP_BOX                  =113, 
MSP_MISC                 =114, 
MSP_MOTOR_PINS           =115, 
MSP_BOXNAMES             =116, 
MSP_PIDNAMES             =117, 

MSP_SET_RAW_RC           =200, 
MSP_SET_RAW_GPS          =201, 
MSP_SET_PID              =202, 
MSP_SET_BOX              =203, 
MSP_SET_RC_TUNING        =204, 
MSP_ACC_CALIBRATION      =205, 
MSP_MAG_CALIBRATION      =206, 
MSP_SET_MISC             =207, 
MSP_RESET_CONF           =208, 
MSP_SELECT_SETTING       =210, 

MSP_BIND                 =240, 

MSP_EEPROM_WRITE         =250, 

MSP_DEBUGMSG             =253, 
MSP_DEBUG                =254
;

public static final int
IDLE = 0, 
HEADER_START = 1, 
HEADER_M = 2, 
HEADER_ARROW = 3, 
HEADER_SIZE = 4, 
HEADER_CMD = 5, 
HEADER_ERR = 6
;

static int c_state = IDLE;
static boolean err_rcvd = false;

static byte checksum=0;
static byte cmd;
static int offset=0, dataSize=0;
static byte[] inBuf = new byte[256];

static int p;
public static int read32() {
  return (inBuf[p++]&0xff) + ((inBuf[p++]&0xff)<<8) + ((inBuf[p++]&0xff)<<16) + ((inBuf[p++]&0xff)<<24);
}
public static int read16() {
  return (inBuf[p++]&0xff) + ((inBuf[p++])<<8);
}
public static int read8() {
  return inBuf[p++]&0xff;
}

static int mode;
static int multiCapability;

//send msp without payload
private List<Byte> requestMSP(int msp) {
  return  requestMSP( msp, null);
}

/*private int[]<Byte> requestMSP (int[] msps) {
 //  s1 = new LinkedList<Byte>();
 mspSize = msps.length;
 for (kList=0;kList<mspSize;kList++) {
 s1.addAll(requestMSP(msps[kList], null));
 }
 return s1;
 }*/

//send multiple msp without payload
static  List<Byte>  s1 = new LinkedList<Byte>();
static int mspSize=0;
private static int kList =0; 
private List<Byte> requestMSP (int[] msps) {
  s1 = new LinkedList<Byte>();
  mspSize = msps.length;
  for (kList=0;kList<mspSize;kList++) {
    s1.addAll(requestMSP(msps[kList], null));
  }
  return s1;
}

//send msp with payload
private List<Byte> requestMSP (int msp, Character[] payload) {
List<Byte>bf = new LinkedList<Byte>();
int cList=0;
byte checksumMSP=0;
byte pl_size=0;
int cMSP=0;
int payloadLength = 0;  
 
  if (msp < 0) { 
    return null;
  }
  bf = new LinkedList<Byte>();  
  for (cList=0;cList<headerLength;cList++) {
    bf.add( MSP_HEADER_BYTE[cList] );
  }

  checksumMSP=0;
  pl_size = (byte)((payload != null ? PApplet.parseInt(payload.length) : 0)&0xFF);
  bf.add(pl_size);
  checksumMSP ^= (pl_size&0xFF);

  bf.add((byte)(msp & 0xFF));
  checksumMSP ^= (msp&0xFF);

  if (payload != null) {
    payloadLength = payload.length;
    for (cMSP=0;cMSP<payloadLength;cMSP++) {
      bf.add((byte)(payload[cMSP]&0xFF));
      checksumMSP ^= (payload[cMSP]&0xFF);
    }
  }
  bf.add(checksumMSP);
  return (bf);
}

//send msp with payload
private static byte[] RCToSend = new byte[22];
private static int RList=0;
private static int RCount=0;
private static byte checksumRC=0;
private static byte pl_sizeRC=0;
private static int payloadLengthRC=0;
private static int cRC=0;
private byte[] requestMSPRC ( ) {
  RCount=0;
  for (RList=0;RList<headerLength;RList++) {
    RCToSend[RCount++] = MSP_HEADER_BYTE[RList] ;
  }

  pl_sizeRC = (byte)((payloadChar != null ? PApplet.parseInt(payloadChar.length) : 0)&0xFF);
  RCToSend[RCount++] = pl_sizeRC;
  checksumRC ^= (pl_sizeRC&0xFF);

  RCToSend[RCount++] =(byte)(MSP_SET_RAW_RC & 0xFF);
  checksumRC ^= (MSP_SET_RAW_RC&0xFF);

  if (payloadChar != null) {
    payloadLengthRC = payloadChar.length;
    for (cRC=0;cRC<payloadLengthRC;cRC++) {
      RCToSend[RCount++] = (byte)(payloadChar[cRC]&0xFF);
      checksumRC ^= (payloadChar[cRC]&0xFF);
    }
  }
  RCToSend[RCount++] = checksumRC;
  return (RCToSend);
}

static private byte[] arr;
static private int irmsp =0;
static private int mspLenght = 0;
static private int bRMSP=0;
public void sendRequestMSP(List<Byte> msp) {
  //Outside
  irmsp =0;
  bRMSP=0;

  try {
    mspLenght = msp.size();
    arr = new byte[mspLenght];
    for (bRMSP=0;bRMSP<mspLenght;bRMSP++) {
      arr[irmsp++] = msp.get(bRMSP);
    }
    tBlue.write(arr);
  }
  catch(NullPointerException ex) {
    println("Warning: Packet not sended.");
  }
}

public void parseMSPMessage(byte[] data, int dataLength)
{
  for (k=0;k<dataLength;k++) {
    c = PApplet.parseChar(data[k]);

    if (c_state == IDLE) {
      c_state = (c=='$') ? HEADER_START : IDLE;
    } 
    else if (c_state == HEADER_START) {
      c_state = (c=='M') ? HEADER_M : IDLE;
    } 
    else if (c_state == HEADER_M) {
      if (c == '>') {
        c_state = HEADER_ARROW;
      } 
      else if (c == '!') {
        c_state = HEADER_ERR;
      } 
      else {
        c_state = IDLE;
      }
    } 
    else if (c_state == HEADER_ARROW || c_state == HEADER_ERR) {
      // is this an error message? 
      err_rcvd = (c_state == HEADER_ERR);        // now we are expecting the payload size 
      dataSize = (c&0xFF);
      // reset index variables 
      p = 0;
      offset = 0;
      checksum = 0;
      checksum ^= (c&0xFF);
      // the command is to follow 
      c_state = HEADER_SIZE;
    } 
    else if (c_state == HEADER_SIZE) {
      cmd = (byte)(c&0xFF);
      checksum ^= (c&0xFF);
      c_state = HEADER_CMD;
    } 
    else if (c_state == HEADER_CMD && offset < dataSize) {
      checksum ^= (c&0xFF);
      inBuf[offset++] = (byte)(c&0xFF);
    } 
    else if (c_state == HEADER_CMD && offset >= dataSize) {
      // compare calculated and transferred checksum 
      if ((checksum&0xFF) == (c&0xFF)) {
        if (err_rcvd) {
          System.err.println("Copter did not understand request type "+c);
        } 
        else {
          // we got a valid response packet, evaluate it 
          evaluateCommand(cmd, (int)dataSize);
        }
      } 
      else {
        System.out.println("invalid checksum for command "+((int)(cmd&0xFF))+": "+(checksum&0xFF)+" expected, got "+(int)(c&0xFF));
        System.out.print("<"+(cmd&0xFF)+" "+(dataSize&0xFF)+"> {");
        for (i=0; i<dataSize; i++) {
          if (i!=0) { 
            System.err.print(' ');
          }
          System.out.print((inBuf[i] & 0xFF));
        }
        System.out.println("} ["+c+"]");
        System.out.println(new String(inBuf, 0, dataSize));
      }
      c_state = IDLE;
    }
  }
}


public void evaluateCommand(byte cmd, int dataSize) {
  int icmd = (int)(cmd&0xFF);
  switch(icmd) {
  case MSP_IDENT:
    version = read8();
    multiType = read8();
    read8(); // MSP version
    multiCapability = read32();// capability
    println("IDent:");        
    println(version);
    println(multiType);
    println(multiCapability);
    break;
  case MSP_STATUS:
    cycleTime = read16();
    i2cError = read16();
    present = read16();
    mode = read32();
    /*if ((present&1) >0) {buttonAcc.setColorBackground(green_);} else {buttonAcc.setColorBackground(red_);tACC_ROLL.setState(false); tACC_PITCH.setState(false); tACC_Z.setState(false);}
     if ((present&2) >0) {buttonBaro.setColorBackground(green_);} else {buttonBaro.setColorBackground(red_); tBARO.setState(false); }
     if ((present&4) >0) {buttonMag.setColorBackground(green_);} else {buttonMag.setColorBackground(red_); tMAGX.setState(false); tMAGY.setState(false); tMAGZ.setState(false); }
     if ((present&8) >0) {buttonGPS.setColorBackground(green_);} else {buttonGPS.setColorBackground(red_); tHEAD.setState(false);}
     if ((present&16)>0) {buttonSonar.setColorBackground(green_);} else {buttonSonar.setColorBackground(red_);}
     for(i=0;i<CHECKBOXITEMS;i++) {
     if ((mode&(1<<i))>0) buttonCheckbox[i].setColorBackground(green_); else buttonCheckbox[i].setColorBackground(red_);
     }*/
    read8();
    //confSetting.setValue(read8());
    //confSetting.setColorBackground(green_);
    break;
  case MSP_RAW_IMU:
    ax = read16();
    ay = read16();
    az = read16();
    gx = read16()/8;
    gy = read16()/8;
    gz = read16()/8;
    magx = read16()/3;
    magy = read16()/3;
    magz = read16()/3; 
    break;
  case MSP_SERVO:
    for (i=0;i<8;i++) servo[i] = read16(); 
    break;
  case MSP_MOTOR:
    for (i=0;i<8;i++) mot[i] = read16(); 
    break;
  case MSP_RC:
    rcRoll = read16();
    rcPitch = read16();
    rcYaw = read16();
    rcThrottle = read16();    
    rcAUX1 = read16();
    rcAUX2 = read16();
    rcAUX3 = read16();
    rcAUX4 = read16(); 
    break;
  case MSP_RAW_GPS:
    GPS_fix = read8();
    GPS_numSat = read8();
    GPS_latitude = read32();
    GPS_longitude = read32();
    GPS_altitude = read16();
    GPS_speed = read16(); 
    break;
  case MSP_COMP_GPS:
    GPS_distanceToHome = read16();
    GPS_directionToHome = read16();
    GPS_update = read8(); 
    break;
  case MSP_ATTITUDE:
    angx = read16()/10;
    angy = read16()/10;
    head = read16(); 
    break;
  case MSP_ALTITUDE:
    alt = read32(); 
    break;
  case MSP_BAT:
    bytevbat = read8();
    pMeterSum = read16();
    
    break;
    /*case MSP_RC_TUNING:
     byteRC_RATE = read8();byteRC_EXPO = read8();byteRollPitchRate = read8();
     byteYawRate = read8();byteDynThrPID = read8();
     byteThrottle_MID = read8();byteThrottle_EXPO = read8();
     confRC_RATE.setValue(byteRC_RATE/100.0);
     confRC_EXPO.setValue(byteRC_EXPO/100.0);
     rollPitchRate.setValue(byteRollPitchRate/100.0);
     yawRate.setValue(byteYawRate/100.0);
     dynamic_THR_PID.setValue(byteDynThrPID/100.0);
     throttle_MID.setValue(byteThrottle_MID/100.0);
     throttle_EXPO.setValue(byteThrottle_EXPO/100.0);
     confRC_RATE.setColorBackground(green_);confRC_EXPO.setColorBackground(green_);rollPitchRate.setColorBackground(green_);
     yawRate.setColorBackground(green_);dynamic_THR_PID.setColorBackground(green_);
     throttle_MID.setColorBackground(green_);throttle_EXPO.setColorBackground(green_);
     updateModelMSP_SET_RC_TUNING();
     break;*/
  case MSP_ACC_CALIBRATION:
    break;
  case MSP_MAG_CALIBRATION:
    break;
    /*case MSP_PID:
     for(i=0;i<PIDITEMS;i++) {
     byteP[i] = read8();byteI[i] = read8();byteD[i] = read8();
     switch (i) {
     case 0: 
     confP[i].setValue(byteP[i]/10.0);confI[i].setValue(byteI[i]/1000.0);confD[i].setValue(byteD[i]);
     break;
     case 1:
     confP[i].setValue(byteP[i]/10.0);confI[i].setValue(byteI[i]/1000.0);confD[i].setValue(byteD[i]);
     break;
     case 2:
     confP[i].setValue(byteP[i]/10.0);confI[i].setValue(byteI[i]/1000.0);confD[i].setValue(byteD[i]);
     break;
     case 3:
     confP[i].setValue(byteP[i]/10.0);confI[i].setValue(byteI[i]/1000.0);confD[i].setValue(byteD[i]);
     break;
     case 7:
     confP[i].setValue(byteP[i]/10.0);confI[i].setValue(byteI[i]/1000.0);confD[i].setValue(byteD[i]);
     break;
     case 8:
     confP[i].setValue(byteP[i]/10.0);confI[i].setValue(byteI[i]/1000.0);confD[i].setValue(byteD[i]);
     break;
     case 9:
     confP[i].setValue(byteP[i]/10.0);confI[i].setValue(byteI[i]/1000.0);confD[i].setValue(byteD[i]);
     break;
     //Different rates fot POS-4 POSR-5 NAVR-6
     case 4:
     confP[i].setValue(byteP[i]/100.0);confI[i].setValue(byteI[i]/100.0);confD[i].setValue(byteD[i]/1000.0);
     break;
     case 5:
     confP[i].setValue(byteP[i]/10.0);confI[i].setValue(byteI[i]/100.0);confD[i].setValue(byteD[i]/1000.0);
     break;                   
     case 6:
     confP[i].setValue(byteP[i]/10.0);confI[i].setValue(byteI[i]/100.0);confD[i].setValue(byteD[i]/1000.0);
     break;                   
     }
     confP[i].setColorBackground(green_);
     confI[i].setColorBackground(green_);
     confD[i].setColorBackground(green_);
     }
     updateModelMSP_SET_PID();
     break;*/

    /*case MSP_MISC:
     intPowerTrigger = read16();
     confPowerTrigger.setValue(intPowerTrigger);
     updateModelMSP_SET_MISC();
     break;*/
  case MSP_MOTOR_PINS:
    for ( i=0;i<8;i++) {
      byteMP[i] = read8();
    } 
    break;
  case MSP_DEBUGMSG:
    while (dataSize-- > 0) {
      char c = (char)read8();
      if (c != 0) {
        System.out.print( c );
      }
    }
    break;
  case MSP_DEBUG:
    debug1 = read16();
    debug2 = read16();
    debug3 = read16();
    debug4 = read16(); 
    break;
  case MSP_SET_RAW_RC:
    //Measure time
    break;    
  default:
    println("Don't know how to handle reply "+icmd);
  }
}

/**
 * Flone, The flying phone
 * By Lot Amor\u00f3s from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//Radio Control Manager

public void calculateRCValues() {
  if (overControl) { //((mouseY > minlineY) && (mouseY < maxlineY))
    rcThrottle =  PApplet.parseInt(map(mouseY, minlineY, maxlineY, maxRC, minRC));
  }
  rcRoll =  PApplet.parseInt(map(rotationY, minY, maxY, minRC, maxRC));
  rcPitch =  PApplet.parseInt (map(rotationX, minX, maxX, maxRC, minRC));
  rcYaw = PApplet.parseInt( map(mouseX, 0, width, minRC, maxRC));
  rcPitch = 3000 - rcPitch;
  rcThrottle = constrain(rcThrottle, minRC, maxRC);
  rcRoll = constrain(rcRoll, minRC, maxRC);
  rcPitch = constrain(rcPitch, minRC, maxRC);
  //rcYaw= constrain(rcYaw, minRC, maxRC);
  //rcYaw=rotationZ*100;
  rcYaw=medRC;
}

static Character[] payloadChar = new Character[16];

public void updateRCPayload() {
  payloadChar[0] = PApplet.parseChar(rcPitch & 0xFF); //strip the 'most significant bit' (MSB) and buffer  
  payloadChar[1] = PApplet.parseChar(rcPitch>>8 & 0xFF); //move the MSB to LSB, strip the MSB and buffer
  payloadChar[2] = PApplet.parseChar(rcRoll & 0xFF);   
  payloadChar[3] = PApplet.parseChar(rcRoll>>8 & 0xFF);   
  payloadChar[4] = PApplet.parseChar(rcYaw & 0xFF);   
  payloadChar[5] = PApplet.parseChar(rcYaw>>8 & 0xFF);   
  payloadChar[6] = PApplet.parseChar(rcThrottle & 0xFF);   
  payloadChar[7] = PApplet.parseChar(rcThrottle>>8 & 0xFF);   

  //aux1 
  payloadChar[8] = PApplet.parseChar(rcAUX1 & 0xFF);   
  payloadChar[9] = PApplet.parseChar(rcAUX1>>8 & 0xFF);   

  //aux2
  payloadChar[10] = PApplet.parseChar(rcAUX2 & 0xFF);   
  payloadChar[11] = PApplet.parseChar(rcAUX2>>8 & 0xFF);   

  //aux3
  payloadChar[12] = PApplet.parseChar(rcAUX3 & 0xFF);   
  payloadChar[13] = PApplet.parseChar(rcAUX3>>8 & 0xFF);   

  //aux4
  payloadChar[14] = PApplet.parseChar(rcAUX4 & 0xFF);   
  payloadChar[15] = PApplet.parseChar(rcAUX4>>8 & 0xFF);
}

static private int irmsp_RC =0;
static private final int mspLenght_RC = 22;
static private int bRMSP_RC=0;
private static List<Byte> msp_RC;
public void sendRCPayload() {
  byte[] arr_RC;
  irmsp_RC =0;
  bRMSP_RC=0;  
  arr_RC = new byte[mspLenght_RC];  
  msp_RC = requestMSP(MSP_SET_RAW_RC, payloadChar );
  //msp_RC = requestMSPRC();

  try {
    for (bRMSP_RC=0;bRMSP_RC<mspLenght_RC;bRMSP_RC++) {
      arr_RC[irmsp_RC++] = msp_RC.get(bRMSP_RC);
    }   
    tBlue.write(arr_RC);
  }
  catch(NullPointerException ex) {
    println("Warning: Packet not sended.");
  }
}

/**
 * Flone, The flying phone
 * By Lot Amor\u00f3s from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//Sensors



private float[] exponentialSmoothing( float[] input, float[] output, float alpha ) {
        if ( output == null ) 
            return input;
        for ( int i=0; i<input.length; i++ ) {
             output[i] = output[i] + alpha * (input[i] - output[i]);
        }
        return output;
}

private static final int azimutBuffer = 100;
private float[] azimuts = new float [azimutBuffer];

 public final float averageAngle()//float[] terms, int totalTerm)
{
    float sumSin = 0;
    float sumCos = 0;
    for (int i = 0; i < azimutBuffer; i++)
    {
        sumSin += Math.sin(azimuts[i]);
        sumCos += Math.cos(azimuts[i]);
    }
    return (float) Math.atan2(sumSin / azimutBuffer, sumCos / azimutBuffer);
}

class mSensorEventListener implements SensorEventListener
{
  
  private float[] mGravity;
  private float[] mGeomagnetic;
  private float I[] = new float[16];
  private float R[] = new float[16];
  // Orientation values
  private float orientation[] = new float[3];  
  private int millis;

  private  int az=0;

 private void addAzimut(float azimut){
   //for (az=azimutBuffer-1;az>0;az--)
   // azimuts[az] = azimuts[az-1];
   azimuts[az++] = azimut;
   if (az == azimutBuffer)
     az = 0;
 }
 


  // Define all SensorListener methods
  public void onSensorChanged(SensorEvent event)
  {
    millis = PApplet.parseInt(millis());
    //if (event.accuracy == SensorManager.SENSOR_STATUS_ACCURACY_LOW) return;    
    switch (event.sensor.getType()) {
    case Sensor.TYPE_MAGNETIC_FIELD:
      //mGeomagnetic = event.values.clone();
      mGeomagnetic = lowPass( event.values.clone(), mGeomagnetic );
      //mGeomagnetic = lowPass( event.values.clone(), mGeomagnetic );
      //exponentialSmoothing( mGeomagnetic.clone(), mGeomagnetic, 0.5 );//
      cycleMag = millis - lastCycleMag;
      lastCycleMag = millis;
      break;
    case Sensor.TYPE_ACCELEROMETER:
    //case Sensor.TYPE_GRAVITY:
      //mGravity = event.values.clone();
      mGravity = lowPass( event.values.clone(), mGravity );
      //exponentialSmoothing( mGravity.clone(), mGravity, 0.2 );
      cycleAcc = millis - lastCycleAcc;
      lastCycleAcc = millis;
      break;
    }
    
    if (mGravity != null && mGeomagnetic != null) {
      //exponentialSmoothing( mGravity.clone(), mGravity, 0.2 );
      //exponentialSmoothing( mGeomagnetic.clone(), mGeomagnetic, 0.5 );
        

      I = new float[16];
      R = new float[16];
      if (SensorManager.getRotationMatrix(R, I, mGravity, mGeomagnetic))
      { // Got rotation matrix!
        SensorManager.getOrientation(R, orientation);
        //azimuth = orientation[0];
        azimuth =  (float)Math.toDegrees(orientation[0]);
        addAzimut(azimuth);
        //Math.toDegrees(azimuthInRadians)+360)%360;
        pitch   = orientation[1];
        roll    = orientation[2];
        rotationX =  orientation[2];
        rotationY =  orientation[1];
      }
    }
    if (millis-lastSend>50)    
      if (tBlue!= null) {
        calculateRCValues();
        updateRCPayload();
        sendRCPayload();
        lastSend = millis;
      }     
  }

  public void onAccuracyChanged(Sensor sensor, int accuracy)
  {
    // Nada, but leave it in...
    println("Warning: Accuracy changed to: " + accuracy);
  }

  /*
 * time smoothing constant for low-pass filter 0 \u2264 alpha \u2264 1 ; a smaller
   * value basically means more smoothing See:
   * http://en.wikipedia.org/wiki/Low-pass_filter#Discrete-time_realization
   */
  private static final float ALPHA = 0.05f;

  /**
   * @see http
   *      ://en.wikipedia.org/wiki/Low-pass_filter#Algorithmic_implementation
   * @see http
   *      ://developer.android.com/reference/android/hardware/SensorEvent.html
   *      #values
   */


  protected float[] lowPass(float[] input, float[] output)
  {
    if (output == null)
      return input;

    int inputLength = input.length;
    for (int i = 0; i < inputLength; i++)
    {
      output[i] = output[i] + ALPHA * (input[i] - output[i]);
    }
    return output;
  }
}

public void initSensor()
{
  //Initiate instances
  sensorEventListener = new mSensorEventListener();
  mSensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
  accelerometer  = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  gravity = mSensorManager.getDefaultSensor(Sensor.TYPE_GRAVITY);
  magnetometer   = mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);

  sensorAvailable = true;

  //Register our listeners
  //SENSOR_DELAY_FASTEST   get sensor data as fast as possible
  //SENSOR_DELAY_GAME   rate suitable for games
  //SENSOR_DELAY_NORMAL   rate (default) suitable for screen orientation changes
  //SENSOR_DELAY_UI
  
  mSensorManager.registerListener(sensorEventListener, accelerometer, mSensorManager.SENSOR_DELAY_FASTEST);
  mSensorManager.registerListener(sensorEventListener, magnetometer, mSensorManager.SENSOR_DELAY_FASTEST);
  mSensorManager.registerListener(sensorEventListener, gravity, mSensorManager.SENSOR_DELAY_FASTEST);
}

public void exitSensor()
{
  if (sensorAvailable) mSensorManager.unregisterListener(sensorEventListener);
}

public void printSensors()
{ 
    // Get the SensorManager 
    mSensorManager= (SensorManager) getSystemService(SENSOR_SERVICE);

    // List of Sensors Available
    List<Sensor> msensorList = mSensorManager.getSensorList(Sensor.TYPE_ALL);

    // Print how may Sensors are there
    println(msensorList.size()+" ");//+this.getString(R.string.sensors)+"!");

    // Print each Sensor available using sSensList as the String to be printed
    //String sSensList = new String("");
    //Sensor tmp;
    int x,i;
    for (i=0;i<msensorList.size();i++){
      println(msensorList.get(i));
     //tmp = msensorList.get(i);
     //sSensList = " "+sSensList+tmp.getName(); // Add the sensor name to the string of sensors available
    }
    // if there are sensors available show the list
   /* if (i>0){
     //sSensList = getString(R.string.sensors)+":"+sSensList;
     println(sSensList);
    } */
}

/**
 * Flone, The flying phone
 * By Lot Amor\u00f3s from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//cdataarray

cDataArray
accPITCH   = new cDataArray(200), accROLL    = new cDataArray(200), accYAW     = new cDataArray(200), 
gyroPITCH  = new cDataArray(200), gyroROLL   = new cDataArray(200), gyroYAW    = new cDataArray(200), 
magxData   = new cDataArray(200), magyData   = new cDataArray(200), magzData   = new cDataArray(200), 
altData    = new cDataArray(200), headData   = new cDataArray(200), 
debug1Data = new cDataArray(200), debug2Data = new cDataArray(200), debug3Data = new cDataArray(200), debug4Data = new cDataArray(200);



class cDataArray {
  private float[] m_data;
  private int m_maxSize, m_startIndex = 0, m_endIndex = 0, m_curSize;
  
  cDataArray(int maxSize){
    m_maxSize = maxSize;
    m_data = new float[maxSize];
  }
  public void addVal(float val) {
    m_data[m_endIndex] = val;
    m_endIndex = (m_endIndex+1)%m_maxSize;
    if (m_curSize == m_maxSize) {
      m_startIndex = (m_startIndex+1)%m_maxSize;
    } else {
      m_curSize++;
    }
  }
  public float getVal(int index) {return m_data[(m_startIndex+index)%m_maxSize];}
  public int getCurSize(){return m_curSize;}
  public int getMaxSize() {return m_maxSize;}
  public float getMaxVal() {
    float res = 0.0f;
    for(int i=0; i<m_curSize-1; i++) if ((m_data[i] > res) || (i==0)) res = m_data[i];
    return res;
  }
  public float getMinVal() {
    float res = 0.0f;
    for(int i=0; i<m_curSize-1; i++) if ((m_data[i] < res) || (i==0)) res = m_data[i];
    return res;
  }
  public float getRange() {return getMaxVal() - getMinVal();}
}
/**
 * Flone, The flying phone
 * By Lot Amor\u00f3s from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */



public void floneId(){
    InputMethodManager imm = (InputMethodManager) getSystemService(this.INPUT_METHOD_SERVICE);
    imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
    btName.setPosition(padding,(height/2)+padding);
    txtId.setPosition((width/8)+20, height/2);
    floneId="";
    txtId.setCaptionLabel(floneId);
    
}

public void arm(boolean theValue) {
  maxCycle =0;
  if (theValue) {
    rcThrottle=1000;
    mouseY = maxlineY;
    rcAUX1 = 2000;
    armToggle.setCaptionLabel("armed");
    armToggle.setColorActive(color(240, 0, 0));
    // thread(Toast.makeText(getApplicationContext(), "flone ARMED!", Toast.LENGTH_SHORT).show());
  }
  else {
    rcAUX1 = 1000;
    armToggle.setCaptionLabel("disarmed");
    armToggle.setColorActive(color(0, 220, 0));
    // thread(Toast.makeText(getApplicationContext(), "flone disarmed", Toast.LENGTH_SHORT).show());
  }
}

public void connect(int theValue) {
  println("connecting flone");
  //Toast.makeText(getApplicationContext(), "calibrating flone", Toast.LENGTH_SHORT).show();
  printSensors();
  //sendRequestMSP(requestMSP(MSP_ACC_CALIBRATION));
  try {
    tBlue.connect();
  }
  catch (NullPointerException ex) {
    println("Warning: Flone not connected");
  }
}


public void flightMode(int a) {
  //flightMode.activate(a);
  switch(a) {
  case 1:
    stabilized();
    break;
  case 2:
    altitudeHold();
    break;
  case 3:
    loiter();
    break;
  }
}

public void stabilized() {
  println("Flightmode changed to Stabilized.");
  rcAUX2=minRC;
}

public void altitudeHold() {
  println("Flightmode changed to Altitude Hold.");
  rcAUX2=medRC;
}

public void loiter() {
  println("Flightmode changed to Loiter.");
  rcAUX2=maxRC;
}

public void mousePressed() {
  if ((mouseY>minlineY) && (mouseY<maxlineY)) {
    overControl = true;
    flightMode.activate(0);
    stabilized();
  }
  else
    overControl = false;


  if (!overControl && (mouseX>xLevelObj-200) && (mouseX<xLevelObj+200)&&(mouseY>yLevelObj-200) && (mouseY<yLevelObj+200))
  {
    sendRequestMSP(requestMSP(MSP_ACC_CALIBRATION));
    // Toast.makeText(getApplicationContext(), "calibrating flone", Toast.LENGTH_SHORT).show();
  }
}

public void mouseDragged() {
}

public void mouseReleased() {
  if (overControl) {
    flightMode.activate(1);
    altitudeHold();
    if (mouseY>(maxlineY-80)) {
      rcThrottle = minRC;
      flightMode.activate(0);
      stabilized();
    }
    else {
      rcThrottle = medRC;
      flightMode.activate(1);
      altitudeHold();
    }
    rcYaw=medRC;
    //rcPitch=medRC;
    //rcRoll=medRC;
  }
  overControl = false;
}

public void keyReleased() {
  if (key != CODED) {
    switch(key) {
    case BACKSPACE:
      floneId = floneId.substring(0,max(0,floneId.length()-1));
      txtId.setCaptionLabel(floneId);
      floneId= "";
      break;
    case ENTER:
    case RETURN:
    InputMethodManager imm = (InputMethodManager) getSystemService(this.INPUT_METHOD_SERVICE);
  imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
  txtId.setPosition((width/8)+20, height-padding-buttonHeight-(10*density));
  btName.setPosition(padding, height-doublePadding-PApplet.parseInt(buttonHeight/2)-(10*density));
  txtId.setCaptionLabel(floneId);
      break;
    case ESC:
    case DELETE:
      floneId="";
      break;
    default:
      floneId += key;
      txtId.setCaptionLabel(floneId);
    }
  }
}



/*
 void keyPressed() {
 // doing other things here, and then:
 if (key == CODED){
 if( keyCode == android.view.KeyEvent.KEYCODE_MENU)
 startMenu();  
 }
 }*/

/*
 public boolean onOptionsItemSelected(MenuItem item) {
 // Handle item selection
 switch (item.getItemId()) {
 case R.id.new_game:
 newGame();
 return true;
 case R.id.help:
 showHelp();
 return true;
 default:
 return super.onOptionsItemSelected(item);
 }
 }*/

/*    
 @Override
 public void onBackPressed() {
 new AlertDialog.Builder(this)
 .setIcon(android.R.drawable.ic_dialog_alert)
 .setTitle("Closing Activity")
 .setMessage("Are you sure you want to close this activity?")
 .setPositiveButton("Yes", new DialogInterface.OnClickListener()
 {
 @Override
 public void onClick(DialogInterface dialog, int which) {
 finish();    
 }
 
 })
 .setNegativeButton("No", null)
 .show();
 }*/
/**
 * Flone, The flying phone
 * tBlue.java - simple wrapper for Android Bluetooth libraries
 * (c) Tero Karvinen & Kimmo Karvinen http://terokarvinen.com/tblue
 * Modified version for flone by Lot Amor\u00f3s
 * http://flone.aeracoop.net
 */

// tBlue.java - simple wrapper for Android Bluetooth libraries
// (c) Tero Karvinen & Kimmo Karvinen http://terokarvinen.com/tblue
// Modified version for flone by Lot Amor\u00f3s












private final static int REQUEST_ENABLE_BT = 1;

/*
Baud rate: 115200
 Default Module name: HB02 
 Default Pair code: 1234
 */

public class TBlue { 
  private String address=null; 
  private static final String TAG="tBlue";
  private BluetoothAdapter localAdapter=null;
  private BluetoothDevice remoteDevice=null;
  public BluetoothSocket socket=null;
  public OutputStream outStream = null;
  public InputStream inStream=null;
 // private boolean failed=false;

  public TBlue()
  {
    localAdapter = BluetoothAdapter.getDefaultAdapter(); 
    if (!localAdapter.isEnabled())
    {
      Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
      startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
    }
    else {
      connect();
    }
  }

  public TBlue(String address) 
  {
    this.address=address.toUpperCase();
    localAdapter = BluetoothAdapter.getDefaultAdapter();
    if ((localAdapter!=null) && localAdapter.isEnabled()) {
      Log.i(TAG, "Bluetooth adapter found and enabled on phone. ");
    } 
    else {
      Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
      startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
      Log.e(TAG, "Bluetooth adapter NOT FOUND or NOT ENABLED!");
      return;
    }
    connect();
  } 

  public void connect()
  {
    for (BluetoothDevice dp : localAdapter.getBondedDevices()) {
      if (dp.getName().equals(floneId))//floneId
        this.address = dp.getAddress();
    }
    Log.i(TAG, "Bluetooth connecting to "+address+"...");
    try {
      remoteDevice = localAdapter.getRemoteDevice(address);
    } 
    catch (IllegalArgumentException e) {
      Log.e(TAG, "Failed to get remote device with MAC address."
        +"Wrong format? MAC address must be upper case. ", 
      e);
      return;
    }

    Log.i(TAG, "Creating RFCOMM socket..."); 
    try {
      Method m = remoteDevice.getClass().getMethod
        ("createRfcommSocket", new Class[] { 
        int.class
      }
      );
      socket = (BluetoothSocket) m.invoke(remoteDevice, 1); 
      Log.i(TAG, "RFCOMM socket created.");
    } 
    catch (NoSuchMethodException e) {
      Log.i(TAG, "Could not invoke createRfcommSocket.");
      e.printStackTrace();
    } 
    catch (IllegalArgumentException e) {
      Log.i(TAG, "Bad argument with createRfcommSocket.");
      e.printStackTrace();
    } 
    catch (IllegalAccessException e) {
      Log.i(TAG, "Illegal access with createRfcommSocket.");
      e.printStackTrace();
    } 
    catch (InvocationTargetException e) {
      Log.i(TAG, "Invocation target exception: createRfcommSocket.");
      e.printStackTrace();
    }
    Log.i(TAG, "Got socket for device "+socket.getRemoteDevice()); 
    localAdapter.cancelDiscovery(); 

    Log.i(TAG, "Connecting socket...");
    try {
      socket.connect(); 
      Log.i(TAG, "Socket connected.");
      println("Socket connected.");
    } 
    catch (IOException e) {
      try {
        Log.e(TAG, "Failed to connect socket. ", e);
        socket.close();
        Log.e(TAG, "Socket closed because of an error. ", e);
      } 
      catch (IOException eb) {
        Log.e(TAG, "Also failed to close socket. ", eb);
      }
      return;
    }

    try {
      outStream = socket.getOutputStream(); 
      Log.i(TAG, "Output stream open.");
      println("Output stream open.");
      inStream = socket.getInputStream();
      Log.i(TAG, "Input stream open.");
    } 
    catch (IOException e) {
      Log.e(TAG, "Failed to create output stream.", e);  
      println("Failed to create output stream.");
    }
    return;
  }

  public void write(String s) 
  {
    //No tags here for performance
    //Log.i(TAG, "Sending \""+s+"\"... "); 
    byte[] outBuffer= s.getBytes(); 
    try {
      outStream.write(outBuffer);
    } 
    catch (IOException e) {
      Log.e(TAG, "Write failed.", e);
    }
  }

  public void write(byte[] outBuffer) 
  {
    //No tags here for performance
    //Log.i(TAG, "Sending "); 
    try {
      outStream.write(outBuffer);
    } 
    catch (IOException e) {
      Log.e(TAG, "Write failed.", e);
    }
  }

  public boolean streaming() 
  {
    return ( (socket!=null) && (inStream!=null) && (outStream!=null) );
  }
  
  public boolean connected() 
  {
    return (socket!=null);
  }

  /*public String readString() 
  {
    if (!streaming()) return ""; 
    String inStr="";
    try {
      if (0<inStream.available()) {
        byte[] inBuffer = new byte[1024];
        int bytesRead = inStream.read(inBuffer);
        inStr = new String(inBuffer, "ASCII");
        inStr=inStr.substring(0, bytesRead); 
        Log.i(TAG, "byteCount: "+bytesRead+ ", inStr: "+inStr);
      }
    } 
    catch (IOException e) {
      Log.e(TAG, "Read failed", e);
    }
    return inStr;
  }*/


private byte[] inBuffer = new byte[32];//try?error
private int bytesRead = 0;
  public void read() 
  {    
    try {
      if (inStream.available()>0) {
        bytesRead = inStream.read(inBuffer);  
        parseMSPMessage(inBuffer,bytesRead);
      }
    } 
    catch (Exception e) {
      Log.e(TAG, "Read failed", e);
      println("Read failed"+e);
      inBuffer = null;
    }
  }

//Falla
  public void close()
  {
    Log.i(TAG, "Bluetooth closing... ");
    try {
      outStream.close();
      inStream.close();
      socket.close();
      Log.i(TAG, "BT closed");
    } 
    catch (Exception e2) {
      Log.e(TAG, "Failed to close socket. ", e2);
    }
  }
}


}
