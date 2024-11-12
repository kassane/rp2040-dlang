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
module pico.bootloader;
private import pico.sdk;

struct Bootloader
{
    void reboot(uint usb_activity_gpio_pin_mask = 0, uint disable_interface_mask = 0) @trusted
    {
        reset_usb_boot(usb_activity_gpio_pin_mask, disable_interface_mask);
    }

    void watchdogReboot(uint pc = 0, uint sp = 0, uint delay_ms = 0) @trusted
    {
        watchdog_reboot(pc, sp, delay_ms);
    }

    void watchdogEnable(uint delay_ms, bool pause_on_debug) @trusted
    {
        watchdog_enable(delay_ms, pause_on_debug);
    }

    void watchdogUpdate() @trusted
    {
        watchdog_update();
    }
}
