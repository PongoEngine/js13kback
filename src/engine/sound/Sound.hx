package engine.sound;

import js.html.audio.AudioContext;
import js.html.audio.StereoPannerNode;
import js.html.audio.GainNode;
import js.lib.Float32Array;
import js.html.audio.OscillatorNode;
import engine.sound.Keys;

class Sound
{
    public function new() : Void
    {
        _audioContext = new AudioContext();
        _masterGainNode = _audioContext.createGain();
        _masterGainNode.connect(_audioContext.destination);
        _panner = new StereoPannerNode(_audioContext, {pan:0});

        var sineTerms = new Float32Array([0, 0, 1, 0, 1]);
        var cosineTerms = new Float32Array(sineTerms.length);
        var wav = _audioContext.createPeriodicWave(cosineTerms, sineTerms);
        _notes = new Keys(_audioContext, _masterGainNode, wav);
    }

    public function resume() : Void
    {
        this._audioContext.resume();
    }

    public function play(key :Key, octave :Int) : Void
    {
        _notes.get(key, octave).play();
    }

    private var _audioContext : AudioContext;
    private var _masterGainNode : GainNode;
    private var _panner :StereoPannerNode;
    private var _osc :OscillatorNode;
    private var _notes :Keys;
}