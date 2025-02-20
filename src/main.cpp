
#include <iostream>
#include <wiringPi.h>

#define PIN_LED 13

int main() {
  std::cout << "Hello, World!" << std::endl;

  // switch to bcm mode
  wiringPiSetupGpio();
  std::cout << "GPIO mode set to BCM" << std::endl;

  // set pin mode
  pinMode(PIN_LED, OUTPUT);
  std::cout << "Pin mode set to OUTPUT" << std::endl;

  // blink LED
  while (true) {
    std::cout << "Blinking LED" << std::endl;
    digitalWrite(PIN_LED, HIGH);
    delay(500);
    digitalWrite(PIN_LED, LOW);
    delay(500);
  }
}