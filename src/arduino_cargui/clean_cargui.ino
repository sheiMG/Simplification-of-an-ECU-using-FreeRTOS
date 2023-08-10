#include <Arduino_FreeRTOS.h>
#include <queue.h>
#include <semphr.h>


/* ------------------------PIN NUMBER DECLARATION---------------------------*/
const int sensorMPIN = A0;
const int sensorBPIN = A1;

const int turnLPIN = 22;
const int turnRPIN = 23;

const int brakePIN = 25;

const int neutralLPIN = 30;
const int neutralRPIN = 31;

const int in1ML = 9;
const int in2ML = 8;
const int comML = 13;

const int in1MR = 11;
const int in2MR = 10;
const int comMR = 12;

/* ---------------------- TEMPERATURE VARIABLES DECLARATION -----------------------------*/

const int Rc = 10000;  // resistance value
const int Vcc = 5;     // voltage value
const float A = 1.11492089e-3;
const float B = 2.372075385e-4;
const float C = 6.954079529e-8;
const float K = 2.5;  //f Disipation constant in mW/C

int motorSensorValue = 0;

/* ------------------------ FREERTOS TASK INITIALIZATION ---------------------------*/

static void TaskTurnSignal(int dir);
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

/* ------------------------ SETUP FUNCTION (only runs once) ---------------------------*/


void setup() {
  Serial.begin(9600);

  /* ------------------------QUEUE ASSIGNMENT FOR TEMPERATURES ---------------------------*/


  tempM_queue = xQueueCreate(3, sizeof(float));
  if (tempM_queue == NULL) {
    Serial.println("Botor Temperature queue can not be created");
  }

  tempB_queue = xQueueCreate(3, sizeof(float));
  if (tempB_queue == NULL) {
    Serial.println("Battery temperature queue can not be created");
  }

  /* ------------------------SEMAPHORE ASSIGNMENT FOR TEMPERATURES ---------------------------*/


  if (pserial_semaphore == NULL) {
    pserial_semaphore = xSemaphoreCreateMutex();
    if (pserial_semaphore != NULL)
      xSemaphoreGive(pserial_semaphore);
  }

  /* ------------------------FREERTOS TASK CREATION ---------------------------*/


  xTaskCreate(
    TaskSerialValue,
    "TaskSerialValue",
    128,
    NULL,
    1,
    &taskvserial_handle);

  xTaskCreate(
    TaskReadTemp,
    "TaskReadTemperature",
    200,
    'm',
    4,
    NULL);

  xTaskCreate(
    TaskReadTemp,
    "TaskReadTemperature",
    200,
    'b',
    4,
    NULL);

  /* ------------------------START FREERTOS SCHEDULER ---------------------------*/

  vTaskStartScheduler();
}

/* ------------------------ LOOP FUNCTION (empty because of freertos rules) ---------------------------*/


void loop() {}

/* ------------------------ TURN SIGNAL FUNCTION ---------------------------*/
/* @dir : right or left turn signal PIN                                     */


static void TaskTurnSignal(int dir) {
  pinMode(dir, OUTPUT);

  for (;;) {

    digitalWrite(dir, HIGH);
    vTaskDelay(200 / portTICK_PERIOD_MS);
    digitalWrite(dir, LOW);
    vTaskDelay(200 / portTICK_PERIOD_MS);
  }
}

/* ------------------------ HAZARD LIGHTS FUNCTION ---------------------------*/

void taskHazardLights(void *pvParameters) {
  pinMode(turnLPIN, OUTPUT);
  pinMode(turnRPIN, OUTPUT);

  for (;;) {
    digitalWrite(turnLPIN, HIGH);
    digitalWrite(turnRPIN, HIGH);
    vTaskDelay(200 / portTICK_PERIOD_MS);
    digitalWrite(turnLPIN, LOW);
    digitalWrite(turnRPIN, LOW);
    vTaskDelay(200 / portTICK_PERIOD_MS);
  }
}

/* ------------------------ BRAKE LIGHTS FUNCTION ---------------------------*/


