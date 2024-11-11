module pico;

version (D_BetterC) // no DRT
{
    version (LDC)
    {
        pragma(LDC_no_moduleinfo);
        pragma(LDC_no_typeinfo);
    }
}

public import pico.sdk;

pragma(printf)
extern (C) int printf(scope const(char)* fmt, ...) @trusted nothrow @nogc;
