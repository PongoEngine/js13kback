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

package shen.theory;

import shen.theory.Note;

@:notNull
@:forward(length)
abstract Scale(Array<Note>)
{
    public function new(root :Root, type :ScaleType) : Void
    {
        this = switch (type) {
            case MAJOR: fromSteps(root, [WHOLE,WHOLE,HALF,WHOLE,WHOLE,WHOLE]);
            case NATURAL_MINOR: fromSteps(root, [WHOLE,HALF,WHOLE,WHOLE,HALF,WHOLE]);
            case HARMONIC_MINOR: fromSteps(root, [WHOLE,HALF,WHOLE,WHOLE,HALF,WHOLE+HALF]);
            case MELODIC_MINOR: fromSteps(root, [WHOLE,HALF,WHOLE,WHOLE,WHOLE,WHOLE]);
            case CHROMATIC: fromSteps(root, [HALF,HALF,HALF,HALF,HALF,HALF,HALF,HALF,HALF,HALF,HALF]);
        }
    }

    public function getNote(step :Step, octave :Octave) : Note
    {
        var step = step.toInt();
        var octave = octave.toInt();

        var offsetOctave :Int = Math.floor(step / this.length);
        var rangedStep :Int = step - (offsetOctave*this.length);
        var note :Int = this[rangedStep].toInt() + (12 * (offsetOctave+octave));

        return new Note(note);
    }

    private static function fromSteps(root :Root, steps :Array<Interval>) : Array<Note>
    {
        var root = root.toInt();
        var arra = [new Note(root)];
        for(step in steps) {
            root = root + step;
            arra.push(new Note(root));
        }
        return arra;
    }
}

@:enum
abstract ScaleType(Int)
{
    var MAJOR = 0;
    var NATURAL_MINOR = 1;
    var HARMONIC_MINOR = 2;
    var MELODIC_MINOR = 3;
    var CHROMATIC = 4;
}

@:enum
abstract Interval(Int) to Int
{
    var HALF = 1;
    var WHOLE = 2;

    @:op(A + B) static function addition(a :Interval, b :Interval) : Interval;
}