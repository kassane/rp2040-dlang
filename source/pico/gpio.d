module pico.gpio;
import pico.sdk;

struct GPIO
{
    private uint pin;

    this(uint pin, bool output = false) @trusted
    {
        this.pin = pin;
        gpio_init(pin);
        gpio_set_dir(pin, output);
    }

    void put(bool value) @trusted
    {
        gpio_put(pin, value);
    }

    bool get() @trusted
    {
        return gpio_get(pin);
    }

    void setFunction(gpio_function_rp2040 fn) @trusted
    {
        gpio_set_function(pin, fn);
    }

    uint getFunction() @trusted
    {
        return gpio_get_function(pin);
    }
}
