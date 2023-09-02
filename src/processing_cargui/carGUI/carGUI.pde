import controlP5.*;
import processing.serial.*;

Serial port;

ControlP5 cp5;

Knob motorTempKnob;
Knob batteryTempKnob;


PFont font;

/* ------------------------- IMAGE VARIABLE DECLARATION ---------------------- */

PImage carRender;
PImage light_brake;
PImage light_brake2;
PImage light_neutral;
PImage light_turn;
PImage cargui;

PImage brake_off;
PImage brake_on;
PImage motor_off;
PImage motor_on;
PImage neutral_off;
PImage neutral_on;
PImage left_off;
PImage left_on;
PImage right_off;
PImage right_on;
PImage btemp_off;
PImage btemp_on;
PImage mtemp_off;
PImage mtemp_on;
PImage hazard_off;
PImage hazard_on;

PImage left_button;
PImage right_button;
PImage up_button;
PImage down_button;
PImage lights_button;
PImage brake_button;
PImage hazard_button;
PImage btemp_button;
PImage mtemp_button;
PImage motor_button;


/* ------------------------- AUX VARIABLE DECLARATION ---------------------- */

int y = 720;

int hour;
int minute;
int second;
int day;
int month;
int year;

String batteryTemp;
String motorTemp;

String tempRealBattery = "1";
String tempRealMotor = "1";

int lightNeutralStatus = 0;
int lightBrakeStatus = 0;
int lightTurnLStatus = 0;
int lightTurnRStatus = 0;
int lightEmerStatus = 0;

int aMotor = 650;
float maxvMotor = 9;
float minvMotor = 3;
float drawMotor = 1.4;
int motorSpeedValue = 0;
float currentvMotor = 0;

/* ------------------------- COLOR VARIABLE DECLARATION ---------------------- */


int background = color(30, 30, 70);
int panel = color(92, 108, 124);

int from = color(255, 0, 0);
int to = color(0, 120, 200);


int lightblue = #caf0f8;
int seablue = #90e0ef;
int blue = #00b4d8;
int deepblue = #0077b6;
int darkblue = #03045e;

int red = color(83, 32, 32);
int yellow = color(75, 83, 32);
int green = color(35, 83, 32);

int brightRed = color(255, 43, 37);
int brightYellow = color(255, 255, 37);
int brightGreen = color(58, 255, 37);



