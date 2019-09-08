package engine.util;

abstract KeyMap<T>({})
{
    public inline function new(val :{}) : Void
    {
        this = val;
    }

    public inline function get(name :String) : T
    {
        return untyped this[name];
    }

    public inline function exists(name :String) : T
    {
        return untyped this[name] != null;
    }
}