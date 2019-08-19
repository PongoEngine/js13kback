package engine.sound.synth;

import js.html.audio.OscillatorNode;
import js.html.audio.GainNode;
import js.html.audio.OscillatorOptions;
import js.html.audio.AudioContext;
import js.html.audio.OscillatorType;
import js.html.audio.AudioNode;
import engine.sound.Track.ADSR;

class Oscillator
{
    public function new() : Void
    {
        _osc = null;
    }

    public function play(freq :Float, ctx :AudioContext, audio :AudioNode, type :OscillatorType, adsr :ADSR) : Void
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
            _gain.gain.linearRampToValueAtTime(adsr.attackAmp ,ct+adsr.attackDur);
            _gain.gain.linearRampToValueAtTime(adsr.sustainAmp,ct+adsr.attackDur+adsr.decayDur);
            _gain.gain.linearRampToValueAtTime(adsr.sustainAmp,ct+adsr.attackDur+adsr.decayDur+adsr.sustainDur);
            _gain.gain.linearRampToValueAtTime(0,ct+adsr.attackDur+adsr.decayDur+adsr.sustainDur+adsr.releaseDur);
        }
        else {
            this.stop();
            this.play(freq, ctx, audio, type, adsr);
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