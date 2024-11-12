import pico;
import pico.gpio : GPIO;

extern (C) void main() @safe
{
    stdioInit();
    auto led = GPIO(PICO_DEFAULT_LED_PIN, true);
    printf("Hello, world from D!");

    while (true)
    {
        led.put(true);
        sleepMs(250);
        led.put(false);
        sleepMs(250);
    }
}
