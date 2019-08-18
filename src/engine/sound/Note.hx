package engine.sound;

import js.html.audio.OscillatorNode;
import js.html.audio.AudioContext;
import js.html.audio.GainNode;
import js.html.audio.PeriodicWave;

class Note
{
    public function new(hz :Float, ctx :AudioContext, gain :GainNode, wav :PeriodicWave) : Void
    {
        _hz = hz;
        _ctx = ctx;
        _gain = gain;
        _wav = wav;
        _osc = null;
    }

    public function play() : Void
    {
        if(_osc == null) {
            _osc = _ctx.createOscillator();
            _osc.connect(_gain);
            _osc.setPeriodicWave(_wav);
            _osc.frequency.value = _hz;
            _osc.start();
        }
        else {
            this.stop();
            this.play();
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

    private var _hz :Float;
    private var _ctx :AudioContext;
    private var _gain :GainNode;
    private var _wav :PeriodicWave;
    private var _osc :OscillatorNode;
}