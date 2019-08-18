package engine.sound;

import js.html.audio.AudioContext;
import js.html.audio.StereoPannerNode;
import js.html.audio.BiquadFilterNode;
import js.html.audio.ConvolverNode;
import js.html.audio.WaveShaperNode;
import js.html.audio.GainNode;
import engine.sound.Frequencies;
import js.html.audio.OscillatorType;
import engine.sound.theory.Duration;
import engine.sound.theory.Pulse;
import js.lib.Float32Array;
import js.html.audio.OverSampleType;
import js.html.audio.BiquadFilterType;
import js.html.audio.AudioBuffer;

class Sound
{
    public function new() : Void
    {
        _audioContext = new AudioContext();

        _waveShaper = _audioContext.createWaveShaper();
        _waveShaper.curve = makeDistortionCurve(10);
        _waveShaper.oversample = OverSampleType._4X;
        _equalizerNode = _audioContext.createBiquadFilter();
        _equalizerNode.type = BiquadFilterType.ALLPASS;
        _reverbNode = _audioContext.createConvolver();
        _reverbNode.buffer = impulseResponse(0.5, 2.0, false);
        _panner = _audioContext.createStereoPanner();
        _panner.pan.setTargetAtTime(0, _audioContext.currentTime, 1);
        _masterGainNode = _audioContext.createGain();

        _waveShaper.connect(_equalizerNode);
        _equalizerNode.connect(_reverbNode);
        _reverbNode.connect(_panner);
        _panner.connect(_masterGainNode);
        
        _masterGainNode.connect(_audioContext.destination);

        _masterGainNode.gain.setValueAtTime(GAME_VOLUME, _audioContext.currentTime);
        _frequencies = new Frequencies();
        _notes = new Map<String, PlayedNote>();
    }

    public function mute() : Void
    {
        _masterGainNode.gain.setValueAtTime(0, _audioContext.currentTime);
    }

    public function unmute() : Void
    {
        _masterGainNode.gain.setValueAtTime(GAME_VOLUME, _audioContext.currentTime);
    }

    public function resume() : Void
    {
        this._audioContext.resume();
    }

    public function setCurve(val :Int) : Void
    {
        _waveShaper.curve = makeDistortionCurve(val);
    }

    public function play(key :Int, duration :Duration, type :OscillatorType) : Void
    {
        if(!_notes.exists(key+"")) {
            _notes.set(key+"", {
                name: key+"",
                osc: new Oscillator(),
                duration: duration,
                pulses: new Pulse(0)
            });
        }
        _notes.get(key+"").osc.play(_frequencies.get(key), _audioContext, _waveShaper, type);
    }

    public function checkNotes() : Void
    {
        var itr = _notes.iterator();
        for(note in itr) {
            if(note.pulses >= note.duration) {
                this.stop(note.name);
            }
            else {
                note.pulses++;
            }
        }
    }

    public function stop(name :String) : Void
    {
        var note : PlayedNote = _notes.get(name);
        if(note != null) {
            _notes.remove(note.name);
            note.osc.stop();
        }
    }

    function makeDistortionCurve(amount :Int) : Float32Array
    {
        var k = amount;
        var n_samples = 44100;
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

    private var _audioContext : AudioContext;
    private var _masterGainNode : GainNode;
    private var _panner :StereoPannerNode;
    private var _waveShaper :WaveShaperNode;
    private var _reverbNode :ConvolverNode;
    private var _equalizerNode :BiquadFilterNode;
    private var _frequencies :Frequencies;
    private var _notes : Map<String, PlayedNote>;
    private static inline var GAME_VOLUME = 0.5;
}

typedef PlayedNote = {name :String, osc :Oscillator, duration :Duration, pulses :Pulse};