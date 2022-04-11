
#define BUTTON_SIDE_PIN 15
// support IDF 5.x
#ifndef portTICK_RATE_MS
#define portTICK_RATE_MS portTICK_PERIOD_MS
#endif

#define BLINK_LED 2