import controlP5.*;
import processing.serial.*;

Serial port;

ControlP5 cp5;

Knob motorTempKnob;
Knob batteryTempKnob;


PFont font;

PImage carRender;
PImage light_brake;
PImage light_brake2;
PImage light_neutral;
PImage light_turn;

int x = 1280;
int y = 720;

String batteryTemp;
String motorTemp;

String tempRealBattery ="1";
String tempRealMotor = "1";

int lightNeutralStatus = 0;
int lightBrakeStatus = 0;
int lightTurnLStatus = 0;
int lightTurnRStatus = 0;
int lightEmerStatus = 0;

int from = color(255,0,0);
int to = color(0,120,200);



void setup(){

  size(1680,720);



  printArray(Serial.list()); 
  
  port = new Serial(this, "COM4", 9600);
  
  cp5 = new ControlP5(this);
  font = createFont("calibri light", 20);
  
  carRender = loadImage("img/car_render.png");
  light_neutral = loadImage("img/light_neutral.PNG");
  light_brake = loadImage("img/light_brake.PNG");
  light_brake2 = loadImage("img/light3_brake.PNG");
  light_turn = loadImage("img/light_turn.PNG");

  light_neutral.resize(50,50);
  light_brake.resize(50,50);
  light_brake2.resize(180,50);
  light_turn.resize(50,50);
    

  
  
  // LUCES
    
  cp5.addButton("IntermitenteIZQ")
    .setPosition(20,50)
    .setSize(180,80)
    .setFont(font)
    .setLabel("Intermitente \n    izquierdo")

  ;
  
  cp5.addButton("IntermitenteDER")
    .setPosition(230,50)
    .setSize(180,80)
    .setFont(font)
    .setLabel("Intermitente \n     derecho")
  ;
  

  cp5.addButton("LUCESEMERGENCIA")
    .setPosition(20,230)
    .setSize(390,80)
    .setFont(font)
    .setLabel("Luces de emergencia")

  ;


  cp5.addButton("LUZFRENO")
    .setPosition(20,140)
    .setSize(180,80)
    .setFont(font)
    .setLabel("Luz de freno")
  ;

  cp5.addButton("LUZNEUTRAL")
    .setPosition(230,140)
    .setSize(180,80)
    .setFont(font)
    .setLabel("Luces")
  ;


// MOTOR 

  cp5.addButton("ONOFF")
    .setPosition(450, y-350)
    .setSize(70, 70)
    .setFont(font)
    .setLabel("ON/OFF")
    
  ;


  cp5.addButton("DOWN")
    .setPosition (480, y - 100)
    .setFont(font)
    .setImage(loadImage("img/down_motor.png"))

    .setLabelVisible(false)
    
   ;
   
  cp5.addButton("UP")
    .setPosition (1175, y - 100)
    .setFont(font)
    .setImage(loadImage("img/up_motor.png"))

    .setLabelVisible(false)
    
   ;


  cp5.addButton("TEMPMOTOR")
    .setPosition (530, y-350)
    .setSize(70,70)
    .setFont(font)
    .setLabel("TM")
    ;
    
/*
  cp5.addButton("TEMPBATERIA")
    .setPosition (610, y-350)
    .setSize(70,70)
    .setFont(font)
    .setLabel("TB")
    ;
  */  
    

  motorTempKnob = cp5.addKnob("TEMPMOTORVIEW",0,90,690,50,220); // (valormin,valormax,posx,posy,radio);
  motorTempKnob.setOffsetAngle(PI - HALF_PI/2);
  motorTempKnob.setValue(+motorTempKnob.value());
  motorTempKnob.setCaptionLabel("");

  batteryTempKnob = cp5.addKnob("TEMPMBATTERYVIEW",0,90,1000,50,220); // (valormin,valormax,posx,posy,radio);
  batteryTempKnob.setOffsetAngle(PI - HALF_PI/2);
  //batteryTempKnob.setValue(+batteryTempKnob.value());
  batteryTempKnob.setCaptionLabel("");


}

