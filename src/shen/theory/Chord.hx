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
abstract Chord(Array<Note>)
{
    private function new(notes :Array<Note>) : Void
    {
        this = notes;
    }

    @:arrayAccess
    public inline function get(index:Int) {
        return this[index];
    }

    public static inline function triad(step :Step, octave :Octave) : Scale -> Chord
    {
        return function(scale :Scale) {
            return new Chord([
                scale.getNote(step + new Step(0), octave),
                scale.getNote(step + new Step(2), octave),
                scale.getNote(step + new Step(4), octave)
            ]);
        }
    }

    public static inline function quad(step :Step, octave :Octave) : Scale -> Chord
    {
        return function(scale :Scale) {
            return new Chord([
                scale.getNote(step + new Step(0), octave),
                scale.getNote(step + new Step(2), octave),
                scale.getNote(step + new Step(4), octave),
                scale.getNote(step + new Step(6), octave)
            ]);
        }
    }

    public static inline function five(step :Step, octave :Octave) : Scale -> Chord
    {
        return function(scale :Scale) {
            return new Chord([
                scale.getNote(step + new Step(0), octave),
                scale.getNote(step + new Step(2), octave),
                scale.getNote(step + new Step(4), octave),
                scale.getNote(step + new Step(6), octave),
                scale.getNote(step + new Step(8), octave)
            ]);
        }
    }
}