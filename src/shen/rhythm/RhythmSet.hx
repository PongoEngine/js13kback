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

package shen.rhythm;

import shen.theory.Duration;
import shen.theory.Step;
import shen.util.Tuple;

using Lambda;

class RhythmSet
{
    public var duration (get, never) : Duration;

    inline public function new() : Void
    {
        _rhythmSet = new Map<Step, Rhythm>();
    }

    public static function fromBinary(binary :Array<Tuple<Step, Binary>>, pulseDuration :Duration) : RhythmSet
    {
        var rhythmSet = new RhythmSet();
        binary.iter(function(b) {
            rhythmSet.addRhythm(b.left, new Rhythm(b.right, pulseDuration));
        });

        return rhythmSet;
    }

    public function addRhythm(step :Step, rhythm :Rhythm) : RhythmSet
    {
        _rhythmSet.set(step, rhythm);
        return this;
    }

    public function removeRhythm(step :Step) : Bool
    {
        return _rhythmSet.remove(step);
    }

    inline public function keyValueIterator() : KeyValueIterator<Step, Rhythm>
    {
        return _rhythmSet.keyValueIterator();
    }

    inline private function get_duration() : Duration
    {
        var duration = new Duration(0);
        for(set in _rhythmSet) {
            if(set.duration > duration) {
                duration = set.duration;
            }
        }
        return duration;
    }

    private var _rhythmSet :Map<Step, Rhythm>;
}