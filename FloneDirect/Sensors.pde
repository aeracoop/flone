
class mSensorEventListener implements SensorEventListener
{
  float[] mGravity;
  float[] mGeomagnetic;

  // Orientation values
  float orientation[] = new float[3];  

  // Define all SensorListener methods
  public void onSensorChanged(SensorEvent event)
  {
   // if (event.accuracy == SensorManager.SENSOR_STATUS_ACCURACY_LOW) return;  
    
    switch (event.sensor.getType()) {
    case Sensor.TYPE_MAGNETIC_FIELD:
      //mGeomagnetic = event.values.clone();
      mGeomagnetic = lowPass( event.values.clone(), mGeomagnetic );    
      cycleMag = millis() - lastCycleMag;
      lastCycleMag = millis();
      break;
    case Sensor.TYPE_ACCELEROMETER:
      //mGravity = event.values.clone();
      mGravity = lowPass( event.values.clone(), mGravity );
      cycleAcc = millis() - lastCycleAcc;
      lastCycleAcc = millis();
      break;
    }       

    if (mGravity != null && mGeomagnetic != null) {
      float I[] = new float[16];
      float R[] = new float[16];
      if (SensorManager.getRotationMatrix(R, I, mGravity, mGeomagnetic))
      { // Got rotation matrix!
        SensorManager.getOrientation(R, orientation);
        azimuth = orientation[0];
        pitch   = orientation[1];
        roll    = orientation[2];
        rotationX = orientation[2];
        rotationY = orientation[1];
      }
    }

    if (millis()-lastSend>30)    
      if (floneConnected = true) {
        calculateRCValues();
        sendRCValues();
        lastSend = millis();
      }
  }

  public void onAccuracyChanged(Sensor sensor, int accuracy)
  {
    // Nada, but leave it in...
  }

  /*
 * time smoothing constant for low-pass filter 0 ≤ alpha ≤ 1 ; a smaller
   * value basically means more smoothing See:
   * http://en.wikipedia.org/wiki/Low-pass_filter#Discrete-time_realization
   */
  static final float ALPHA = 0.15f;

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
  // Initiate instances
  sensorEventListener = new mSensorEventListener();
  mSensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
  accelerometer  = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  magnetometer   = mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);

  sensorAvailable = true;

  // Register our listeners
  mSensorManager.registerListener(sensorEventListener, accelerometer, mSensorManager.SENSOR_DELAY_FASTEST);
  mSensorManager.registerListener(sensorEventListener, magnetometer, mSensorManager.SENSOR_DELAY_FASTEST);
}

void exitSensor()
{
  if (sensorAvailable) mSensorManager.unregisterListener(sensorEventListener);
}

