package engine.sound;

import engine.sound.Track;
import engine.sound.theory.Pulse;
import engine.sound.theory.Note;
import engine.sound.theory.Step;
import engine.sound.theory.Octave;
import engine.sound.theory.Duration;
import js.html.audio.OscillatorType;
import engine.sound.theory.Scale;
import engine.sound.Mixer;

using StringTools;

class Sequencer
{
    public function new(track :Track, scale :Scale) : Void
    {
        _elapsed = 0;
        _duration = (60 / track.bpm) / Pulse.PPQN;
        _lastPulse = new Pulse(-1);
        _curPulse = new Pulse(0);
        _track = track;
        for(trackinfo in _track.infos) {
            trackinfo.notes = createNotes(trackinfo, scale);
        }
    }

    public function update(mixer :Mixer, dt :Float) : Void
    {
        if(_curPulse != _lastPulse) {
            for(info in _track.infos) {
                if(info.notes.exists(_curPulse)) {
                    for(note in info.notes.get(_curPulse)) {
                        mixer.play(note.note.toInt(), note.start, note.duration, note.type, info.adsr);
                    }
                }
            } 

            mixer.checkNotes(_curPulse);
            _lastPulse = _curPulse;
        }

        _elapsed += dt;
        if(_elapsed >= _duration) {
            _elapsed = _elapsed - _duration;
            _curPulse++;
        }
        if(_curPulse > _track.duration) {
            _curPulse = new Pulse(0);
            _lastPulse = new Pulse(-1);
        }
    }

    private static function createNotes(info :TrackInfo, scale :Scale) : Map<Pulse, Array<{note:Note,duration:Duration,start:Pulse, type :OscillatorType}>>
    {
        var notes = new Map<Pulse, Array<{note:Note,duration:Duration,start:Pulse, type :OscillatorType}>>();
        var laneIndex = 0;
        for(lane in info.lanes) {
            var str = (lane + "").replace("|", "");
            var curChar = 0;
            var start = new Pulse(0);
            while(curChar < str.length) {
                if(str.charAt(curChar) != "-") {
                    if(!notes.exists(start)) {
                        notes.set(start, []);
                    }

                    var duration = new Duration(Std.parseInt(str.charAt(curChar)) * info.noteLength.toInt());
                    notes.get(start).push({
                        note: scale.getNote(new Step(laneIndex), info.octave),
                        duration: duration,
                        start: start,
                        type: info.type
                    });
                }
                start += info.noteLength;
                curChar++;
            }
            laneIndex++;
        }
        return notes;
    }

    private var _track :Track;
    private var _lastPulse :Pulse;
    private var _curPulse :Pulse;
    private var _elapsed :Float;
    private var _duration :Float;
}