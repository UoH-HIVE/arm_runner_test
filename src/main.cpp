
#include <wiringPi.h>

#define PIN_LED 13

int main() {
  // switch to bcm mode
  wiringPiSetupGpio();

  // set pin mode
  pinMode(PIN_LED, OUTPUT);

  // blink LED
  while (true) {
    digitalWrite(PIN_LED, HIGH);
    delay(500);
    digitalWrite(PIN_LED, LOW);
    delay(500);
  }
}