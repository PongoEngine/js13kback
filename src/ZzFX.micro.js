
/*
    ZzFX - Zuper Zmall Zeeded Zound Zynth
    By Frank Force 2019
*/
/*
  ZzFX MIT License
  
  Copyright (c) 2019 - Frank Force
  
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  
  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.
  
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
  
*/

"use strict"; // strict mode

//////////////////////////////////////////////////////////////////////////////////////

// ZZFXmicro - lightweight version with just a Z function to play sounds

// ==ClosureCompiler==
// @compilation_level ADVANCED_OPTIMIZATIONS
// @output_file_name ZzFx.micro.js
// @js_externs zzfx, zzfx_x, zzfx_v
// ==/ClosureCompiler==
let zzfx_v = .5;               // volume
// let zzfx_x = new AudioContext; // audio context
window.zzfx = function zzfx                  // play a sound
(
    ctx,
    volume, 
    randomness,
    frequency, 
    length=1,
    attack=.1,
    slide=0,
    noise=0,
    modulation=0,
    modulationPhase=0
)
{
    let sampleRate = 44100;
    frequency *= 2*Math.PI / sampleRate;
    frequency *= (1 + randomness*(Math.random()*2-1));
    slide *= Math.PI * 1e3 / sampleRate**2;
    length = length>0? (length>10?10:length) * sampleRate | 0 : 1;
    attack *= length | 0;
    modulation *= 2*Math.PI / sampleRate;
    modulationPhase *= Math.PI;

    // generate the waveform
    let b = [], f = 0, fm = 0;
    for(let F = 0; F < length; ++F)
    {
        b[F] = volume * zzfx_v *                           // volume
            Math.cos(f * frequency *                       // frequency
            Math.cos(fm * modulation + modulationPhase)) * // modulation
            (F < attack ? F / attack:                      // attack
            1 - (F - attack)/(length - attack));           // decay
        f += 1+noise*(Math.random()*2-1);                  // noise
        fm += 1+noise*(Math.random()*2-1);                 // modulation noise
        frequency += slide;                                // frequency slide
    }

    // play the sound
    let B = ctx.createBuffer(1, length, sampleRate);
    let S = ctx.createBufferSource();
    B.getChannelData(0).set(b);
    S.buffer = B;
    // S.connect(zzfx_x.destination);
    // S.start();
    return S;
}