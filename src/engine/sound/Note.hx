package engine.sound;

import js.html.audio.OscillatorNode;
import js.html.audio.AudioContext;
import js.html.audio.GainNode;
import js.html.audio.PeriodicWave;

abstract Note(OscillatorNode) 
{
    public inline function new(hz :Float, ctx :AudioContext, gain :GainNode, wav :PeriodicWave) : Void
    {
        this = ctx.createOscillator();
        this.connect(gain);
        this.setPeriodicWave(wav);
        this.frequency.value = hz;
    }

    public function play() : Void
    {
        this.start();
    }

    public function stop() : Void
    {
        this.stop();
    }
}