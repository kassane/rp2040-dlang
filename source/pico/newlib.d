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
module pico.newlib;

@nogc nothrow
extern (C)
{
    pragma(printf)
    uint printf(scope const(char)* fmt, ...) @trusted;
    ///
    scope void* malloc(size_t size) @trusted;
    ///
    scope void* realloc(scope void* ptr, size_t size) @trusted;
    ///
    scope void* calloc(size_t nmemb, size_t size) @trusted;
    ///
    void free(scope void* ptr) @trusted;
    ///
    noreturn onOutOfMemoryError()(scope void* pretend_sideffect = null) pure @trusted
    {
        assert(0, "Memory allocation failed");
    }
    ///
    noreturn onInvalidMemoryOperationError()(scope void* pretend_sideffect = null) pure @trusted
    {
        assert(0, "Invalid memory operation");
    }
}
