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

import js.Syntax;

abstract Frequencies(Array<Float>)
{
    public inline function new() : Void
    {
        this = [for(i in 0...21) 0];
        var aFreqs = [27.5, 55, 110, 220, 440, 880, 1760, 3520];
        for(freq in aFreqs) {
            this = this.concat(createNotes(freq));
        }
    }

    public function get(index :Int) : Float
    {
        return this[index];
    }

    public static function createNotes(a :Float) : Array<Float>
    {
        var p = Math.pow;
        return [
            a,
            a *  p(2, Syntax.code("1/12")),
            a *  p(2, Syntax.code("2/12")),
            a *  p(2, Syntax.code("3/12")),
            a *  p(2, Syntax.code("4/12")),
            a *  p(2, Syntax.code("5/12")),
            a *  p(2, Syntax.code("6/12")),
            a *  p(2, Syntax.code("7/12")),
            a *  p(2, Syntax.code("8/12")),
            a *  p(2, Syntax.code("9/12")),
            a *  p(2, Syntax.code("10/12")),
            a *  p(2, Syntax.code("11/12")),
        ];
    }
}