void draw(){
  background(112,128,144);



  //PANEL LUCES
  fill(92,108,124);
  rect(10,10, 410, 330);


  fill(255,255,255);
  //title
  textFont(font);
      
  text("PANEL DE ILUMINACION", 120, 40);


//PANEL BATERIA
  fill(92,108,124);
  rect(10,360, 410, 350);


  fill(255,255,255);
  //title
  textFont(font);
      
  text("PANEL DE BATERIA", 120, 390);

fill(35, 83, 32);
rect(75,440, 30, 20);
rect(50,465, 80, 15);
rect(50,485, 80, 15);

fill(75, 83, 32);
rect(50,505, 80, 15);
rect(50,525, 80, 15);
rect(50,545, 80, 15);

fill(83, 32, 32);
rect(50,565, 80, 15);
rect(50,585, 80, 15);
rect(50,605, 80, 15);

fill(255,255,255);
text("xx%",75,650);

text("Voltaje del sistema", 175, 460);
text("xV", 360, 460);


text("Consumo instantáneo", 175, 510);
text("xA", 360, 510);

text("Autonomía", 230, 580);
text("xh y xm", 240,610);


// PANEL AVISOS
  fill(92,108,124);
  rect(440,10, x-1080, 330);



//PANEL TEMPERATURA
  fill(92,108,124);
  rect(x-620,10, 610, 330);

  Controller c = cp5.getController("TEMPMOTORVIEW");
  color g1 = lerpColor(to, from, c.getValue()/(60-c.getMin()));
  c.setColorActive(g1);
  c.setColorForeground(g1);






  
  
  fill(255,255,255);
if(port.available()>0)
{
  motorTemp = port.readStringUntil('M');
  if(motorTemp != null){
    tempRealMotor = motorTemp.replaceAll("[^\\d.]","");
    if(tempRealMotor.length() > 5)
      tempRealMotor = tempRealMotor.substring(0, 5);
   }
    text(tempRealMotor, x-600, 30);
    motorTempKnob.setValue(Float.parseFloat(tempRealMotor));    
}

if(port.available()>0)
{
  batteryTemp = port.readStringUntil('B');
  if(batteryTemp != null){
    tempRealBattery = batteryTemp.replaceAll("[^\\d.]","");
    if(tempRealBattery.length() > 5)
      tempRealBattery = tempRealBattery.substring(0, 5);
   }
    text(tempRealMotor, x-600, 30);
    motorTempKnob.setValue(Float.parseFloat(tempRealMotor));    
}
  
//PANEL DE MOTOR
  fill(92,108,124);
  rect(440,360, x-450, 350);

  fill(255,255,255);
  text("Voltaje motor: ",770,y-120);
  text("x.xV ",900,y-120);
fill(35, 83, 32);  //green
rect(555,y-98, 25,55);
rect(575,y-98, 25,55);
rect(595,y-98, 25,55);
rect(615,y-98, 25,55);
rect(635,y-98, 25,55);
rect(655,y-98, 25,55);
rect(675,y-98, 25,55);
rect(695,y-98, 25,55);
rect(715,y-98, 25,55);
rect(735,y-98, 25,55);
fill(75, 83, 32);  //yellow
rect(755,y-98, 25,55);
rect(775,y-98, 25,55);
rect(795,y-98, 25,55);
rect(815,y-98, 25,55);
rect(835,y-98, 25,55);
rect(855,y-98, 25,55);
rect(875,y-98, 25,55);
rect(895,y-98, 25,55);
rect(915,y-98, 25,55);
rect(935,y-98, 25,55);

fill(83, 32, 32);  //red
rect(955,y-98, 25,55);
rect(975,y-98, 25,55);
rect(995,y-98, 25,55);
rect(1015,y-98, 25,55);
rect(1035,y-98, 25,55);
rect(1055,y-98, 25,55);
rect(1075,y-98, 25,55);
rect(1095,y-98, 25,55);
rect(1115,y-98, 25,55);
rect(1135,y-98, 25,55);

//PANEL COCHE
  fill(52,58,74);
rect(1290, 10, 380, y- 20);

fill(255,255,255);
image(carRender, 1330, 90);



  if(lightBrakeStatus > 0){
    image(light_brake, 1400, 570);
    image(light_brake, 1515, 570);
    image(light_brake2, 1395, 467);  
  }

  if (lightTurnLStatus > 0 && lightEmerStatus == 0){
      image(light_turn, 1370, 111);
      image(light_turn, 1370, 550);

  }  
  
  if (lightTurnRStatus > 0 && lightEmerStatus == 0){
    image(light_turn, 1540, 111);
    image(light_turn, 1545, 550);  

  }
  
   if (lightEmerStatus > 0){
    image(light_turn, 1370, 110);
    image(light_turn, 1540, 110);
    image(light_turn, 1370, 550);
    image(light_turn, 1545, 550);  

  }
  

  if (lightNeutralStatus > 0){
      image(light_neutral, 1390, 90);
      image(light_neutral, 1520, 90);
  
}


}



void IntermitenteIZQ()
{
  if(lightEmerStatus == 0){
    port.write('l');
  if(lightTurnRStatus > 0)
      lightTurnRStatus = 0;
    lightTurnLStatus = (lightTurnLStatus + 1) % 2 ;  
  }
}

void IntermitenteDER()
{
  if(lightEmerStatus == 0){
  if(lightTurnLStatus > 0)
    lightTurnLStatus = 0;
    port.write('r');
    lightTurnRStatus = (lightTurnRStatus + 1) % 2 ;  
  }
   
}

void LUCESEMERGENCIA()
{
  port.write('e');
  lightEmerStatus = (lightEmerStatus + 1) % 2 ;  
  
}

void LUZFRENO()
{
  port.write('b');
  lightBrakeStatus = (lightBrakeStatus + 1) % 2 ;  

}

void LUZNEUTRAL()
{
  port.write('n');
  lightNeutralStatus = (lightNeutralStatus + 1) % 2 ;  

}

void TEMPMOTOR()
{
  port.write('m');
}


void knob(int theValue) {
  motorTempKnob.setLabel(""+theValue);
  println("a knob event. setting background to "+theValue);
}

void knobValue(int theValue) {
  batteryTempKnob.setLabel(""+theValue);
}
