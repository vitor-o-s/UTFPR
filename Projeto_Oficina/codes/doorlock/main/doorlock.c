/*
cd /PATH_to_PROJECT/codes/doorlock/
. $HOME/esp/esp-idf/export.sh
idf.py build
idf.py -p /dev/ttyUSBx flash monitor
*/

#include <stdio.h>
#include "driver/gpio.h"
#include <string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/timers.h"
#include "freertos/event_groups.h"
#include "esp_system.h"
#include "esp_event.h"
#include "esp_log.h"

#include "wifi.h"
#include "button.h"
#include "setup_config.h"

static const char *TAG_LOGI = "doorlock";

void app_main(void)
{
  // Initialize NVS
  ESP_LOGI(TAG_LOGI, "Hello, Starting up!");

  setup_init(TAG_LOGI);

  wifi_init_sta();
  // ESP_LOGI(TAG_WIFI, "wifi pulado");

  if (ESP_OK != init_camera())
  {
    return;
  }

  // Init GPIO TASKS
  // zero-initialize the config structure.
  gpio_config_t io_conf = {};

  // interrupt of rising edge
  io_conf.intr_type = GPIO_INTR_POSEDGE;
  // bit mask of the pins, use GPIO4/5 here
  io_conf.pin_bit_mask = GPIO_INPUT_PIN_SEL;
  // set as input mode
  io_conf.mode = GPIO_MODE_INPUT;
  // enable pull-up mode
  io_conf.pull_up_en = 1;
  gpio_config(&io_conf);

  // change gpio interrupt type for one pin
  gpio_set_intr_type(GPIO_INPUT_IO_0, GPIO_INTR_ANYEDGE);

  // create a queue to handle gpio event from isr
  gpio_evt_queue = xQueueCreate(10, sizeof(uint32_t));
  // start gpio task
  xTaskCreate(gpio_task_example, "gpio_task_example", 8000, NULL, 10, NULL);

  // install gpio isr service
  // gpio_install_isr_service(ESP_INTR_FLAG_DEFAULT);
  // hook isr handler for specific gpio pin
  gpio_isr_handler_add(GPIO_INPUT_IO_0, gpio_isr_handler, (void *)GPIO_INPUT_IO_0);

  printf("Minimum free heap size: %d bytes\n", esp_get_minimum_free_heap_size());

  int i = 1;
  int cnt = 0;
  while (i == 1)
  {
    printf("cnt: %d\n", cnt++);
    vTaskDelay(5000 / portTICK_RATE_MS);
    // i = 0;
  }
}
