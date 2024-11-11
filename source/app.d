import pico;

extern (C) void main()
{
    stdio_init_all();
    auto led = PICO_DEFAULT_LED_PIN;
    gpio_init(led);
    gpio_set_dir(led, /*out*/ true);
    printf("Hello, world from D!");
    while (true)
    {
        gpio_put(led, true);
        sleep_ms(250);
        gpio_put(led, false);
        sleep_ms(250);
    }

}
