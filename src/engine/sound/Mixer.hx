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

import engine.sound.Track.ZZFXSettings;
import engine.sound.Track.ADSR;
import js.html.audio.OscillatorType;
import engine.sound.theory.Duration;
import engine.sound.theory.Pulse;
import engine.sound.synth.Synth;

class Mixer
{
    public function new() : Void
    {
        _synth = new Synth();
    }

    public function mute() : Void
    {
        _synth.mute();
    }

    public function unmute() : Void
    {
        _synth.unmute();
    }

    public function resume() : Void
    {
        _synth.resume();
    }

    public function play(key :Int, start:Pulse, duration :Duration, settings :ZZFXSettings, adsr :ADSR) : Void
    {
        _synth.play(key, start, duration, settings, adsr);
    }

    public function checkNotes(cur :Pulse) : Void
    {
        _synth.checkActive(cur);
    }

    private var _synth :Synth;
}