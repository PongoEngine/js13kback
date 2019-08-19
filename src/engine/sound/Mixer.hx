package engine.sound;

import engine.sound.Track.ADSR;
import js.html.audio.OscillatorType;
import engine.sound.theory.Duration;
import engine.sound.theory.Pulse;
import engine.sound.synth.Synth;

class Mixer
{
    public function new() : Void
    {
        _synth = new Synth();
    }

    public function mute() : Void
    {
        _synth.mute();
    }

    public function unmute() : Void
    {
        _synth.unmute();
    }

    public function resume() : Void
    {
        _synth.resume();
    }

    public function play(key :Int, start:Pulse, duration :Duration, type :OscillatorType, adsr :ADSR) : Void
    {
        _synth.play(key, start, duration, type, adsr);
    }

    public function checkNotes(cur :Pulse) : Void
    {
        _synth.checkActive(cur);
    }

    private var _synth :Synth;
}