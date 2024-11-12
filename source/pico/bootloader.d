module pico.bootloader;
import pico.sdk;

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
