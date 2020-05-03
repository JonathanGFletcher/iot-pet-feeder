#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <cstring>
#include <SPI.h>
#include <MFRC522.h>
#include <Servo.h>
//API Data

//ID (String)
//feederId (String)
//feedOverride (int)
//feedCount (int)
//currentTime (int)
//numberOfFeedTimes (int)
//feedTimes (string)

// WiFi Parameters
const char* ssid = "Jonny\'s WiFi";
const char* password = "Cec2d7718881cd465c97*";
const char* deviceId = "ec0046dc-001b-48bf-057f-08d7ef9b3acb";
const char* siteAddress = "https://iotpetfeederdatamanager.azurewebsites.net/";
const char* bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Impvbm55LmZsZXRjaGVyQGljbG91ZC5jb20iLCJyb2xlIjoiQWRtaW4iLCJuYmYiOjE1ODgxOTc2NTUsImV4cCI6MTYwNDAwODg1NSwiaWF0IjoxNTg4MTk3NjU1fQ.W08Q_1LQxwm-VidQuTr63lovp5Jeub97oUdSmvlEk-U"; // must add token

// JSON
String jsonPayload = "";
StaticJsonDocument<500> jsonDoc;

// Globals for Feeder Data
String id = "";
String feederId = "";
int feedOverride = 0;
int feedCount = 0;
int currentTime = 0;
int numberOfFeedTimes = 0;
int feedTimes[20];

// Other Globals
int apiFetchPeriod = 10000; // 10 seconds
unsigned long timeNow = 0;
int readyToFeed = 0;

// Prototypes
bool getFeederData(String&); // Returns success
bool updateAPI(); // Returns success
bool parseJsonPayload(String&); // Returns success
String createJsonString(); // Returns JSON string
void releaseFeed();

// define servo, RFID
#define SS_PIN 10
#define RST_PIN 9
MFRC522 mfrc522 (SS_PIN, RST_PIN);    //create instance for mfrc522
Servo myServo;                      //define servo name

// Pins
int servoPin = 99;

//-----------------------------------------------------------------------------------
//    Setup
//-----------------------------------------------------------------------------------

void setup() {

  // Setup Pins
  

  // Start printing out to serial console
  Serial.begin(115200);
  SPI.begin();                                //Initiate SPI bus
  mfrc522.PCD_Init();                         //initiate MFRC522
  myServo.attach(3);                          //servo pin
  myServo.write(0);                           //servo's start position

  // Connect to Wi-Fi
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {

    delay(500);
    Serial.print(".");
  }
  Serial.println("Approximate your card to the reader...");
  Serial.println();
  Serial.println("");
  Serial.println("WiFi connected.");
}

//-----------------------------------------------------------------------------------
//    Loop
//-----------------------------------------------------------------------------------

