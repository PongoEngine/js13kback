package engine.sound;

import js.Syntax;
import js.html.audio.AudioContext;
import js.html.audio.StereoPannerNode;
import js.html.audio.GainNode;
import js.lib.Float32Array;
import js.html.audio.OscillatorNode;
import engine.sound.Frequencies;
import js.html.audio.OscillatorType;
import engine.sound.theory.Duration;
import engine.sound.theory.Pulse;

class Sound
{
    public function new() : Void
    {
        _audioContext = new AudioContext();
        _masterGainNode = _audioContext.createGain();
        _masterGainNode.connect(_audioContext.destination);
        _panner = new StereoPannerNode(_audioContext, {pan:0});
        _masterGainNode.gain.value = 0.2;
        _frequencies = new Frequencies();
        _notes = new Map<String, PlayedNote>();
    }

    public function resume() : Void
    {
        this._audioContext.resume();
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
        _notes.get(key+"").osc.play(_frequencies.get(key), _audioContext, _masterGainNode, type);
    }

    public function checkNotes(pulse :Pulse) : Void
    {
        var itr = _notes.iterator();
        for(note in itr) {
            note.pulses++;
            if(note.pulses >= note.duration) {
                _notes.remove(note.name);
            }
        }
    }

    public function stop(key :Int) : Void
    {
        var note : PlayedNote = untyped _notes[key+""];
        if(note != null) {
            note.osc.stop();
        }
    }

    private var _audioContext : AudioContext;
    private var _masterGainNode : GainNode;
    private var _panner :StereoPannerNode;
    private var _frequencies :Frequencies;
    private var _notes : Map<String, PlayedNote>;
}

typedef PlayedNote = {name :String, osc :Oscillator, duration :Duration, pulses :Pulse};