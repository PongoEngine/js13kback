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
// import js.html.audio.GainNode;
import js.html.audio.AudioContext;
import js.html.audio.AudioNode;

class Oscillator
{
    public function new() : Void
    {
        _buffer = null;
    }

    public function play(length :Float, freq :Float, samplingRate :Int, ctx :AudioContext, audio :AudioNode, sound :Sound, envelope :Envelope) : Void
    {
        if(_buffer == null) {
            var angularFreq = freq * 2 * Math.PI;
            _buffer = createSound(ctx, samplingRate, angularFreq, length, sound, envelope, generateSound);
            _buffer.connect(audio);
            _buffer.start();
        }
        else {
            this.stop();
            this.play(length, freq, samplingRate, ctx, audio, sound, envelope);
        }
    }

    public function stop() : Void
    {
        if(_buffer != null) {
            _buffer.disconnect();
            // _gain.disconnect();
            _buffer.stop();
            _buffer = null;
            // _gain = null;
        }
    }

    private static function createSound(ctx :AudioContext, samplingRate :Int, freq :Float, length :Float, sound :Sound, envelope :Envelope, generateAudio :SoundGenerator) : AudioBufferSourceNode
    {
        var data = [];
        var dataLength = Math.ceil(length * samplingRate);
        for (i in 0...dataLength - 1) {
            generateAudio(samplingRate, freq, sound, envelope, data, i);
        }
        var buffer = ctx.createBuffer(1, dataLength, samplingRate);
        var bufferSouce = ctx.createBufferSource();
        buffer.getChannelData(0).set(data);
        bufferSouce.buffer = buffer;
        return bufferSouce;
    }

    private static function generateSound(samplingRate :Int, freq :Float, sound :Sound, envelope :Envelope, data :Array<Float>, sampleNumber :Int) : Void
    {
        var sampleTime = sampleNumber / samplingRate;
        var sampleAngle = sampleTime * freq;
        var sineVal :Float = Math.sin(sampleAngle) * sound.sine();
        var squareVal :Float = EMath.sign(Math.sin(sampleAngle)) * sound.square();
        var noiseVal = (Math.random() * 2 - 1) * sound.noise();

        var attackLength = samplingRate * envelope.attackDur();
        var decayLength = samplingRate * envelope.decayDur();
        var adsr :Float = 0;
        
        if(sampleNumber < attackLength) {
            var percent = sampleNumber / attackLength;
            adsr = percent * envelope.attackAmp();
        }
        else if((sampleNumber - attackLength) < decayLength) {
            var percent = (sampleNumber - attackLength) / decayLength;
            adsr = tween(envelope.attackAmp(), envelope.sustainAmp(), percent);
        }
        else {
            adsr = envelope.sustainAmp();
        }


        data[sampleNumber] = (sineVal + squareVal + noiseVal) * adsr * sound.volume();
    }

    private static inline function tween(start :Float, end :Float, percent :Float) : Float
    {
        return start + (percent * (end-start));
    }

    private var _buffer :AudioBufferSourceNode;
    // private var _gain :GainNode;
}