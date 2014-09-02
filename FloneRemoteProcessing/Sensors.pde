/**
 * Flone, The flying phone
 * By Lot Amorós from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

//Sensors

import android.R;

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
    millis = int(millis());
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
 * time smoothing constant for low-pass filter 0 ≤ alpha ≤ 1 ; a smaller
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

void initSensor()
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

void exitSensor()
{
  if (sensorAvailable) mSensorManager.unregisterListener(sensorEventListener);
}

void printSensors()
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

