
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
 Module name: HB02
 Pair code: 1234
 */

//Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] data)
{
  if (isConfiguring)
    return;
  println("Mensaje recibido");
  /*  KetaiOSCMessage m = new KetaiOSCMessage(data);
   //KetaiOSCMessage is the same as OscMessage
   //   but allows construction by byte array
   if (m.isValid())
   {
   if (m.checkAddrPattern("/remoteMouse/"))
   {
   if (m.checkTypetag("ii"))
   {        
   remoteMouse.x = m.get(0).intValue();
   remoteMouse.y = m.get(1).intValue();
   }
   }
   }*/
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
  ArrayList<String> names;
  println("BT info:");
  println( getBluetoothInformation());

  info = "Discovered Devices:\n";
  names = bt.getDiscoveredDeviceNames();
  for (int i=0; i < names.size(); i++)
  {
    info += "["+i+"] "+names.get(i).toString() + "\n";
  }
  print (info);
  print("Connected to flone: ");
  println (isConnectedtoFlone());
  
//  bt.writeToDeviceName(HB01, byte[] data);
}

/*
public void BT_Connected(int theValue) {
  println("bt connect");
}*/

public void bluetoothLoop() {
  if (!isDiscoveredFlone() && !isConnectedtoFlone()) {
    bt.discoverDevices();
    delay(1000);
  }
  
    if (!isConnectedtoFlone()) {
      cp5.getController("BT_Connected").setValue(0);
      println("Conectando");
      bt.connectToDeviceByName("HB01");
    }
    else
      cp5.getController("BT_Connected").setValue(1); 
}

  public boolean isConnectedtoFlone() {
    ArrayList<String> names;
    names = bt.getConnectedDeviceNames();
    for (int i=0; i < names.size(); i++)
    {
      if (names.get(i).equals("HB01(00:13:03:29:25:24)") )
        return true;
    }
    return false;
  }

  public boolean isDiscoveredFlone() {
    ArrayList<String> names;
    names = bt.getDiscoveredDeviceNames();
    for (int i=0; i < names.size(); i++)
    {
      if (names.get(i).equals("HB01") )
        return true;
    }
    return false;
  }