void setup() {

  size(1680, 720);



  printArray(Serial.list());

  /* ------------------------- SERIAL PORT ASSIGNMENT ---------------------- */


  port = new Serial(this, "COM4", 9600);

  cp5 = new ControlP5(this);
  font = createFont("calibri light", 20);


  /* ------------------------- LOAD IMAGES ---------------------- */


  carRender = loadImage("img/car_render.png");
  cargui = loadImage("img/cargui.png");
  left_button = loadImage("img/buttons/left_button.png");
  right_button = loadImage("img/buttons/right_button.png");
  hazard_button = loadImage("img/buttons/hazard_button.png");
  lights_button = loadImage("img/buttons/neutral_button.png");
  brake_button = loadImage("img/buttons/brake_button.png");
  motor_button = loadImage("img/buttons/motor_button.png");
  up_button = loadImage("img/buttons/up_button.png");
  down_button = loadImage("img/buttons/down_button.png");
  btemp_button = loadImage("img/buttons/btemp_button.png");
  mtemp_button = loadImage("img/buttons/mtemp_button.png");

  light_neutral = loadImage("img/lights/light_neutral.PNG");
  light_brake = loadImage("img/lights/light_brake.PNG");
  light_brake2 = loadImage("img/lights/light3_brake.PNG");
  light_turn = loadImage("img/lights/light_turn.PNG");


  brake_off = loadImage("img/icons/brake_off.png");
  brake_on = loadImage("img/icons/brake_on.png");
  motor_off = loadImage("img/icons/motor_off.png");
  motor_on = loadImage("img/icons/motor_on.png");
  neutral_off = loadImage("img/icons/neutral_off.png");
  neutral_on = loadImage("img/icons/neutral_on.png");
  left_off = loadImage("img/icons/left_off.png");
  left_on = loadImage("img/icons/left_on.png");
  right_off = loadImage("img/icons/right_off.png");
  right_on = loadImage("img/icons/right_on.png");
  btemp_off = loadImage("img/icons/btemp_off.png");
  btemp_on = loadImage("img/icons/btemp_on.png");
  mtemp_off = loadImage("img/icons/mtemp_off.png");
  mtemp_on = loadImage("img/icons/mtemp_on.png");
  hazard_off = loadImage("img/icons/hazard_off.png");
  hazard_on = loadImage("img/icons/hazard_on.png");


  /* ------------------------- IMAGE RESIZE ---------------------- */


  light_neutral.resize(50, 50);
  light_brake.resize(50, 50);
  light_brake2.resize(180, 50);
  light_turn.resize(50, 50);
  cargui.resize(160, 120);

  brake_off.resize(50, 50);
  brake_on.resize(50, 50);
  motor_off.resize(70, 70);
  motor_on.resize(70, 70);
  neutral_off.resize(50, 50);
  neutral_on.resize(50, 50);
  left_off.resize(50, 50);
  left_on.resize(50, 50);
  right_off.resize(50, 50);
  right_on.resize(50, 50);
  btemp_off.resize(70, 70);
  btemp_on.resize(70, 70);
  mtemp_off.resize(70, 70);
  mtemp_on.resize(70, 70);
  hazard_off.resize(50, 50);
  hazard_on.resize(50, 50);


  left_button.resize(180, 80);
  right_button.resize(180, 80);
  lights_button.resize(180, 80);
  brake_button.resize(180, 80);
  hazard_button.resize(360, 80);

  btemp_button.resize(70, 70);
  mtemp_button.resize(70, 70);
  motor_button.resize(70, 70);
  up_button.resize(70, 70);
  down_button.resize(70, 70);

  /* ------------------------- LIGHT BUTTONS ---------------------- */

  cp5.addButton("IntermitenteIZQ")
    .setImage(left_button)
    .setPosition(20, 60)
    .updateSize()
    .setFont(font)
    .setLabel("Intermitente \n    izquierdo")

    ;

  cp5.addButton("IntermitenteDER")
    .setImage(right_button)
    .setPosition(230, 60)
    .updateSize()
    .setFont(font)
    .setLabel("Intermitente \n     derecho");

  cp5.addButton("LUZFRENO")
    .setPosition(20, 150)
    .setImage(brake_button)
    .updateSize()
    .setFont(font)
    .setLabel("Luz de freno");

  cp5.addButton("LUZNEUTRAL")
    .setPosition(230, 150)
    .setImage(lights_button)
    .updateSize()
    .setFont(font)
    .setLabel("Luces");


  cp5.addButton("LUCESEMERGENCIA")
    .setPosition(30, 240)
    .setImage(hazard_button)
    .updateSize()
    .setFont(font)
    .setLabel("Luces de emergencia")

    ;


  /* ------------------------- MOTOR BUTTONS ---------------------- */

  cp5.addButton("MOTORONOFF")
    .setPosition(990, 20)
    .setImage(motor_button)
    .updateSize()
    .setFont(font)
    .setLabel("ON/OFF")

    ;


  cp5.addButton("MOTORDOWN")
    .setPosition(1150, y - 90)
    .setFont(font)
    .setImage(down_button)
    .updateSize()
    .setLabel("-");

  cp5.addButton("MOTORUP")
    .setPosition(1150, 20)
    .setFont(font)
    .setImage(up_button)
    .updateSize()
    .setLabel("+")

    ;

  /* ------------------------- TEMPERATURE BUTTONS ---------------------- */


  cp5.addButton("TEMPMOTOR")
    .setPosition(450, 20)
    .setImage(mtemp_button)
    .updateSize()
    .setFont(font)
    .setLabel("TM");

  cp5.addButton("TEMPBATERIA")
    .setPosition(450, 100)
    .setImage(btemp_button)
    .updateSize()
    .setFont(font)
    .setLabel("TB");

  /* ------------------------- TEMPERATURE KNOBS ---------------------- */


  motorTempKnob = cp5.addKnob("TEMPMOTORVIEW", 0, 60, 580, 65, 260);  // (valormin,valormax,posx,posy,radio);
  motorTempKnob.setOffsetAngle(PI - HALF_PI / 2);
  motorTempKnob.setValue(+motorTempKnob.value());
  motorTempKnob.setCaptionLabel("");

  batteryTempKnob = cp5.addKnob("TEMPBATTERYVIEW", 0, 60, 580, 400, 260);  // (valormin,valormax,posx,posy,radio);
  batteryTempKnob.setOffsetAngle(PI - HALF_PI / 2);
  batteryTempKnob.setCaptionLabel("");
}

