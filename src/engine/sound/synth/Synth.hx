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

import engine.sound.track.Sound;
import engine.sound.track.Envelope;
import js.html.audio.AudioContext;
import js.html.audio.BiquadFilterNode;
import js.html.audio.ConvolverNode;
import js.html.audio.GainNode;
import engine.sound.synth.Frequencies;
import engine.sound.theory.Duration;
import engine.sound.theory.Pulse;
import js.html.audio.BiquadFilterType;
import js.html.audio.AudioBuffer;

class Synth
{
    public function new() : Void
    {
        _audioContext = new AudioContext({sampleRate: 44100});
        _equalizerNode = _audioContext.createBiquadFilter();
        _equalizerNode.type = BiquadFilterType.ALLPASS;
        _reverbNode = _audioContext.createConvolver();
        _reverbNode.buffer = impulseResponse(0.4, 1, false);
        _masterGainNode = _audioContext.createGain();

        _equalizerNode.connect(_reverbNode);
        _reverbNode.connect(_masterGainNode);
        
        _masterGainNode.connect(_audioContext.destination);

        _masterGainNode.gain.setValueAtTime(GAME_VOLUME, _audioContext.currentTime);
        _frequencies = new Frequencies();
    }

    public inline function mute() : Void
    {
        _masterGainNode.gain.setValueAtTime(0, _audioContext.currentTime);
    }

    public inline function unmute() : Void
    {
        _masterGainNode.gain.setValueAtTime(GAME_VOLUME, _audioContext.currentTime);
    }

    public inline function resume() : Void
    {
        this._audioContext.resume();
    }

    public function play(key :Int, pulseLength :Float, start:Pulse, duration :Duration, sound :Sound, envelope :Envelope) : Void
    {
        var length :Float = duration.toInt() * pulseLength;
        Oscillator.play(length, _frequencies.get(key), 44100, _audioContext, _masterGainNode, sound, envelope);
    }

    private function impulseResponse(duration :Float, decay :Float, reverse :Bool ) : AudioBuffer
    {
        var sampleRate = _audioContext.sampleRate;
        var length :Int = Math.round(sampleRate * duration);
        var impulse = _audioContext.createBuffer(2, length, sampleRate);
        var impulseL = impulse.getChannelData(0);
        var impulseR = impulse.getChannelData(1);

        for (i in 0...length){
            var n = reverse ? length - i : i;
            impulseL[i] = (Math.random() * 2 - 1) * Math.pow(1 - n / length, decay);
            impulseR[i] = (Math.random() * 2 - 1) * Math.pow(1 - n / length, decay);
        }
        return impulse;
    }

    private var _audioContext : AudioContext;
    private var _masterGainNode : GainNode;
    private var _reverbNode :ConvolverNode;
    private var _equalizerNode :BiquadFilterNode;
    private var _frequencies :Frequencies;
    private static inline var GAME_VOLUME = 1;
}