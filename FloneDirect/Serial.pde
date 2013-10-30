// initialize the serial port selected in the listBox

void InitSerial() {
/*
  String portName = Serial.list()[0];
    g_serial = new Serial(this, "/dev/ttyACM0", 115200);
     println(Serial.list());
    g_serial.buffer(256);*/
    

}

/*void InitSerial(float portValue) {
  if (portValue < commListMax) {
    String portPos = Serial.list()[int(portValue)];
    txtlblWhichcom.setValue("COM = " + shortifyPortName(portPos, 8));
    g_serial = new Serial(this, portPos, GUI_BaudRate);
    SaveSerialPort(portPos);
    init_com=1;
    buttonSTART.setColorBackground(green_);buttonSTOP.setColorBackground(green_);buttonREAD.setColorBackground(green_);
    buttonRESET.setColorBackground(green_);commListbox.setColorBackground(green_);
    buttonCALIBRATE_ACC.setColorBackground(green_); buttonCALIBRATE_MAG.setColorBackground(green_);
    graphEnable = true;
    g_serial.buffer(256);
    btnQConnect.hide();
  } else {
    txtlblWhichcom.setValue("Comm Closed");
    init_com=0;
    buttonSTART.setColorBackground(red_);buttonSTOP.setColorBackground(red_);commListbox.setColorBackground(red_);buttonSETTING.setColorBackground(red_);
    graphEnable = false;
    init_com=0;
    g_serial.stop();
    btnQConnect.show();
  }
}*/
