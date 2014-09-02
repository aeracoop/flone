/**
 * Flone, The flying phone
 * By Lot Amorós from Aeracoop
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
import java.util.List;
import java.util.LinkedList;
import java.lang.StringBuffer; // for efficient String concatemation
//import java.util.UUID; 
//import java.lang.Object.Looper;

//Processing
import controlP5.*;

//Android
import android.util.DisplayMetrics; 
//import android.app.Activity;
//import android.app.AlertDialog;
import android.os.Bundle;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.IntentFilter;
import android.content.Intent;
//import android.content.DialogInterface;
//import android.content.DialogInterface.OnClickListener;
import android.widget.Toast;

//Sensors
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

//Bluetooth
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;

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

static float azimuth       = 0.0;
static float pitch         = 0.0;
static float roll          = 0.0;

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

private static final int ROLL = 0, PITCH = 1, YAW = 2, ALT = 3, VEL = 4, LEVEL = 5, MAG = 6;

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
private static Knob btKnob;

private static String floneId;
private static Button txtId;

private static Textlabel btName;

float density = 2; 
int densityDpi = 320;

int buttonWidth = int(44* 2);
int buttonHeight = int (28 * 2);


void setup()
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
  textFont(fontFlone, int(10*density));
  spaceBar = int(15*density);
  levelSize = int(78 * density); 
  horizonInstrSize = int(45* density);
  buttonWidth =int(44* density);
  buttonHeight=int (28 * density);


  minX = -1;
  minY = -1;
  maxX = 1;
  maxY = 1;

  minlineY = (height/2) - (width/2);
  maxlineY = (height/2) + (width/2);

  xLevelObj = (width/2);
  //yLevelObj = (minlineY/2)-padding*4;
  yLevelObj = (minlineY/2)+int(10*density);

  xRC = 2*(width/3)+int(14*density);

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
                    .setSize(int(20*density))
                      .align(ControlP5.CENTER, ControlP5.CENTER);


  flightMode = cp5.addRadioButton("flightMode")
    .setPosition(padding*2, padding*2 + (height/16))
      .setSize((width/8)-padding * 2, height/30)
        .setColorForeground(color(20, 200, 20))
          //.setColorActive(color(10, 2, 200))
          .setColorLabel(color(255))
            .setItemsPerRow(1)
              .setSpacingRow(int(6*density))
                .addItem("Stabilized", 1)
                  .addItem("Alt Hold", 2)
                    .addItem("Loiter", 3)
                      ;

  flightMode.getItem(0).captionLabel().setColorBackground(color(255, 80, 80));
  flightMode.getItem(1).captionLabel().setColorBackground(color(55, 200, 80));
  flightMode.getItem(2).captionLabel().setColorBackground(color(55, 80, 255));

  for (Toggle t : flightMode.getItems ()) {
    t.captionLabel().setFont(fontFlone);    
    t.captionLabel().setSize(int(12*density));
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
      .setPosition(width-int(100*density), height-padding-int(48*density))
        .setRadius(int(16*density))
          .setDragDirection(Knob.VERTICAL)
            // .valueLabel()
            //             .setFont(fontFlone)
            //    .setSize(20)
            ;

  btName = cp5.addTextlabel("btName")
    .setText("bt Name:")
      .setPosition(padding, height-doublePadding-int(buttonHeight/2)-(10*density))
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
  int rxButonWidth = (width/3)-int(14*density);

  rcStickThrottleSlider = cp5.addSlider("throttle", minRC, maxRC, medRC, xRC, yRC, rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickRollSlider = cp5.addSlider("pitch", minRC, maxRC, medRC, xRC, yRC+(spaceBar), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickPitchSlider = cp5.addSlider("roll", minRC, maxRC, medRC, xRC, yRC+(spaceBar*2), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickYawSlider = cp5.addSlider("yaw", minRC, maxRC, medRC, xRC, yRC+(spaceBar*3), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickAUX1Slider = cp5.addSlider("Aux 1", minRC, maxRC, medRC, xRC, yRC+(spaceBar*4), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickAUX2Slider = cp5.addSlider("Aux 2", minRC, maxRC, medRC, xRC, yRC+(spaceBar*5), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickAUX3Slider = cp5.addSlider("Aux 3", minRC, maxRC, medRC, xRC, yRC+(spaceBar*6), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);
  rcStickAUX4Slider = cp5.addSlider("Aux 4", minRC, maxRC, medRC, xRC, yRC+(spaceBar*7), rxButonWidth, rxButonHeight).setDecimalPrecision(0).setUpdate(true).setRange(minRC, maxRC);


  rcStickThrottleSlider.captionLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickRollSlider.captionLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickPitchSlider.captionLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickYawSlider.captionLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickAUX1Slider.captionLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickAUX2Slider.captionLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickAUX3Slider.captionLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickAUX4Slider.captionLabel().setFont(fontFlone).setSize(int(8*density));


  rcStickThrottleSlider.valueLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickRollSlider.valueLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickPitchSlider.valueLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickYawSlider.valueLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickAUX1Slider.valueLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickAUX2Slider.valueLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickAUX3Slider.valueLabel().setFont(fontFlone).setSize(int(8*density));
  rcStickAUX4Slider.valueLabel().setFont(fontFlone).setSize(int(8*density));

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

void draw()
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
