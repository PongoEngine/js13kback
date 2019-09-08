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

import engine.util.EMath;
import engine.sound.track.Sound;
import engine.sound.track.Envelope;
import js.html.audio.AudioBufferSourceNode;
import js.html.audio.GainNode;
import js.html.audio.AudioContext;
import js.html.audio.AudioNode;

class Oscillator
{
    public function new() : Void
    {
        _buffer = null;
    }

    public function play(freq :Float, samplingFreq :Int, ctx :AudioContext, audio :AudioNode, sound :Sound, envelope :Envelope) : Void
    {
        if(_buffer == null) {
            _gain = ctx.createGain();
            var angularFreq = freq * 2 * Math.PI;
            _buffer = createSound(ctx , angularFreq, sound.length(), samplingFreq, (sampleNumber, freq, data) -> {
                var sampleTime = sampleNumber / samplingFreq;
                var sampleAngle = sampleTime * freq;
                var sineVal :Float = Math.sin(sampleAngle) * sound.sine();
                var squareVal :Float = EMath.sign(Math.sin(sampleAngle)) * sound.square();
                var noiseVal = (Math.random() * 2 - 1) * sound.noise();
                data[sampleNumber] = (sineVal + squareVal + noiseVal) * sound.volume();

            });
            _buffer.connect(_gain);
            _gain.connect(audio);
            _buffer.start();
            var ct = ctx.currentTime;

            _gain.gain.setValueAtTime(0,ct);
            _gain.gain.linearRampToValueAtTime(envelope.attackAmp() ,ct+envelope.attackDur());
            _gain.gain.linearRampToValueAtTime(envelope.sustainAmp(),ct+envelope.attackDur()+envelope.decayDur());
            _gain.gain.linearRampToValueAtTime(envelope.sustainAmp(),ct+envelope.attackDur()+envelope.decayDur()+envelope.sustainDur());
            _gain.gain.linearRampToValueAtTime(0,ct+envelope.attackDur()+envelope.decayDur()+envelope.sustainDur()+envelope.releaseDur());
        }
        else {
            this.stop();
            this.play(freq, samplingFreq, ctx, audio, sound, envelope);
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

    private static function createSound(ctx :AudioContext, freq :Float, length :Float, sampleRate :Float, generateAudio :Int -> Float -> Array<Float> -> Void) : AudioBufferSourceNode
    {
        var data = [];
        var dataLength = Math.ceil(length * sampleRate);
        for (i in 0...dataLength - 1) {
            generateAudio(i, freq, data);
        }
        var bugger = ctx.createBuffer(1, dataLength, sampleRate);
        var bufferSouce = ctx.createBufferSource();
        bugger.getChannelData(0).set(data);
        bufferSouce.buffer = bugger;
        return bufferSouce;
    }

    private var _buffer :AudioBufferSourceNode;
    private var _gain :GainNode;
}