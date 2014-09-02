/**
 * Flone, The flying phone
 * By Lot Amorós from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//Radio Control Manager

void calculateRCValues() {
  if (overControl) { //((mouseY > minlineY) && (mouseY < maxlineY))
    rcThrottle =  int(map(mouseY, minlineY, maxlineY, maxRC, minRC));
  }
  rcRoll =  int(map(rotationY, minY, maxY, minRC, maxRC));
  rcPitch =  int (map(rotationX, minX, maxX, maxRC, minRC));
  rcYaw = int( map(mouseX, 0, width, minRC, maxRC));
  rcPitch = 3000 - rcPitch;
  rcThrottle = constrain(rcThrottle, minRC, maxRC);
  rcRoll = constrain(rcRoll, minRC, maxRC);
  rcPitch = constrain(rcPitch, minRC, maxRC);
  //rcYaw= constrain(rcYaw, minRC, maxRC);
  //rcYaw=rotationZ*100;
  rcYaw=medRC;
}

static Character[] payloadChar = new Character[16];

void updateRCPayload() {
  payloadChar[0] = char(rcPitch & 0xFF); //strip the 'most significant bit' (MSB) and buffer  
  payloadChar[1] = char(rcPitch>>8 & 0xFF); //move the MSB to LSB, strip the MSB and buffer
  payloadChar[2] = char(rcRoll & 0xFF);   
  payloadChar[3] = char(rcRoll>>8 & 0xFF);   
  payloadChar[4] = char(rcYaw & 0xFF);   
  payloadChar[5] = char(rcYaw>>8 & 0xFF);   
  payloadChar[6] = char(rcThrottle & 0xFF);   
  payloadChar[7] = char(rcThrottle>>8 & 0xFF);   

  //aux1 
  payloadChar[8] = char(rcAUX1 & 0xFF);   
  payloadChar[9] = char(rcAUX1>>8 & 0xFF);   

  //aux2
  payloadChar[10] = char(rcAUX2 & 0xFF);   
  payloadChar[11] = char(rcAUX2>>8 & 0xFF);   

  //aux3
  payloadChar[12] = char(rcAUX3 & 0xFF);   
  payloadChar[13] = char(rcAUX3>>8 & 0xFF);   

  //aux4
  payloadChar[14] = char(rcAUX4 & 0xFF);   
  payloadChar[15] = char(rcAUX4>>8 & 0xFF);
}

static private int irmsp_RC =0;
static private final int mspLenght_RC = 22;
static private int bRMSP_RC=0;
private static List<Byte> msp_RC;
void sendRCPayload() {
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

