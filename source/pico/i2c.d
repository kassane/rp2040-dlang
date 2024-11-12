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
