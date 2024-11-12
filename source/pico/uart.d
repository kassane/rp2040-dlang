module pico.uart;
private import pico.sdk;

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
