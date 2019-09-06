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

package engine.sound.synth;

import js.html.audio.OscillatorNode;
import js.html.audio.AudioBufferSourceNode;
import js.html.audio.GainNode;
import js.html.audio.AudioContext;
import js.html.audio.OscillatorType;
import js.html.audio.AudioNode;
import engine.sound.Track.ADSR;
import engine.sound.ZZFX;

class Oscillator
{
    public function new() : Void
    {
        _buffer = null;
    }

    public function play(freq :Float, ctx :AudioContext, audio :AudioNode, type :OscillatorType, adsr :ADSR) : Void
    {
        if(_buffer == null) {
            _gain = ctx.createGain();
            _buffer = ZZFX.make(ctx, 1,.1,freq,1,.63,3.8,4.5,.2,.52);
            _buffer.connect(_gain);
            _gain.connect(audio);
            _buffer.start();

            var ct = ctx.currentTime;

            _gain.gain.setValueAtTime(0,ct);
            _gain.gain.linearRampToValueAtTime(adsr.attackAmp ,ct+adsr.attackDur);
            _gain.gain.linearRampToValueAtTime(adsr.sustainAmp,ct+adsr.attackDur+adsr.decayDur);
            _gain.gain.linearRampToValueAtTime(adsr.sustainAmp,ct+adsr.attackDur+adsr.decayDur+adsr.sustainDur);
            _gain.gain.linearRampToValueAtTime(0,ct+adsr.attackDur+adsr.decayDur+adsr.sustainDur+adsr.releaseDur);
        }
        else {
            this.stop();
            this.play(freq, ctx, audio, type, adsr);
        }
    }

    public function stop() : Void
    {
        if(_buffer != null) {
            _buffer.disconnect();
            _gain.disconnect();
            _buffer.stop();
            _buffer = null;
            _gain = null;
        }
    }

    private var _buffer :AudioBufferSourceNode;
    private var _gain :GainNode;
}