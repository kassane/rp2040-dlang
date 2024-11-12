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
    sleep_ms(ms);
}

void stdioInit() @trusted
{
    stdio_init_all();
}

struct Array(T)
{
    private
    {
        T* ptr;
        size_t len;
        size_t cap;
    }

    this(size_t initialCapacity) @trusted
    {
        ptr = cast(T*) malloc(T.sizeof * initialCapacity);
        len = 0;
        cap = initialCapacity;
    }

    ~this() @trusted
    {
        if (ptr)
            free(ptr);
    }

    void push(T value) @trusted
    {
        if (len == cap)
        {
            cap *= 2;
            ptr = cast(T*) realloc(ptr, T.sizeof * cap);
        }
        ptr[len++] = value;
    }

    T pop() @trusted
    {
        return ptr[--len];
    }

    ref T opIndex(size_t index) @trusted
    {
        return ptr[index];
    }

    size_t length() const @trusted
    {
        return len;
    }
}

@("Array tests")
unittest
{
    auto arr = Array!int(2);
    assert(arr.length == 0);

    arr.push(1);
    assert(arr.length == 1);
    assert(arr[0] == 1);

    arr.push(2);
    arr.push(3);
    assert(arr.length == 3);
    assert(arr[1] == 2);
    assert(arr[2] == 3);

    assert(arr.pop() == 3);
    assert(arr.length == 2);
}

struct Option(T)
{
    private
    {
        T value;
        bool hasValue;
    }

    static Option!T some(T value) @trusted
    {
        Option!T opt;
        opt.value = value;
        opt.hasValue = true;
        return opt;
    }

    static Option!T none() @trusted
    {
        Option!T opt;
        opt.hasValue = false;
        return opt;
    }

    bool isSome() const @trusted pure
    {
        return hasValue;
    }

    bool isNone() const @trusted pure
    {
        return !hasValue;
    }

    T unwrap() @trusted
    {
        assert(hasValue, "Called unwrap on None value");
        return value;
    }

    T unwrapOr(T defaultValue) @trusted
    {
        return hasValue ? value : defaultValue;
    }
}

@("Option tests")
unittest
{
    auto some = Option!int.some(42);
    assert(some.isSome());
    assert(!some.isNone());
    assert(some.unwrap() == 42);
    assert(some.unwrapOr(0) == 42);

    auto none = Option!int.none();
    assert(!none.isSome());
    assert(none.isNone());
    assert(none.unwrapOr(0) == 0);
}
