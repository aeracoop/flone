/******************************* Multiwii Serial Protocol **********************/

private static final String MSP_HEADER = "$M<";

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
static int read32() {return (inBuf[p++]&0xff) + ((inBuf[p++]&0xff)<<8) + ((inBuf[p++]&0xff)<<16) + ((inBuf[p++]&0xff)<<24); }
int read16() {return (inBuf[p++]&0xff) + ((inBuf[p++])<<8); }
int read8()  {return inBuf[p++]&0xff;}

static int mode;
static int multiCapability;

//send msp without payload
private List<Byte> requestMSP(int msp) {
  return  requestMSP( msp, null);
}

//send multiple msp without payload

static  List<Byte>  s1 = new LinkedList<Byte>();

private List<Byte> requestMSP (int[] msps) {
//  s1 = new LinkedList<Byte>();
 int mspSize = msps.length;
  for (int k=0;k<mspSize;k++) {
    s1.addAll(requestMSP(msps[k], null));
  }
  return s1;
}

//send msp with payload
static int headerLength;
static byte[] header;
//static List<Byte>bf = new LinkedList<Byte>();
private List<Byte> requestMSP (int msp, Character[] payload) {
  if(msp < 0) { return null; }
  List<Byte>bf = new LinkedList<Byte>();
  //bf = new LinkedList<Byte>();
  header = MSP_HEADER.getBytes();  
  headerLength = header.length; 
  for (int c=0;c<headerLength;c++) {
    bf.add( header[c] );
  }
  
  byte checksum=0;
  byte pl_size = (byte)((payload != null ? int(payload.length) : 0)&0xFF);
  bf.add(pl_size);
  checksum ^= (pl_size&0xFF);
  
  bf.add((byte)(msp & 0xFF));
  checksum ^= (msp&0xFF);
  
  if (payload != null) {
    int payloadLength = payload.length;
    for (int c=0;c<payloadLength;c++){
      bf.add((byte)(payload[c]&0xFF));
      checksum ^= (payload[c]&0xFF);
    }
  }
  bf.add(checksum);
  return (bf);
}

void sendRequestMSP(List<Byte> msp) {
  byte[] arr = new byte[msp.size()];
  int i = 0;
  
  int mspLenght = msp.size();
  for (int b=0;b<mspLenght;b++) {
    arr[i++] = msp.get(b);
  }
    bt.writeToDeviceName("HB01", arr);
}

public void evaluateCommand(byte cmd, int dataSize) {
  int icmd = (int)(cmd&0xFF);
  switch(icmd) {
    case MSP_IDENT:
        version = read8();
        multiType = read8();
        read8(); // MSP version
        multiCapability = read32();// capability
        /*if ((multiCapability&1)>0) {
          buttonRXbind = controlP5.addButton("bRXmbind",1,10,yGraph+205-10,55,10); buttonRXbind.setColorBackground(blue_);buttonRXbind.setLabel("RX Bind");
        }*/
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
        ax = read16();ay = read16();az = read16();
        gx = read16()/8;gy = read16()/8;gz = read16()/8;
        magx = read16()/3;magy = read16()/3;magz = read16()/3; break;
    case MSP_SERVO:
        for(i=0;i<8;i++) servo[i] = read16(); break;
    case MSP_MOTOR:
        for(i=0;i<8;i++) mot[i] = read16(); break;
    case MSP_RC:
        rcRoll = read16();rcPitch = read16();rcYaw = read16();rcThrottle = read16();    
        rcAUX1 = read16();rcAUX2 = read16();rcAUX3 = read16();rcAUX4 = read16(); break;
    case MSP_RAW_GPS:
        GPS_fix = read8();
        GPS_numSat = read8();
        GPS_latitude = read32();
        GPS_longitude = read32();
        GPS_altitude = read16();
        GPS_speed = read16(); break;
    case MSP_COMP_GPS:
        GPS_distanceToHome = read16();
        GPS_directionToHome = read16();
        GPS_update = read8(); break;
    case MSP_ATTITUDE:
        angx = read16()/10;angy = read16()/10;
        head = read16(); break;
    case MSP_ALTITUDE:
        alt = read32(); break;
    case MSP_BAT:
        bytevbat = read8();
        pMeterSum = read16(); break;
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
    /*case MSP_BOX:
        for( i=0;i<CHECKBOXITEMS;i++) {
          activation[i] = read16();
          for(int aa=0;aa<12;aa++) {
            if ((activation[i]&(1<<aa))>0) checkbox[i].activate(aa); else checkbox[i].deactivate(aa);
          }
        } break;
    case MSP_BOXNAMES:
        create_checkboxes(new String(inBuf, 0, dataSize).split(";"));
        break;
    case MSP_PIDNAMES:
        // TODO create GUI elements from this message 
        //System.out.println("Got PIDNAMES: "+new String(inBuf, 0, dataSize));
        break;*/
    /*case MSP_MISC:
        intPowerTrigger = read16();
        confPowerTrigger.setValue(intPowerTrigger);
        updateModelMSP_SET_MISC();
        break;*/
    case MSP_MOTOR_PINS:
        for( i=0;i<8;i++) {
          byteMP[i] = read8();
        } break;
    case MSP_DEBUGMSG:
        while(dataSize-- > 0) {
          char c = (char)read8();
          if (c != 0) {
            System.out.print( c );
          }
        }
        break;
    case MSP_DEBUG:
        debug1 = read16();debug2 = read16();debug3 = read16();debug4 = read16(); break;
    case MSP_SET_RAW_RC:
        break;    
    default:
        println("Don't know how to handle reply "+icmd);
  }
}


