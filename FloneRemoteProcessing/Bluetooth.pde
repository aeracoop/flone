/**
 * Flone, The flying phone
 * By Lot Amorós from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//Bluetooth.pde

void bluetoothLoop() {
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

