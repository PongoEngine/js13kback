/*
 * MIT License
 *
 * Copyright (c) 2019 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package engine.sound;

import engine.sound.Track;
import engine.sound.theory.Pulse;
import engine.sound.theory.Note;
import engine.sound.theory.Step;
import engine.sound.theory.Octave;
import engine.sound.theory.Duration;
import engine.sound.theory.Scale;
import engine.sound.Mixer;

class Sequencer
{
    public function new(track :Track, trackLength :Duration, bpm :Int, scale :Scale) : Void
    {
        _elapsed = 0;
        _duration = (60 / bpm) / Pulse.PPQN;
        _lastPulse = new Pulse(-1);
        _curPulse = new Pulse(0);
        _track = track;
        _trackLength = trackLength;
    }

    public function update(mixer :Mixer, dt :Float) : Void
    {
        if(_curPulse != _lastPulse) {
            if(_track.exists(_curPulse)) {
                for(note in _track.get(_curPulse)) {
                    mixer.play(note.note.toInt(), note.start, note.duration, note.sound, note.envelope);
                }
            }

            mixer.checkNotes(_curPulse);
            _lastPulse = _curPulse;
        }

        _elapsed += dt;
        if(_elapsed >= _duration) {
            _elapsed = _elapsed - _duration;
            if(_elapsed >= _duration) {
                _elapsed = 0;
            }
            _curPulse++;
        }
        if(_curPulse > _trackLength) {
            _curPulse = new Pulse(0);
            _lastPulse = new Pulse(-1);
        }
    }

    public static function create(name :String, data :TrackData, bpm :Int, scale :Scale) : Sequencer
    {
        var trackInfo = data.tracks.get(name);
        var noteLength = new Duration(16);
        var track = new Map<Pulse, Array<{note:Note,duration:Duration,start:Pulse, sound :Sound, envelope :Envelope}>>();
        var duration = new Duration(0);
        for(section in trackInfo) {
            var env = data.envelopes.get(section.env);
            var snd = data.sounds.get(section.snd);
            var octave = new Octave(section.octave);
            var pulse = new Pulse(0);
            for(loop in section.loops) {
                for(note in data.loops.get(loop)) {
                    var noteData = note.split("|");
                    var offset = new Pulse(Std.parseInt(noteData[0])) * noteLength;
                    pulse += offset;
                    var step = Std.parseInt(noteData[1]);
                    var duration = new Duration(Std.parseInt(noteData[2])) * noteLength;
                    var note = scale.getNote(new Step(step), octave);
                    if(!track.exists(pulse)) {
                        track.set(pulse, []);
                    }
                    track.get(pulse).push({note:note,duration:duration,start:pulse,sound:snd,envelope:env});
                    pulse += duration;
                }
            }
            if(duration < pulse) {
                duration = new Duration(pulse.toInt());
            }
        }
        return new Sequencer(track, duration, bpm, scale);
    }

    private var _track :Track;
    private var _lastPulse :Pulse;
    private var _curPulse :Pulse;
    private var _elapsed :Float;
    private var _duration :Float;
    private var _trackLength :Duration;
}