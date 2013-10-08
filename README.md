flone
=====

Flone app for flying smartphones

Developers introduction

Resume
Flone is an Android app and airframe that creates a flying platform for smartphones.
The airframe is a quadcopter designed for carry a smartphone, battery, and a good field of view for the two cameras of the smartphone.

The Android app allows the communication between the smartphone of the pilot (over wifi or 3g) and  the flight controlboard (over bluetooth).  
Communication system
The whole system is composed by this elements:
Communications between flight controller (Arduino) and phone
Communications between two smartphones.
Reading the sensors of the pilot phone and transform to send.
Flying Phone
It’s the smartphone onboard the quadcopter.
The goal of the app is make the communications bridge between the Pilot phone and the flight control board. 
To-do:
Receive MSP messages from wifi and send it via bluetooth to Multiwii.
Read GPS and send it to Multiwii.
Read Magnetómeter and send it to Multiwii.
Provide visual feedback with the screen/ speaker: Armed/Disarmed, etc.


Pilot Phone
To-do:
Read orientation and inclination of the phone.
Read position of finger in screen.
Transform reads to values, embed in Multiwii Serial Protocol and sendit.
Visual/Audio Feedback.
Configuration form.

* In the future for develop Missions possibility to use Andropilot or DroidPlanner open source apps:
https://www.youtube.com/watch?v=onzRl_4hynI

This app’s uses the more complex MAVLink protocol for waypoints and missions.

Future Development

Flone glasses using opendive:
http://www.durovis.com/opendive.html

Airframe
The airframe is a H quadcopter and it’s available at thingiverse:
Last version 1.7:
http://www.thingiverse.com/thing:113497
(Soon new version 2.0 with a lot of improvements)
The airframes are licensed under creative commons SA.
The bill of materials (except the smartphone) is around 110 euro.

Resources

Android OpenSource Apps for GroundStation
DroidPlanner
https://github.com/arthurbenemann/droidplanner/
AndroPilot
https://github.com/geeksville/arduleader

Multiwii Serial Protocol
http://armazila.com/sites/default/files/content/download/MultiwiiSerialProtocol(draft)v04.pdf

MAVLink Google group
https://groups.google.com/forum/#!forum/mavlink

MAVLink documentation
http://en.wikipedia.org/wiki/MAVLink

MAVLink start
http://qgroundcontrol.org/mavlink/start
