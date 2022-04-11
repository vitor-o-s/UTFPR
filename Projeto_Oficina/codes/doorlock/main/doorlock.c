/*
cd /PATH_to_PROJECT/codes/doorlock/
. $HOME/esp/esp-idf/export.sh
idf.py build
idf.py -p /dev/ttyUSBx flash
idf.py monitor
*/

#include <stdio.h>
#include "driver/gpio.h"
#include <string.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
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
// #include "request.h"

void app_main(void)
{
    //Initialize NVS
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
      ESP_ERROR_CHECK(nvs_flash_erase());
      ret = nvs_flash_init();
    }
    ESP_ERROR_CHECK(ret);

    ESP_LOGI(TAG_WIFI, "ESP_WIFI_MODE_STA");
    wifi_init_sta();
    ESP_LOGI(TAG_WIFI, "wifi pulado");
    
    if(ESP_OK != init_camera()) {
        return;
    }

    int i =1;
    while (i==1){

        ESP_LOGI(TAG_CAM, "Taking picture...");
        camera_fb_t *pic = esp_camera_fb_get();

        // use pic->buf to access the image
        ESP_LOGI(TAG_CAM, "Picture taken! Its size was: %zu bytes", pic->len);
        esp_camera_fb_return(pic);

        vTaskDelay(5000 / portTICK_RATE_MS);
        i = 0;
    }
    
}
