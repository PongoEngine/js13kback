package engine.sound;

import engine.sound.theory.Pulse;
import engine.sound.theory.Note;
import engine.sound.theory.Duration;
import js.html.audio.OscillatorType;

class Sequencer
{
    public function new(notes :Array<{note:Note,duration:Duration,start:Pulse, type :OscillatorType}>, duration :Duration) : Void
    {
        _curPulse = new Pulse(0);
        _notes = notes;
        _noteIndex = 0;
        _duration = duration;
    }

    public function update(sound :Sound) : Void
    {
        var note = _notes[_noteIndex];
        while(note != null) {
            if(note.start <= _curPulse) {
                sound.play(note.note.toInt(), note.duration, note.type);
                note = _notes[_noteIndex++];
            }
            else {
                note = null;
            }
            note = null;
        }
        sound.checkNotes();
        _curPulse++;

        if(_curPulse > _duration) {
            _curPulse = new Pulse(0);
            _noteIndex = 0;
        }
    }

    private var _curPulse :Pulse;
    private var _duration :Duration;
    private var _notes :Array<{note:Note,duration:Duration,start:Pulse, type :OscillatorType}>;
    private var _noteIndex :Int;
}