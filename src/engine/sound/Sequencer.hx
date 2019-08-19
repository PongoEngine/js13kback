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
        _pulse = new Pulse(0);
        _track = track;
        for(trackinfo in _track.infos) {
            trackinfo.notes = createNotes(trackinfo, scale);
        }
    }

    public function update(mixer :Mixer, dt :Float) : Void
    {
        for(info in _track.infos) {
            if(info.notes.exists(_pulse)) {
                for(note in info.notes.get(_pulse)) {
                    mixer.play(note.note.toInt(), note.start, note.duration, note.type, info.asdr);
                }
            }
        } 

        mixer.checkNotes(_pulse);

        _pulse++;

        if(_pulse > _track.duration) {
            _pulse = new Pulse(0);
        }
    }

    private static function createNotes(track :TrackInfo, scale :Scale) : Map<Pulse, Array<{note:Note,duration:Duration,start:Pulse, type :OscillatorType}>>
    {
        var notes = new Map<Pulse, Array<{note:Note,duration:Duration,start:Pulse, type :OscillatorType}>>();
        var laneIndex = 0;
        for(lane in track.lanes) {
            var str = (lane + "").replace("|", "");
            var curChar = 0;
            var start = new Pulse(0);
            while(curChar < str.length) {
                if(str.charAt(curChar) != "-") {
                    if(!notes.exists(start)) {
                        notes.set(start, []);
                    }

                    var duration = new Duration(Std.parseInt(str.charAt(curChar)) * track.noteLength.toInt());
                    notes.get(start).push({
                        note: scale.getNote(new Step(laneIndex), new Octave(2)),
                        duration: duration,
                        start: start,
                        type: track.type
                    });
                }
                start += track.noteLength;
                curChar++;
            }
            laneIndex++;
        }
        return notes;
    }

    private var _track :Track;
    private var _pulse :Pulse;
}