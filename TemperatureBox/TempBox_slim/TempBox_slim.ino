  #include <LiquidCrystal.h>
  LiquidCrystal lcd(53, 52, 51, 50, 49, 48);
  
  int TempPin = A0;
 // int PotPin = A10;
  
  int ENAheat = 5;
  int ENBcool = 10;
  int IN1heat = 6;
  int IN2heat = 7;
  int IN3cool = 8;
  int IN4cool = 9;
  
  int cooler = 0;
  int heater = 0;
  
  float tempout;
  float temp;
  float t;
  float sysinput = 0;

  int n = 2; //number of setpoints
  int sparray[2][2] = { // don't change array dimension
 {24,29},
 {150,500}  };
  int setpoint;
  int i = 0;
  int tspc = sparray[1][0];

// variables for MiniOS
unsigned long lastTime1s;
unsigned long lastTime5s;
unsigned long lastTime10s;

void setup() {
  lcd.begin(16,2);
  
  pinMode(ENAheat,OUTPUT); //heater
  pinMode(IN1heat,OUTPUT); //heater
  pinMode(IN2heat,OUTPUT); //heater
  pinMode(ENBcool,OUTPUT); //cooler
  pinMode(IN3cool,OUTPUT); //cooler
  pinMode(IN4cool,OUTPUT); //cooler
  
  pinMode(TempPin,INPUT);

  Serial.begin(9600);

//--------- heater off ---------
analogWrite(ENAheat,0);
digitalWrite(IN1heat,LOW);
digitalWrite(IN2heat,LOW);
//-----------------------------

//--------- cooler off ---------
analogWrite(ENBcool,150);
digitalWrite(IN3cool,LOW); //HIGH --> set to HIGH to turn on cooler (just one direction possible)
digitalWrite(IN4cool,LOW);
//-----------------------------
}


void loop() {
  unsigned long currentTime = millis();

  //1ms
  if (currentTime - lastTime1s  >= 1000) {
    lastTime1s = currentTime;
    tasks1s();
  }

  //5ms
  if (currentTime - lastTime5s  >= 5000) {
    lastTime5s = currentTime;
    tasks5s();
  }

  //10ms
  if (currentTime - lastTime10s >= 10000) {
    lastTime10s = currentTime;
    tasks10s();
  }
}


  
//---------------------------------------------------------------------------/
//   FUNCTIONS
//---------------------------------------------------------------------------/
void tasks1s() {
ReadTemp();
}


void tasks5s() {
ShowOnLcd();
}

void tasks10s() {
}

//---------------------------------------------------------------------------/

void DetermineSetpoint(){
   t = millis()/1000.;
   
   if (i>n-1){
      setpoint = 0;
    }
   else if (t<tspc){
   setpoint = sparray[0][i];
   }
   else {
    i=i+1;
    tspc = tspc + sparray[1][i];
   }
}


void ReadTemp(){
  tempout = analogRead(TempPin);
  temp = (tempout/1024.)*500.;
  t = millis()/1000.;
  
  Serial.print(t);
  Serial.print("\t");
  Serial.print(temp);
  Serial.print("\t");
//  Serial.print(setpoint);
//  Serial.print("\t");
  Serial.print(heater);
  Serial.print("\t");
  Serial.print(cooler);
  Serial.print("\n");
}

void ShowOnLcd(){
  lcd.setCursor(0,0);
  lcd.print("Set Temp: ");
//  lcd.print(setpoint);
 
  lcd.setCursor(0,1);
  lcd.print("Cur Temp:");
  lcd.print(temp);

}
