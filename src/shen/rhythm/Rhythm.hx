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

class Rhythm
{
    public var duration(get, never) : Duration;

    inline public function new(val :Binary, pulseDuration :Duration) : Void
    {
        _binary = val;
        _pulseDuration = pulseDuration;
    }

    inline public function isHit(pulse :Pulse) : Bool
    {
        if(pulse.toInt() > _binary.length * _pulseDuration.toInt()) return false;
        return _binary.isHit(pulse, _pulseDuration);
    }

    inline public function get_duration() : Duration
    {
        return new Duration(_binary.length * _pulseDuration.toInt());
    }

    private var _binary :Binary;
    private var _pulseDuration :Duration;
}