void loop() {

  // Check if WiFi is connected
  if (WiFi.status() == WL_CONNECTED) {

    // Loops every apiFetchPeriod (10 seconds)
    if (millis() >= timeNow + apiFetchPeriod) {

      // Update time interval for GET cycle
      timeNow += apiFetchPeriod;

      // Get Feeder Data
      if (getFeederData(jsonPayload)) {

        // Parse JSON Payload
        if (parseJsonPayload(jsonPayload)) {
          
          if (feedOverride == 0) {
              
            for (int i = 0; i < numberOfFeedTimes; i++) {

              if (currentTime > feedTimes[i]) {

                if (!readyToFeed) {

                  feedTimes[i] += 86400; // Add 24 hours

                  updateAPI();

                  readyToFeed = 1;
                }
              }
            }
          }
          else {

            readyToFeed = 1;
            feedOverride = 0;

            updateAPI();
          }
        }
      }
    }
  }

  // ***Needs Work*** Here you need to put the code for RFID detection which will then
  //                  trigger the releaseFeed() (if readyToFeed == true)
  //                  Also once the feed is release here you must set readyToFeed to false
  //                  and also do feedCount++ (increment by 1) and call updateAPI()

  //look for new cards
  if (! mfrc522.PICC_IsNewCardPresent()) {
    return;
  }
  //select one of the cards
  if (! mfrc522.PICC_ReadCardSerial()) {
    return;
  }
  //show UID on serial monitor
  Serial.print("UID tag: ");
  String content = "";
  byte letter;
  for (byte i = 0; i < mfrc522.uid.size; i++) {
    Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");                //dump out the info (UID) of the card
    Serial.print(mfrc522.uid.uidByte[i], HEX);
    content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
    content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  Serial.println();
  Serial.print("Message : ");
  content.toUpperCase();
  if (content.substring(1) == " ")       //put the UID in the ""
  {
    Serial.println("Authorized access");
    Serial.println();
    delay(1000);
    if (readyToFeed == 1) {
      releaseFeed();                      //triggers servo
      readyToFeed = 0;                    //sets the variable to false
      feedCount++;                        //counts how many times the pet has been fed
      updateAPI();                        //update the API
    }
  }
  else {
    Serial.println(" Access denied");
    delay(1000);
  }

}

//-----------------------------------------------------------------------------------
//    Get Feeder Data
//-----------------------------------------------------------------------------------

bool getFeederData(String& payload) {

  // Intialize HTTP object
  HTTPClient http;

  // Setting address for request
  String addressString = siteAddress;
  addressString += "api/feeders/";
  addressString += deviceId;
  http.begin(addressString);

  // Add authorization header to request
  String bearerHeader = "bearer ";
  bearerHeader += bearerToken;
  http.addHeader("Authorization", bearerHeader);

  int httpResponseCode = http.GET();

  payload = http.getString();

  http.end();

  if (httpResponseCode == 200) {

    Serial.println(payload);
    return true;
  }
  else {

    return false;
  }
}

//-----------------------------------------------------------------------------------
//    Update API
//-----------------------------------------------------------------------------------

bool updateAPI() {

  // Intialize HTTP object
  HTTPClient http;

  // Setting address for request
  String addressString = siteAddress;
  addressString += "api/feeders/";
  addressString += id;
  http.begin(addressString);
  // Add authorization header to request
  String bearerHeader = "bearer ";
  bearerHeader += bearerToken;
  http.addHeader("Authorization", bearerHeader);
  // Add content type header to request
  http.addHeader("Content-Type", "application/json");

  int httpResponseCode = http.PUT(createJsonString());

  http.end();

  if (httpResponseCode == 200) {

    return true;
  }
  else {

    return false;
  }
}

//-----------------------------------------------------------------------------------
//    Parse JSON Payload
//-----------------------------------------------------------------------------------

bool parseJsonPayload(String& payload) {

  DeserializationError error = deserializeJson(jsonDoc, payload);

  if (error) {

    return false;
  }

  String newId = jsonDoc["id"];
  String newFeederId = jsonDoc["feederId"];
  int newFeedOverride = jsonDoc["feedOverride"];
  int newFeedCount = jsonDoc["feedCount"];
  int newCurrentTime = jsonDoc["currentTime"];
  int newNumberOfFeedTimes = jsonDoc["numberOfFeedTimes"];
  String newFeedTimesString = jsonDoc["feedTimes"];

  id = newId;
  feederId = newFeederId;
  feedOverride = newFeedOverride;
  feedCount = newFeedCount;
  currentTime = newCurrentTime;
  numberOfFeedTimes = newNumberOfFeedTimes;

  // Converting newFeedTimesString to feedTimes array

  int timeCounter = 0;

  char* newTime;
  newTime = strtok(strdup(newFeedTimesString.c_str()), ",");

  while (newTime != NULL) {

    int parsedTime = atoi(newTime);
    feedTimes[timeCounter] = parsedTime;

    timeCounter++;

    newTime = strtok(NULL, ",");
  }

  return true;
}

//-----------------------------------------------------------------------------------
//    Create JSON String
//-----------------------------------------------------------------------------------

String createJsonString() {

  String jsonString = "";

  jsonString += "{\"id\":\"";
  jsonString += id;
  jsonString += "\",\"feederId\":\"";
  jsonString += feederId;
  jsonString += "\",\"feedOverride\":";
  jsonString += feedOverride;
  jsonString += ",\"feedCount\":";
  jsonString += feedCount;
  jsonString += ",\"currentTime\":0,\"numberOfFeedTimes\":";
  jsonString += numberOfFeedTimes;
  jsonString += ",\"feedTimes\":\"";

  for (int i = 0; i < numberOfFeedTimes; i++) {

    if (i != 0) {

      jsonString += ",";
    }

    jsonString += feedTimes[i];
  }

  jsonString += "\"}";

  return jsonString;
}

//-----------------------------------------------------------------------------------
//    Release Feed
//-----------------------------------------------------------------------------------

void releaseFeed() {

  int releasePeriod = 10000;
  unsigned long releaseTimeNow = 0;

  // ***Needs Work*** This function will activate the servo
  myServo.write(180);           //rotates 180 degrees

  while (millis() <= timeNow + releaseTimeNow + releasePeriod) {}

  myServo.write(0);             //servo turns back to its original position
}
