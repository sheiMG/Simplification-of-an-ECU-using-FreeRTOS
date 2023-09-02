//cargui.h

#ifndef _CARGUI_H
#define _CARGUI_H

#include <Arduino_FreeRTOS.h>
#include <queue.h>
#include <semphr.h>


/* ------------------------PIN NUMBER DECLARATION---------------------------*/
const int sensorMPIN = A1;
const int sensorBPIN = A0;

const int turnLFPIN = 29;
const int turnLRPIN = 25;
const int turnRFPIN = 27;
const int turnRRPIN =22;

const int brakeLPIN = 24;
const int brakeRPIN = 23;

const int neutralLPIN = 28;
const int neutralRPIN = 26;

const int in1ML = 6;
const int in2ML = 5;
const int comML = 7;

const int in1MR = 9;
const int in2MR = 8;
const int comMR = 10;

/* ---------------------- TEMPERATURE VARIABLES DECLARATION -----------------------------*/

const int Rc = 10000;  // resistance value
const int Vcc = 5;     // voltage value
const float A = 1.11492089e-3;
const float B = 2.372075385e-4;
const float C = 6.954079529e-8;
const float K = 2.5;  //f Disipation constant in mW/C

int motorSensorValue = 0;

/* ------------------------ FREERTOS TASK INITIALIZATION ---------------------------*/

static void TaskTurnSignal(char dir);
void taskHazardLights(void *pvParameters);
void TaskBrakeLight(void *pvParameters);
void TaskSerialValue(void *pvParameters);
void TaskNeutralLight(void *pvParameters);

void TaskMotorSpeed(void *pvParameters);

void TaskReadTemp(char type);
void TaskWriteTemp(char type);
float getTemp(float raw);

/* ------------------------FREERTOS SEMAPHORE DECLARATION ---------------------------*/

SemaphoreHandle_t pserial_semaphore;

/* ------------------------FREERTOS QUEUE DECLARATION ---------------------------*/


QueueHandle_t tempM_queue;
QueueHandle_t tempB_queue;

/* ------------------------FREERTOS QUEUE DECLARATION ---------------------------*/


TaskHandle_t taskturn_handle = NULL;
TaskHandle_t taskemer_handle = NULL;
TaskHandle_t taskbrake_handle = NULL;
TaskHandle_t taskneutral_handle = NULL;
TaskHandle_t taskvserial_handle = NULL;
TaskHandle_t taskmtemp_handle = NULL;
TaskHandle_t tasbtemp_handle = NULL;
TaskHandle_t tasksmotor_handle = NULL;



#endif