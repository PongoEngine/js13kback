package engine.sound.track;

extern abstract Envelope(Array<Float>)
{
    public inline function new(arra :Array<Float>) : Void
    {
        this = arra;
    }

    public inline function attackDur() :Float return this[0];
    public inline function attackAmp() :Float return this[1];
    public inline function decayDur() :Float return this[2];
    public inline function sustainAmp() :Float return this[3];
    public inline function releaseDur() :Float return this[4];
}