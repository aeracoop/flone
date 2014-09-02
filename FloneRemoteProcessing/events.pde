/**
 * Flone, The flying phone
 * By Lot Amorós from Aeracoop
 * GPL v3
 * http://flone.aeracoop.net
 */

import android.view.inputmethod.InputMethodManager;

void floneId(){
    InputMethodManager imm = (InputMethodManager) getSystemService(this.INPUT_METHOD_SERVICE);
    imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
    btName.setPosition(padding,(height/2)+padding);
    txtId.setPosition((width/8)+20, height/2);
    floneId="";
    txtId.setCaptionLabel(floneId);
    
}

void arm(boolean theValue) {
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

void connect(int theValue) {
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


void flightMode(int a) {
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

void stabilized() {
  println("Flightmode changed to Stabilized.");
  rcAUX2=minRC;
}

void altitudeHold() {
  println("Flightmode changed to Altitude Hold.");
  rcAUX2=medRC;
}

void loiter() {
  println("Flightmode changed to Loiter.");
  rcAUX2=maxRC;
}

void mousePressed() {
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

void mouseDragged() {
}

void mouseReleased() {
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

void keyReleased() {
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
  btName.setPosition(padding, height-doublePadding-int(buttonHeight/2)-(10*density));
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
