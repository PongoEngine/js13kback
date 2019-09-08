package engine.sound.track;

extern abstract Sound(Array<Float>)
{
    public inline function new(arra :Array<Float>) : Void
    {
        this = arra;
    }

    public inline function volume() :Float return this[0];
    public inline function noise() :Float return this[1];
    public inline function sine() :Float return this[2];
    public inline function square() :Float return this[3];
}