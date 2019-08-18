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

package shen.rhythm;

extern abstract Intervals(Array<Int>)
{
    inline public function new(val :Array<Int>) : Void
    {
        this = val;
    }

    inline public function toBinary() : Binary
    {
        var arra = [];
        for(val in this) {
            for(i in 0...val) {
                if(i == 0) arra.push(true);
                else arra.push(false);
            }
        }
        return new Binary(arra);
    }

    public static inline function get(type :RhythmType) : Intervals
    {
        return switch type {
            case SHIKO: new Intervals([4,2,4,2,4]);
            case SON: new Intervals([3,3,4,2,4]);
            case SOUKOUS: new Intervals([3,3,4,1,5]);
            case RUMBA: new Intervals([3,4,3,2,4]);
            case BOSSA_NOVA: new Intervals([3,3,4,3,3]);
            case GAHU: new Intervals([3,3,4,4,2]);
        }
    }
}