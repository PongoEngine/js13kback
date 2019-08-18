package engine.sound;

import js.html.audio.OscillatorNode;
import js.html.audio.AudioContext;
import js.html.audio.OscillatorType;
import js.html.audio.AudioNode;

class Oscillator
{
    public function new() : Void
    {
        _osc = null;
    }

    public function play(freq :Float, ctx :AudioContext, audio :AudioNode, type :OscillatorType) : Void
    {
        if(_osc == null) {
            _osc = ctx.createOscillator();
            _osc.connect(audio);
            _osc.type = type;
            _osc.frequency.value = freq;
            _osc.start();
        }
        else {
            this.stop();
            this.play(freq, ctx, audio, type);
        }
    }

    public function stop() : Void
    {
        if(_osc != null) {
            _osc.disconnect();
            _osc.stop();
            _osc = null;
        }
    }

    private var _osc :OscillatorNode;
}