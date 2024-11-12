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
module pico.adc;
private import pico.sdk;

struct ADC
{
    private uint pin;

    this(uint pin) @trusted
    {
        this.pin = pin;
        adc_init();
        adc_gpio_init(pin);
    }

    ushort read() @trusted
    {
        adc_select_input(pin);
        return adc_read();
    }

    float readVoltage() @trusted
    {
        return read() * 3.3f / 4096.0f;
    }

    void setClockDivider(uint divider) @trusted
    {
        adc_set_clkdiv(divider);
    }

    void setTempSensorEnabled(bool enable) @trusted
    {
        adc_set_temp_sensor_enabled(enable);
    }

    bool exec(bool is_running) @trusted
    {
        return adc_run(is_running);
    }

    struct Fifo
    {
        this(bool en, bool dreq_en, ushort dreq_thresh, bool err_in_fifo, bool byte_shift) @trusted
        {
            adc_fifo_setup(en, dreq_en, dreq_thresh, err_in_fifo, byte_shift);
        }

        bool is_empty() @trusted
        {
            return adc_fifo_is_empty();
        }

        ubyte getLevel() @trusted
        {
            return adc_fifo_get_level();
        }

        ushort get() @trusted
        {
            return adc_fifo_get();
        }

        ushort getBlocking() @trusted
        {
            return adc_fifo_get_blocking();
        }

        void drain() @trusted
        {
            adc_fifo_drain();
        }

    }

    void setIRQenabled(bool en) @trusted
    {
        adc_irq_set_enabled(en);
    }
}
