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
module pico.i2c;
private import pico.sdk;

struct I2C
{
    private i2c_inst* i2c;

    this(scope i2c_inst* i2c_id, uint baudrate) @trusted
    {
        this.i2c = i2c_id;
        i2c_init(i2c_id, baudrate);
    }

    bool write(ubyte addr, const(ubyte)[] data, bool nostop) @trusted
    {
        return i2c_write_blocking(i2c, addr, data.ptr, data.length, nostop) >= 0;
    }

    bool read(ubyte addr, ubyte[] data, bool nostop) @trusted
    {
        return i2c_read_blocking(i2c, addr, data.ptr, data.length, nostop) >= 0;
    }

    void setSlaveMode(bool is_slave, ubyte addr) @trusted
    {
        i2c_set_slave_mode(i2c, is_slave, addr);
    }
}
