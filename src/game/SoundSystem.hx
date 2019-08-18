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
import shen.Shen;
import shen.theory.Duration;
import shen.theory.Step;
import shen.theory.Note;
import shen.theory.Note.Root;
import shen.midi.Data;
import shen.rhythm.Pulse;
import shen.midi.Velocity;
import shen.theory.Scale;
import shen.theory.Octave;
import shen.theory.Chord;
import shen.compose.Compose.arp;
import shen.theory.Chord.triad;
import shen.virtual.Msg;
import shen.virtual.Keys;
import shen.virtual.Sage;

class SoundSystem implements System
{
    public function new() : Void
    {
        var shen = new Shen(arp(triad(new Step(0), new Octave(2)), new Duration(12), Velocity.FF, CHANNEL_1, Duration.WHOLE));
		var scale = new Scale(Root.G, ScaleType.MELODIC_MINOR);
		_fn = shen.update.bind(scale);
        _pusle = new Pulse(0);
        _elapsed = 0;
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return true;
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        _elapsed += dt;
        if(_elapsed > 0.2) {
            _elapsed = 0;
            _fn(_pusle);
            _pusle++;
        }
    }

    private var _pusle :Pulse;
    private var _fn :Pulse -> Data;
    private var _elapsed :Float;
}