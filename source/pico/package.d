module pico;

version (D_BetterC) // no DRT
{
    version (LDC)
    {
        pragma(LDC_no_moduleinfo);
        pragma(LDC_no_typeinfo);
    }
}
else
{
@nogc nothrow:
}

// importC
public import pico.sdk;

pragma(printf)
extern (C) int printf(scope const(char)* fmt, ...) @trusted nothrow @nogc;

void sleepMs(uint ms) @trusted
{
    sleep_us(ms);
}

void stdioInit() @trusted
{
    stdio_init_all();
}

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

struct UART
{
    private uart_inst* uart;

    this(scope uart_inst* uart_id, uint baud_rate) @trusted
    {
        this.uart = uart_id;
        uart_init(uart_id, baud_rate);
    }

    void putc(char c) @trusted
    {
        uart_putc_raw(uart, c);
    }

    int getc() @trusted
    {
        return uart_getc(uart);
    }

    bool isReadable() @trusted
    {
        return uart_is_readable(uart);
    }

    bool isWritable() @trusted
    {
        return uart_is_writable(uart);
    }
}
