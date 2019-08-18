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
import js.html.audio.OscillatorType;
import engine.sound.Sequencer;


class SoundSystem implements System
{
    public function new(sequence :Sequencer) : Void
    {
        _elapsed = 0;
        _bpm = 120;
        _sequence = sequence;
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.has(SoundComp);
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        _elapsed += dt;
        if(_elapsed > 6/_bpm) {
            _elapsed = 0;
            _sequence.update(engine.sound);
        }
    }

    private var _elapsed :Float;
    private var _bpm :Int;
    private var _sequence :Sequencer;
}