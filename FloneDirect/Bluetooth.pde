//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}

/*
Baud rate: 115200
 Module name: HB02 or HB01
 Pair code: 1234
 */

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data)
{
  // while (g_serial.available()>0) {
  int dataLength = data.length;
  for (k=0;k<dataLength;k++) {
    c = (char)data[k]; //(g_serial.read());

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

String getBluetoothInformation()
{
  String btInfo = "Server Running: ";
  btInfo += bt.isStarted() + "\n";
  btInfo += "Discovering: " + bt.isDiscovering() + "\n";
  btInfo += "Device Discoverable: "+bt.isDiscoverable() + "\n";
  btInfo += "\nConnected Devices: \n";

  ArrayList<String> devices = bt.getConnectedDeviceNames();
  for (String device: devices)
  {
    btInfo+= device+"\n";
  }
  return btInfo;
}

public void BT_info(int theValue) {
  String info;
  println("BT info:");
  println( getBluetoothInformation());

  info = "Discovered Devices:\n";
  ArrayList<String> names;
  names = bt.getDiscoveredDeviceNames();
  for (int i=0; i < names.size(); i++)
  {
    info += "["+i+"] "+names.get(i).toString() + "\n";
  }
  print (info);
  print("Connected to flone: ");
  println (isConnectedtoFlone());
}

void bluetoothLoop() {
  if (!isDiscoveredFlone() && !isConnectedtoFlone()) {
    bt.discoverDevices();
  }

  if (isDiscoveredFlone() && !isConnectedtoFlone()) {
    //cp5.getController("BT_Connected").setValue(0);
    println("Conectando");
    bt.connectToDeviceByName("HB01");
  }
}

static   ArrayList<String> names;
public boolean isConnectedtoFlone() {
  //ArrayList<String> names;
  names = bt.getConnectedDeviceNames();
  int nameSize = names.size();
  for (i=0; i < nameSize; i++)
  {
    if (names.get(i).equals("HB01(00:13:03:29:25:24)") ) {
      floneConnected = true;
      return true;
    }
  }
  floneConnected = false;
  return false;
}

public boolean isDiscoveredFlone() {
  ArrayList<String> names;
  names = bt.getDiscoveredDeviceNames();
  for (i=0; i < names.size(); i++)
  {
    if (names.get(i).equals("HB01") )
      return true;
  }
  return false;
}

