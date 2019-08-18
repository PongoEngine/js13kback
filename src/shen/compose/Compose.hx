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
import shen.rhythm.RhythmSet;
import shen.midi.Velocity;
import shen.midi.Channel;
import shen.theory.Duration;
import shen.theory.Scale;
import shen.theory.Octave;
import shen.theory.Chord;

class Compose
{
    public static function parallel(funcs :Array<ShenFunc>) : ShenFunc
    {
        return ComposeImpl.parallel.bind(funcs);
    }

    public static function sequence(funcs :Array<ShenFunc>) : ShenFunc
    {
        return ComposeImpl.sequence.bind(funcs);
    }

    public static function modify(pulseModifier :Pulse -> Pulse, shenFunc :ShenFunc) : ShenFunc
    {
        return ComposeImpl.modify.bind(pulseModifier, shenFunc);
    }

    public static function rest(duration :Duration) : ShenFunc
    {
        return ComposeImpl.duration.bind(ComposeImpl.rest, duration);
    }

    public static function repeat(count :Int, shenFunc :ShenFunc) : ShenFunc
    {
        return ComposeImpl.repeat.bind(count, shenFunc);
    }

    public static function arp(chordFn :Scale -> Chord, noteDuration :Duration, velocity :Velocity, channel :Channel, duration :Duration) : ShenFunc
    {
        var a = ComposeImpl.arp.bind(chordFn, noteDuration, velocity, channel);
        return ComposeImpl.duration.bind(a, duration);
    }

    public static function notation(rhythmSet :RhythmSet, octave :Octave, velocity :Velocity, channel :Channel) : ShenFunc
    {
        var a = ComposeImpl.notation.bind(rhythmSet, octave, velocity, channel);
        return ComposeImpl.duration.bind(a, rhythmSet.duration);
    }

    public static function rhythm(rhythmSet :RhythmSet, velocity :Velocity, channel :Channel) : ShenFunc
    {
        var a = ComposeImpl.rhythm.bind(rhythmSet, velocity, channel);
        return ComposeImpl.duration.bind(a, rhythmSet.duration);
    }
}