void TaskBrakeLight(void *pvParameters) {
  pinMode(brakePIN, OUTPUT);
  digitalWrite(brakePIN, HIGH);
  for (;;) {}
}


/* ------------------------ NEUTRAL LIGHTS FUNCTION ---------------------------*/

void TaskNeutralLight(void *pvParameters) {
  pinMode(neutralLPIN, OUTPUT);
  pinMode(neutralRPIN, OUTPUT);
  digitalWrite(neutralLPIN, HIGH);
  digitalWrite(neutralRPIN, HIGH);
  for (;;) {}
}

/* ------------------------ SERIAL VALUE TASK ---------------------------*/


void TaskSerialValue(void *pvParameters) {

  char value_serial;

  int brakeStatus = 0;
  int emerStatus = 0;
  int neutralStatus = 0;
  int mTempStatus = 0;
  int bTempStatus = 0;
  int turnLStatus = 0;
  int turnRStatus = 0;
  int motorStatus = 0;
  char type;

  for (;;) {

    // READ FROM SERIAL SECURED BY MUTEX

    if (xSemaphoreTake(pserial_semaphore, (TickType_t)5) == pdTRUE) {
      value_serial = Serial.read();
      xSemaphoreGive(pserial_semaphore);
      vTaskDelay(20 / portTICK_PERIOD_MS);
    }

    vTaskDelay(1);

    // read value_serial to know what button was clicked in processing

    switch (value_serial) {
      case 'l':
        if (turnLStatus == 0) {
          if (turnRStatus == 1) {
            vTaskDelete(taskturn_handle);
            digitalWrite(turnRPIN, LOW);
            turnRStatus = 0;
          }
          xTaskCreate(TaskTurnSignal, "TaskTurn", 50, turnLPIN, 1, &taskturn_handle);
        } else {
          vTaskDelete(taskturn_handle);
          digitalWrite(turnLPIN, LOW);
        }
        turnLStatus = (turnLStatus + 1) % 2;
        break;

      case 'r':
        if (turnRStatus == 0) {
          if (turnLStatus == 1) {
            vTaskDelete(taskturn_handle);
            digitalWrite(turnLPIN, LOW);
            turnLStatus = 0;
          }
          xTaskCreate(TaskTurnSignal, "TaskTurn", 50, turnRPIN, 1, &taskturn_handle);
        } else {
          vTaskDelete(taskturn_handle);
          digitalWrite(turnRPIN, LOW);
        }
        turnRStatus = (turnRStatus + 1) % 2;
        break;


      case 'e':
        if (emerStatus == 0) {
          if (turnLStatus == 1 || turnRStatus == 1)
            vTaskSuspend(taskturn_handle);

          xTaskCreate(taskHazardLights, "TaskHazardLights", 128, NULL, 2, &taskemer_handle);
        } else {
          vTaskDelete(taskemer_handle);
          vTaskResume(taskturn_handle);
          digitalWrite(turnLPIN, LOW);
          digitalWrite(turnRPIN, LOW);
        }
        emerStatus = (emerStatus + 1) % 2;
        break;


      case 'b':
        if (brakeStatus == 0)
          xTaskCreate(TaskBrakeLight, "TaskBrakeLights", 128, NULL, 1, &taskbrake_handle);
        else {
          vTaskDelete(taskbrake_handle);
          digitalWrite(brakePIN, LOW);
        }
        brakeStatus = (brakeStatus + 1) % 2;
        break;


      case 'n':
        if (neutralStatus == 0)
          xTaskCreate(TaskNeutralLight, "TaskNeutralLight", 128, NULL, 1, &taskneutral_handle);
        else {
          vTaskDelete(taskneutral_handle);
          digitalWrite(neutralLPIN, LOW);
          digitalWrite(neutralRPIN, LOW);
        }
        neutralStatus = (neutralStatus + 1) % 2;
        break;

      case 'm':
        type = 'm';
        if (mTempStatus == 0)
          xTaskCreate(TaskWriteTemp, "TaskWriteTemperature", 128, type, 1, &taskmtemp_handle);
        else
          vTaskDelete(taskmtemp_handle);
        mTempStatus = (mTempStatus + 1) % 2;
        break;

      case 'q':
        type = 'b';
        if (bTempStatus == 0)
          xTaskCreate(TaskWriteTemp, "TaskWriteTemperature", 128, type, 1, &tasbtemp_handle);
        else
          vTaskDelete(tasbtemp_handle);
        bTempStatus = (bTempStatus + 1) % 2;
        break;

      case 'M':
        if (motorStatus == 0)
          xTaskCreate(TaskMotorSpeed, "TaskMotorSpeed", 128, NULL, 1, &tasksmotor_handle);
        else {

          vTaskDelete(tasksmotor_handle);

          digitalWrite(in1ML, LOW);
          digitalWrite(in1MR, LOW);
          digitalWrite(in2ML, LOW);
          digitalWrite(in2MR, LOW);
          analogWrite(comML, 0);
          analogWrite(comMR, 0);
        }
        motorStatus = (motorStatus + 1) % 2;
        break;

      case '+':
        motorSensorValue += 1;
        break;

      case '-':
        motorSensorValue -= 1;
        break;
    }

    value_serial = ' ';
  }
}

