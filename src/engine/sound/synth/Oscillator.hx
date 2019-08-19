package engine.sound.synth;

import js.html.audio.OscillatorNode;
import js.html.audio.GainNode;
import js.html.audio.OscillatorOptions;
import js.html.audio.AudioContext;
import js.html.audio.OscillatorType;
import js.html.audio.AudioNode;
import engine.sound.Track.ASDR;

class Oscillator
{
    public function new() : Void
    {
        _osc = null;
    }

    public function play(freq :Float, ctx :AudioContext, audio :AudioNode, type :OscillatorType, asdr :ASDR) : Void
    {
        if(_osc == null) {
            _gain = ctx.createGain();
            _osc = ctx.createOscillator();
            _osc.connect(_gain);
            _gain.connect(audio);

            _osc.type = type;
            _osc.frequency.value = freq;
            _osc.start();

            var ct = ctx.currentTime;

            _gain.gain.setValueAtTime(0,ct);
            _gain.gain.linearRampToValueAtTime(1,ct+asdr.attack);
            _gain.gain.linearRampToValueAtTime(asdr.sustainVal,ct+asdr.attack+asdr.decay);
            _gain.gain.linearRampToValueAtTime(asdr.sustainVal,ct+asdr.attack+asdr.decay+asdr.sustain);
            _gain.gain.linearRampToValueAtTime(0,ct+asdr.attack+asdr.decay+asdr.sustain+asdr.release);
        }
        else {
            this.stop();
            this.play(freq, ctx, audio, type, asdr);
        }
    }

    public function stop() : Void
    {
        if(_osc != null) {
            _osc.disconnect();
            _gain.disconnect();
            _osc.stop();
            _osc = null;
            _gain = null;
        }
    }

    private var _osc :OscillatorNode;
    private var _gain :GainNode;
}