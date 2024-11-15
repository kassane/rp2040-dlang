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
module pico.gpio;
private import pico.sdk;

version (RP2040)
    alias gpio_function = gpio_function_rp2040;
else
    alias gpio_function = gpio_function_rp2350;

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

    void setFunction(gpio_function fn) @trusted
    {
        gpio_set_function(pin, fn);
    }

    uint getFunction() @trusted
    {
        return gpio_get_function(pin);
    }

    void pullUp() @trusted
    {
        gpio_pull_up(pin);
    }

    void pullDown() @trusted
    {
        gpio_pull_down(pin);
    }

    void disablePulls() @trusted
    {
        gpio_disable_pulls(pin);
    }

    void setPulls(bool up, bool down) @trusted
    {
        gpio_set_pulls(pin, up, down);
    }

    void setIrqOver(uint value) @trusted
    {
        gpio_set_irqover(pin, value);
    }

    void setOutOver(uint value) @trusted
    {
        gpio_set_outover(pin, value);
    }

    void setInOver(uint value) @trusted
    {
        gpio_set_inover(pin, value);
    }

    void setOeOver(uint value) @trusted
    {
        gpio_set_oeover(pin, value);
    }

    void setInputEnabled(bool enable) @trusted
    {
        gpio_set_input_enabled(pin, enable);
    }

    void setInputHysteresisEnabled(bool enabled) @trusted
    {
        gpio_set_input_hysteresis_enabled(pin, enabled);
    }

    bool isInputHysteresisEnabled() @trusted
    {
        return gpio_is_input_hysteresis_enabled(pin);
    }

    void setSlewRate(gpio_slew_rate slew) @trusted
    {
        gpio_set_slew_rate(pin, slew);
    }

    gpio_slew_rate getSlewRate() @trusted
    {
        return gpio_get_slew_rate(pin);
    }

    void setDriveStrength(gpio_drive_strength drive) @trusted
    {
        gpio_set_drive_strength(pin, drive);
    }

    gpio_drive_strength getDriveStrength() @trusted
    {
        return gpio_get_drive_strength(pin);
    }

    void initMask(uint gpio_mask) @trusted
    {
        gpio_init_mask(gpio_mask);
    }

    uint getAll() @trusted
    {
        return gpio_get_all();
    }

    void setMask(uint mask) @trusted
    {
        gpio_set_mask(mask);
    }

    void clearMask(uint mask) @trusted
    {
        gpio_clr_mask(mask);
    }

    void xorMask(uint mask) @trusted
    {
        gpio_xor_mask(mask);
    }

    void putMasked(uint mask, uint value) @trusted
    {
        gpio_put_masked(mask, value);
    }

    void putAll(uint value) @trusted
    {
        gpio_put_all(value);
    }

    void setDirOutMasked(uint mask) @trusted
    {
        gpio_set_dir_out_masked(mask);
    }

    void setDirInMasked(uint mask) @trusted
    {
        gpio_set_dir_in_masked(mask);
    }

    void setDirMasked(uint mask, uint value) @trusted
    {
        gpio_set_dir_masked(mask, value);
    }

    void setDirAllBits(uint value) @trusted
    {
        gpio_set_dir_all_bits(value);
    }

    void debugPinsInit() @trusted
    {
        gpio_debug_pins_init();
    }
}
