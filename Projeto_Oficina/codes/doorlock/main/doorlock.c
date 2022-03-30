/*
idf.py -C /home/vitor/utf/UTFPR/Projeto_Oficina/codes/doorlock build
idf.py -C /home/vitor/utf/UTFPR/Projeto_Oficina/codes/doorlock -p /dev/ttyUSBx flash
idf.py -C /home/vitor/utf/UTFPR/Projeto_Oficina/codes/doorlock monitor
*/

#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include "esp_log.h"
#include "driver/gpio.h"

#define BLINK_LED 2

void app_main(void)
{
    char *ourTaskName = pcTaskGetName(NULL);

    ESP_LOGI(ourTaskName, "Hello, stating up!\n");
    gpio_Reset_pin(BLINK_LED);
    gpio_set_direction(BLINK_LED, GPIO_MODE_OUTPUT);

    while (1)
    {
        gpio_set_level(BLINK_LED,1);
        vTaskDelay(1000 / portTICK_PERIOD_MS); //clock tick not clock cycle
        gpio_set_level(BLINK_LED,0);
        vTaskDelay(1000 / portTICK_PERIOD_MS);
    }
    
}
