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

package game;

import engine.Entity;
import engine.System;
import engine.Engine;

class SoundSystem implements System
{
    public function new() : Void
    {
        // var seq1 = sequence([
        //     arp(triad(new Step(0), new Octave(2)), new Duration(12), Velocity.FF, CHANNEL_1, Duration.WHOLE),
        //     arp(triad(new Step(1), new Octave(2)), new Duration(12), Velocity.FF, CHANNEL_1, Duration.WHOLE),
        //     arp(triad(new Step(2), new Octave(2)), new Duration(12), Velocity.FF, CHANNEL_1, Duration.WHOLE),
        //     arp(triad(new Step(3), new Octave(2)), new Duration(12), Velocity.FF, CHANNEL_1, Duration.WHOLE)
        // ]);
        // var seq2 = sequence([
        //     arp(triad(new Step(0), new Octave(1)), new Duration(12), Velocity.FF, CHANNEL_1, Duration.WHOLE),
        //     arp(triad(new Step(1), new Octave(1)), new Duration(12), Velocity.FF, CHANNEL_1, Duration.WHOLE),
        //     arp(triad(new Step(2), new Octave(1)), new Duration(12), Velocity.FF, CHANNEL_1, Duration.WHOLE),
        //     arp(triad(new Step(3), new Octave(1)), new Duration(12), Velocity.FF, CHANNEL_1, Duration.WHOLE)
        // ]);
        // var fn = repeat(100000, parallel([seq1, seq2]));
        // var shen = new Shen(fn);
		// var scale = new Scale(Root.F_SHARP, ScaleType.NATURAL_MINOR);
        // _sage = new Sage(new Pulse(0), shen.update.bind(scale));
        _elapsed = 0;
        _bpm = 120;
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.has(SoundComp);
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        _elapsed += dt;
        if(_elapsed > 60000/(_bpm*10000)) {
            _elapsed = 0;
            // _sage.update(engine.sound);
        }
    }

    private var _elapsed :Float;
    // private var _sage :Sage;
    private var _bpm :Int;
}