void draw() {
  background(background);



  /* ------------------------- LIGHTS PANEL ---------------------- */
  fill(panel);
  rect(10, 10, 410, 330);


  fill(255, 255, 255);
  //title
  textFont(font);

  text("PANEL DE ILUMINACION", 120, 40);


  /* ------------------------- GENERAL PANEL ---------------------- */

  fill(panel);
  rect(10, 360, 410, 350);

  hour = hour();
  minute = minute();
  second = second();

  day = day();
  month = month();
  year = year();

  fill(255, 255, 255);
  textFont(font);

  text(hour, 30, 400);
  text(":", 55, 400);
  text(minute, 65, 400);
  text(":", 90, 400);
  text(second, 100, 400);

  text(day, 310, 400);
  text("/", 325, 400);
  text(month, 335, 400);
  text("/", 350, 400);
  text(year, 360, 400);

  image(left_off, 40, 450);
  image(right_off, 100, 450);
  image(neutral_off, 170, 450);
  image(hazard_off, 240, 450);
  image(brake_off, 320, 450);
  image(motor_off, 60, 530);
  image(btemp_off, 200, 530);
  image(mtemp_off, 290, 530);



  image(cargui, 20, 620);
  text("v 1.1.0", 350, 690);
  text("Sheila Martínez", 280, 670);

  /* ------------------------- TEMPERATURE PANEL ---------------------- */

  fill(panel);
  rect(440, 10, 530, y - 20);
  fill(255, 255, 255);
  text("T. MOTOR :", 600, 40);
  text("T. BATERÍA :", 590, 380);

  Controller cMotor = cp5.getController("TEMPMOTORVIEW");
  Controller cBattery = cp5.getController("TEMPBATTERYVIEW");

  color g1 = lerpColor(to, from, cMotor.getValue() / (60 - cMotor.getMin()));

  cMotor.setColorActive(g1);
  cMotor.setColorForeground(g1);

  cBattery.setColorActive(g1);
  cBattery.setColorForeground(g1);





  fill(255, 255, 255);
  if (port.available() > 0) {
    motorTemp = port.readStringUntil('M');
    if (motorTemp != null) {
      tempRealMotor = motorTemp.replaceAll("[^\\d.]", "");
      if (tempRealMotor.length() > 5)
        tempRealMotor = tempRealMotor.substring(0, 5);
    }
    if (tempRealMotor != null) {
      text(tempRealMotor, 700, 40);
      motorTempKnob.setValue(Float.parseFloat(tempRealMotor));
      if (float(tempRealBattery) > 40)
        image(mtemp_on, 60, 530);
    }
  }

  if (port.available() > 0) {
    batteryTemp = port.readStringUntil('B');
    if (batteryTemp != null) {
      tempRealBattery = batteryTemp.replaceAll("[^\\d.]", "");
      if (tempRealBattery.length() > 5)
        tempRealBattery = tempRealBattery.substring(0, 5);
    }
    if (tempRealBattery != null) {
      text(tempRealBattery, 700, 380);
      batteryTempKnob.setValue(Float.parseFloat(tempRealBattery));
      if (float(tempRealBattery) > 40)
        image(btemp_on, 60, 530);
    }
  }

  /* ------------------------- MOTOR PANEL ---------------------- */

  fill(92, 108, 124);
  rect(980, 10, 300, y - 20);
  if (motorSpeedValue == 0)
    currentvMotor = 0;
  else
    currentvMotor = minvMotor + ((maxvMotor - drawMotor - minvMotor) / 12) * motorSpeedValue;


  fill(255, 255, 255);
  text("Voltaje motor: ", 1010, 140);
  text(currentvMotor, 1070, 160);

  fill(red);
  rect(1150, 120, 70, 160);

  fill(yellow);
  rect(1150, 280, 70, 160);

  fill(green);
  rect(1150, 440, 70, 160);


  if (motorSpeedValue > 0) {
    if (motorSpeedValue < 4) {
      fill(brightGreen);
      rect(1150, 600 - (40 * motorSpeedValue), 70, 40 * motorSpeedValue);
    } else if (motorSpeedValue >= 4) {
      fill(brightGreen);
      rect(1150, 440, 70, 160);
    }
    if (motorSpeedValue >= 4 && motorSpeedValue < 9) {
      fill(brightYellow);
      rect(1150, 440 - (40 * (motorSpeedValue - 4)), 70, 40 * (motorSpeedValue - 4));
    } else if (motorSpeedValue >= 9) {
      fill(brightYellow);
      rect(1150, 280, 70, 160);
    }
    if (motorSpeedValue >= 9 && motorSpeedValue < 13) {
      fill(brightRed);
      rect(1150, 280 - 40 * (motorSpeedValue - 8), 70, 40 * (motorSpeedValue - 8));
    } else if (motorSpeedValue >= 9) {
      fill(brightRed);
      rect(1150, 120, 70, 160);
    }
  }


  line(1150, 120, 1220, 120);
  line(1150, 160, 1220, 160);
  line(1150, 200, 1220, 200);
  line(1150, 240, 1220, 240);
  line(1150, 280, 1220, 280);
  line(1150, 320, 1220, 320);
  line(1150, 360, 1220, 360);
  line(1150, 400, 1220, 400);
  line(1150, 440, 1220, 440);
  line(1150, 480, 1220, 480);
  line(1150, 520, 1220, 520);
  line(1150, 560, 1220, 560);
  line(1150, 600, 1220, 600);



  /* ------------------------- CAR PANEL ---------------------- */

  fill(52, 58, 74);
  rect(1290, 10, 380, y - 20);

  fill(255, 255, 255);
  image(carRender, 1330, 90);



  if (lightBrakeStatus > 0) {
    image(light_brake, 1400, 570);
    image(light_brake, 1515, 570);
    image(light_brake2, 1395, 467);
    image(brake_on, 320, 450);
  }

  if (lightTurnLStatus > 0 && lightEmerStatus == 0) {
    image(light_turn, 1370, 111);
    image(light_turn, 1370, 550);
    image(left_on, 40, 450);
  }

  if (lightTurnRStatus > 0 && lightEmerStatus == 0) {
    image(light_turn, 1540, 111);
    image(light_turn, 1545, 550);
    image(right_on, 100, 450);
  }

  if (lightEmerStatus > 0) {
    image(light_turn, 1370, 110);
    image(light_turn, 1540, 110);
    image(light_turn, 1370, 550);
    image(light_turn, 1545, 550);
    image(hazard_on, 240, 450);
  }


  if (lightNeutralStatus > 0) {
    image(light_neutral, 1390, 90);
    image(light_neutral, 1520, 90);
    image(neutral_on, 170, 450);
  }

  if (float(tempRealBattery) > 40)
    image(btemp_on, 60, 530);

  if (float(tempRealMotor) > 40)
    image(mtemp_on, 290, 530);

  if (motorSpeedValue > 10)
    image(motor_on, 60, 530);
}

