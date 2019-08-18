/*
 * Copyright (c) 2018 Jeremy Meltingtallow
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

package shen.compose;

import shen.Shen;
import shen.rhythm.Pulse;
import shen.midi.Velocity;
import shen.midi.Channel;
import shen.midi.Data;
import shen.theory.Duration;
import shen.theory.Scale;
import shen.theory.Note;
import shen.theory.Note.Root;
import shen.theory.Octave;
import shen.theory.Chord;
import shen.rhythm.RhythmSet;
import shen.util.Tuple.tuple;

class ComposeImpl
{
    public static function duration(func :Pulse -> Scale -> Data, duration :Duration, prevDuration :Duration, pulse :Pulse, scale :Scale) : Tuple<Data, Duration>
    {
        var p :Pulse = pulse - prevDuration;
        var data = new Data();
        if(p >= new Duration(0) && p < duration) {
            data += func(p, scale);
        }
        return tuple(data, duration);
    }
    
    public static function parallel(funcs :Array<ShenFunc>, prevDuration :Duration, pulse :Pulse, scale :Scale) : Tuple<Data, Duration>
    {
        var curDuration = new Duration(0);
        var data = new Data();
        for(func in funcs) {
            var shenValue :Tuple<Data, Duration> = func(prevDuration, pulse, scale);
            if(shenValue.right > curDuration) {
                curDuration = shenValue.right;
            }
            data += shenValue.left;
        }
        return tuple(data, curDuration);
    }

    public static function sequence(funcs :Array<ShenFunc>, prevDuration :Duration, pulse :Pulse, scale :Scale) : Tuple<Data, Duration>
    {
        var data = new Data();
        for(func in funcs) {
            var shenValue :Tuple<Data, Duration> = func(prevDuration, pulse, scale);
            prevDuration += shenValue.right;
            data += shenValue.left;
        }
        return tuple(data, prevDuration);
    }

    public static function modify(pulseModifier :Pulse -> Pulse, func :ShenFunc, prevDuration :Duration, pulse :Pulse, scale :Scale) : Tuple<Data, Duration>
    {
        var p = pulseModifier(pulse);
        var val = func(prevDuration, p * new Pulse(6), scale);
        return tuple(val.left, val.right);
    }

    public static function repeat(count :Int, func :ShenFunc, prevDuration :Duration, pulse :Pulse, scale :Scale) : Tuple<Data, Duration>
    {
        if(count > 0) {
            return sequence([for (i in 0...count) func], prevDuration, pulse, scale);
        }
        return tuple(new Data(), prevDuration);
    }

    public static function notation(rhythmSet :RhythmSet, octave :Octave, velocity :Velocity, channel :Channel, pulse :Pulse, scale :Scale) : Data
    {
        var data = new Data();
        for(step => rhythm in rhythmSet) {
            if(rhythm.isHit(pulse)) {
                var note :Note = scale.getNote(step, octave);
                data.playNote(note, Duration.EIGHTH, velocity, channel);
            }
        }
        return data;
    }

    public static function rhythm(rhythmSet :RhythmSet, velocity :Velocity, channel :Channel, pulse :Pulse, scale :Scale) : Data
    {
        var data = new Data();
        for(step => rhythm in rhythmSet) {
            if(rhythm.isHit(pulse)) {
                var note :Note = DRUM_SCALE.getNote(step, new Octave(1));
                data.playNote(note, Duration.EIGHTH, velocity, channel);
            }
        }
        return data;
    }

    public static function arp(chordFn :Scale -> Chord, noteDuration :Duration, velocity :Velocity, channel :Channel, pulse :Pulse, scale :Scale) : Data
    {
        var number :Int = cast(pulse.toInt() / noteDuration.toInt());
        var data = new Data();
        if(number % 1 == 0) {
            var chord = chordFn(scale);
            var noteIndex :Int = Std.int(number % chord.length);
            var rev = chord.length - (noteIndex+1);

            data.playNote(chord[noteIndex], noteDuration, velocity, channel);
        }

        return data;
    }

    public static function rest(pulse :Pulse, scale :Scale) : Data
    {
        return new Data();
    }

    private static var DRUM_SCALE = new Scale(Root.C, CHROMATIC);
}