/**
 * Flone, The flying phone
 * By Lot Amorós from Aeracoop
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

void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  IntentFilter filter1 = new IntentFilter(BluetoothDevice.ACTION_ACL_CONNECTED);
  IntentFilter filter2 = new IntentFilter(BluetoothDevice.ACTION_ACL_DISCONNECT_REQUESTED);
  IntentFilter filter3 = new IntentFilter(BluetoothDevice.ACTION_ACL_DISCONNECTED);
  this.registerReceiver(BTReceiver, filter1);
  this.registerReceiver(BTReceiver, filter2);
  this.registerReceiver(BTReceiver, filter3);
}

void onActivityResult (int requestCode, int resultCode, Intent data) {
  if (resultCode == RESULT_OK) {
    tBlue.connect();
  }
  else {
    println("No se ha activado el bluetooth");
  }
}

void onStart() {
  super.onStart();
  println("onStart");
  //comprobar adaptador bluetooth conectado
  initSensor();
  tBlue = new TBlue();
}

void onStop() {
  exitSensor();
  if (tBlue!= null)
    tBlue.close();
  super.onStop();
}

void onResume()
{ 
  super.onResume();
  //initSensor(); // Initialize sensor objects
}

void onPause()
{ 
  super.onPause();
  //exitSensor(); // Unregister sensorEventListener
}

void onDestroy()
{
  this.unregisterReceiver(BTReceiver);
}