/* ------------------------- SERIAL / STATUS FUNCTIONS ---------------------- */


void IntermitenteIZQ() {
  if (lightEmerStatus == 0) {
    port.write('l');
    if (lightTurnRStatus > 0)
      lightTurnRStatus = 0;
    lightTurnLStatus = (lightTurnLStatus + 1) % 2;
  }
}

void IntermitenteDER() {
  if (lightEmerStatus == 0) {
    if (lightTurnLStatus > 0)
      lightTurnLStatus = 0;
    port.write('r');
    lightTurnRStatus = (lightTurnRStatus + 1) % 2;
  }
}

void LUCESEMERGENCIA() {
  port.write('e');
  lightEmerStatus = (lightEmerStatus + 1) % 2;
}

void LUZFRENO() {
  port.write('b');
  lightBrakeStatus = (lightBrakeStatus + 1) % 2;
}

void LUZNEUTRAL() {
  port.write('n');
  lightNeutralStatus = (lightNeutralStatus + 1) % 2;
}

void TEMPMOTOR() {
  port.write('m');
}


void TEMPBATERIA() {
  port.write('q');
}

void MOTORONOFF() {
  port.write('M');
}

void MOTORUP() {
  if (motorSpeedValue < 12) {
    port.write('+');
    motorSpeedValue += 1;
  }
}

void MOTORDOWN() {
  if (motorSpeedValue > 0) {
    port.write('-');
    motorSpeedValue -= 1;
  }
}

/* ------------------------- KNOB FUNCTIONS ---------------------- */


void knob(int theValue) {
  motorTempKnob.setLabel("" + theValue);
  println("a knob event. setting background to " + theValue);
}

void knobValue(int theValue) {
  batteryTempKnob.setLabel("" + theValue);
}
