/*
 * Boost Software License 1.0 (BSL-1.0)
 *
 * @author: Matheus Catarino França <matheus-catarino@hotmail.com>
 * 
 * Permission is hereby granted, free of charge, to any person or organization
 * obtaining a copy of the software and accompanying documentation covered by
 * this license (the "Software") to use, reproduce, display, distribute,
 * execute, and transmit the Software, and to prepare derivative works of the
 * Software, and to permit third-parties to whom the Software is furnished to
 * do so, all subject to the following:
 * 
 * The copyright notices in the Software and this entire statement, including
 * the above license grant, this restriction and the following disclaimer,
 * must be included in all copies of the Software, in whole or in part.
 */
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
