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
#include "esp_wifi.h"
#include "esp_event.h"
#include "esp_log.h"

#include <nvs_flash.h>
#include <sys/param.h>

#include "cam.h"
#include "wifi.h"
#include "button.h"
#include "request.h"

#ifndef portTICK_RATE_MS
#define portTICK_RATE_MS portTICK_PERIOD_MS
#endif

void app_main(void)
{
    //Initialize NVS
    static const char *TAG_LOGI = "example:Logging";
    ESP_LOGI(TAG_LOGI, "Hello, Starting up!");
    /*esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
      ESP_ERROR_CHECK(nvs_flash_erase());
      ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);*/

    //ESP_LOGI(TAG_WIFI, "ESP_WIFI_MODE_STA");
    //wifi_init_sta();
    ESP_LOGI(TAG_WIFI, "wifi pulado");
    
    /*if(ESP_OK != init_camera()) {
        return;
    }*/

    //Init GPIO TASKS
    
    //zero-initialize the config structure.
    gpio_config_t io_conf = {};

    //interrupt of rising edge
    io_conf.intr_type = GPIO_INTR_POSEDGE;
    //bit mask of the pins, use GPIO4/5 here
    io_conf.pin_bit_mask = GPIO_INPUT_PIN_SEL;
    //set as input mode
    io_conf.mode = GPIO_MODE_INPUT;
    //enable pull-up mode
    io_conf.pull_up_en = 1;
    gpio_config(&io_conf);

    //change gpio interrupt type for one pin
    gpio_set_intr_type(GPIO_INPUT_IO_0, GPIO_INTR_ANYEDGE);

    //create a queue to handle gpio event from isr
    gpio_evt_queue = xQueueCreate(10, sizeof(uint32_t));
    //start gpio task
    xTaskCreate(gpio_task_example, "gpio_task_example", 2048, NULL, 10, NULL);

    //install gpio isr service
    gpio_install_isr_service(ESP_INTR_FLAG_DEFAULT);
    //hook isr handler for specific gpio pin
    gpio_isr_handler_add(GPIO_INPUT_IO_0, gpio_isr_handler, (void*) GPIO_INPUT_IO_0);

    printf("Minimum free heap size: %d bytes\n", esp_get_minimum_free_heap_size());

    int i =1;
    int cnt = 0;
    while (i==1){

        //ESP_LOGI(TAG_CAM, "Taking picture...");
        //camera_fb_t *pic = esp_camera_fb_get();

        // use pic->buf to access the image
        //ESP_LOGI(TAG_CAM, "Picture taken! Its size was: %zu bytes", pic->len);
        //esp_camera_fb_return(pic);
        get_request();
        //Button example
        printf("cnt: %d\n", cnt++);
        vTaskDelay(5000 / portTICK_RATE_MS);
        //i = 0;
    }

}
