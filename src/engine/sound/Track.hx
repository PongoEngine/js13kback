package engine.sound;

import engine.sound.theory.Pulse;
import engine.sound.theory.Note;
import engine.sound.theory.Duration;

typedef Track = Map<Pulse, Array<{note:Note,duration:Duration,start:Pulse, sound :Sound, envelope :Envelope}>>;

typedef TrackData =
{
    tracks: TrackMap<Array<{sound:String,envelope:String,loops:Array<String>}>>,
    envelopes: TrackMap<Envelope>,
    sounds: TrackMap<Sound>,
    loops: TrackMap<Array<String>>
}

extern abstract Envelope(Array<Float>)
{
    public inline function new(arra :Array<Float>) : Void
    {
        this = arra;
    }

    public inline function attackDur() :Float return this[0];
    public inline function attackAmp() :Float return this[1];
    public inline function decayDur() :Float return this[2];
    public inline function sustainDur() :Float return this[3];
    public inline function sustainAmp() :Float return this[4];
    public inline function releaseDur() :Float return this[5];
}

extern abstract Sound(Array<Float>)
{
    public inline function new(arra :Array<Float>) : Void
    {
        this = arra;
    }

    public inline function volume() :Float return this[0];
    public inline function randomness() :Float return this[1];
    public inline function length() :Float return this[2];
    public inline function attack() :Float return this[3];
    public inline function slide() :Float return this[4];
    public inline function noise() :Float return this[5];
    public inline function modulation() :Float return this[6];
    public inline function modulationPhase() :Float return this[7];
}

abstract TrackMap<T>({})
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