/* ------------------------ READ TEMPERATURE TASK ---------------------------*/


void TaskReadTemp(char type) {
  float temp_now = 0.0;
  float raw;
  while (1) {

    if (type == 'm') {
      temp_now = getTemp(raw, sensorMPIN);
      xQueueSend(tempM_queue, &temp_now, portMAX_DELAY);
    }

    if (type == 'b') {
      temp_now = getTemp(raw, sensorBPIN);
      xQueueSend(tempB_queue, &temp_now, portMAX_DELAY);
    }
  }
}

/* ------------------------ WRITE TEMPERATURE TASK ---------------------------*/


void TaskWriteTemp(char type) {
  float temp = 0.0;
  String tempMValue;
  String tempBValue;

  for (;;) {
    if (type == 'm')
      if (xQueueReceive(tempM_queue, &temp, portMAX_DELAY) == pdTRUE) {
        tempMValue = String(temp) + "M";

        if (xSemaphoreTake(pserial_semaphore, (TickType_t)5) == pdTRUE) {
          Serial.println(tempMValue);
          xSemaphoreGive(pserial_semaphore);
        }
        vTaskDelay(1);
      }

    if (type == 'b')
      if (xQueueReceive(tempB_queue, &temp, portMAX_DELAY) == pdTRUE) {
        tempBValue = String(temp) + "B";

        if (xSemaphoreTake(pserial_semaphore, (TickType_t)5) == pdTRUE) {
          Serial.println(tempBValue);
          xSemaphoreGive(pserial_semaphore);
        }
        vTaskDelay(1);
      }
  }
}

/* ------------------------ MOTOR SPEED TASK ---------------------------*/

void TaskMotorSpeed(void *pvParameters) {
  pinMode(in1ML, OUTPUT);
  pinMode(in2ML, OUTPUT);
  pinMode(comML, OUTPUT);
  pinMode(in1MR, OUTPUT);
  pinMode(in2MR, OUTPUT);
  pinMode(comMR, OUTPUT);

  digitalWrite(in1ML, LOW);
  digitalWrite(in2ML, HIGH);
  digitalWrite(in1MR, LOW);
  digitalWrite(in2MR, HIGH);
  for (;;) {
    if (motorSensorValue == 0) {
      analogWrite(comML, 0);
      analogWrite(comMR, 0);

    } else {
      analogWrite(comML, 100 + 12 * motorSensorValue);
      analogWrite(comMR, 100 + 12 * motorSensorValue);
    }
  }
}

/* ------------------------ GET TEMPERATURE FUNCTION ---------------------------*/

float getTemp(float raw, char *port) {
  float rawT = analogRead(port);
  float V = rawT / 1024 * Vcc;

  float R = (Rc * V) / (Vcc - V);


  float logR = log(R);
  float R_th = 1.0 / (A + B * logR + C * logR * logR * logR);

  float kelvin = R_th - V * V / (K * R) * 1000;
  float celsius = kelvin - 273.15;

  return celsius;
}