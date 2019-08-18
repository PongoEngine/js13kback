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

@:forward(length)
abstract Binary(Array<Bool>)
{
    public static inline var x = true;
    public static inline var _ = false;

    inline public function new(val :Array<Bool>) : Void
    {
        this = val;
    }

    inline public function isHit(pulse :Pulse, pulseDuration :Duration) : Bool
    {
        if((pulse.toInt() / pulseDuration.toInt()) % 1 == 0) {
            var index = pulse / new Pulse(pulseDuration.toInt());
            return this[index.toInt()];
        }

        return false;
    }

    inline public function shift(n :Int) : Binary
    {
        var binary :Array<Bool> = [for (i in 0...n) false];
        for(i in 0...this.length) {
            binary[i] = this[((i+this.length)-n) % this.length];
        }
        return cast binary;
    }

    public static inline function get(type :RhythmType) : Binary
    {
        return Intervals.get(type).toBinary();
    }

    inline public static function binary(val :Array<Bool>) : Binary
    {
        return new Binary(val);
    }
}

