package engine.sound.synth;

import engine.sound.Track.ADSR;
import js.html.audio.AudioContext;
import js.html.audio.StereoPannerNode;
import js.html.audio.BiquadFilterNode;
import js.html.audio.ConvolverNode;
import js.html.audio.WaveShaperNode;
import js.html.audio.GainNode;
import engine.sound.synth.Frequencies;
import js.html.audio.OscillatorType;
import engine.sound.theory.Duration;
import engine.sound.theory.Pulse;
import js.lib.Float32Array;
import js.html.audio.OverSampleType;
import js.html.audio.BiquadFilterType;
import js.html.audio.AudioBuffer;

class Synth
{
    public function new() : Void
    {
        _audioContext = new AudioContext({sampleRate: 44100});
        _equalizerNode = _audioContext.createBiquadFilter();
        _equalizerNode.type = BiquadFilterType.ALLPASS;
        _reverbNode = _audioContext.createConvolver();
        _reverbNode.buffer = impulseResponse(0.5, 2, false);
        _waveShaper = _audioContext.createWaveShaper();
        _waveShaper.curve = makeDistortionCurve();
        _waveShaper.oversample = OverSampleType._4X;
        _masterGainNode = _audioContext.createGain();

        _equalizerNode.connect(_reverbNode);
        _reverbNode.connect(_waveShaper);
        _waveShaper.connect(_masterGainNode);
        
        _masterGainNode.connect(_audioContext.destination);

        _masterGainNode.gain.setValueAtTime(GAME_VOLUME, _audioContext.currentTime);
        _frequencies = new Frequencies();
        _oscPool = [];
        _oscActive = [];
    }

    public inline function mute() : Void
    {
        _masterGainNode.gain.setValueAtTime(0, _audioContext.currentTime);
    }

    public inline function unmute() : Void
    {
        _masterGainNode.gain.setValueAtTime(GAME_VOLUME, _audioContext.currentTime);
    }

    public inline function resume() : Void
    {
        this._audioContext.resume();
    }

    public function play(key :Int, start:Pulse, duration :Duration, type :OscillatorType, adsr :ADSR) : Void
    {
        var osc = _oscPool.length > 0 ? _oscPool.pop() : new Oscillator();
        // osc.play(_frequencies.get(key), _audioContext, _equalizerNode, type, adsr);
        // osc.play(_frequencies.get(key), _audioContext, _waveShaper, type, adsr);
        osc.play(_frequencies.get(key), _audioContext, _masterGainNode, type, adsr);
        _oscActive.push({osc:osc,duration:duration,start:start,elapsed:new Pulse(0)});
    }

    public function checkActive(currentPulse :Pulse) : Void
    {
        var actives = _oscActive.iterator();
        for(active in actives) {
            if(currentPulse >= active.start+active.duration) {
                active.osc.stop();
                _oscActive.remove(active);
                _oscPool.push(active.osc);
            }
        }
    }

    private function impulseResponse(duration :Float, decay :Float, reverse :Bool ) : AudioBuffer
    {
        var sampleRate = _audioContext.sampleRate;
        var length :Int = Math.round(sampleRate * duration);
        var impulse = _audioContext.createBuffer(2, length, sampleRate);
        var impulseL = impulse.getChannelData(0);
        var impulseR = impulse.getChannelData(1);

        for (i in 0...length){
            var n = reverse ? length - i : i;
            impulseL[i] = (Math.random() * 2 - 1) * Math.pow(1 - n / length, decay);
            impulseR[i] = (Math.random() * 2 - 1) * Math.pow(1 - n / length, decay);
        }
        return impulse;
    }

    private function makeDistortionCurve(amount :Int = 50) {
        var k = amount;
        var n_samples = Math.floor(_audioContext.sampleRate);
        var curve = new Float32Array(n_samples);
        var deg = Math.PI / 180;
        var i = 0;
        var x :Float;
        while (i < n_samples) {
            ++i;
            x = i * 2 / n_samples - 1;
            curve[i] = ( 3 + k ) * x * 20 * deg / ( Math.PI + k * Math.abs(x) );
        }
        return curve;
    };

    private var _oscPool : Array<Oscillator>;
    private var _oscActive : Array<{osc:Oscillator,duration:Duration,start:Pulse,elapsed:Pulse}>;

    private var _audioContext : AudioContext;
    private var _masterGainNode : GainNode;
    private var _waveShaper :WaveShaperNode;
    private var _reverbNode :ConvolverNode;
    private var _equalizerNode :BiquadFilterNode;
    private var _frequencies :Frequencies;
    private static inline var GAME_VOLUME = 1;
}