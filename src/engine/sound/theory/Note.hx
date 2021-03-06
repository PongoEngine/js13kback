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

package engine.sound.theory;

@:notNull
extern abstract Note(Int)
{
    inline public function new(val :Int)
    {
        this = val;
    }

    public inline static function note(val :Int) : Note return new Note(val);

    inline public function toInt() : Int return this;

    //Unary
    @:op(A++) static function increment(a :Note) : Note;
    @:op(A--) static function decrement(a :Note) : Note;

    //Arithmetic with Note
    @:op(A % B) static function modulo(a :Note, b :Note) : Note;
    @:op(A * B) static function multiplication(a :Note, b :Note) : Note;
    @:op(A / B) static inline function divideByNote(a :Note, b :Note) : Note return cast Math.floor(a.toInt()/b.toInt());
    @:op(A + B) static function addition(a :Note, b :Note) : Note;
    @:op(A - B) static function subtraction(a :Note, b :Note) : Note;

    //Comparison with Note
    @:op(A == B) static function equal(a :Note, b :Note) : Bool;
    @:op(A != B) static function notEqual(a :Note, b :Note) : Bool;
    @:op(A < B) static function lessThan(a :Note, b :Note) : Bool;
    @:op(A <= B) static function lessThanOrEqual(a :Note, b :Note) : Bool;
    @:op(A > B) static function greaterThan(a :Note, b :Note) : Bool;
    @:op(A >= B) static function greaterThanOrEqual(a :Note, b :Note) : Bool;
}

@:notNull
extern abstract Root(Int)
{
    inline public function toInt() : Int return this;
    public static inline var A :Root = cast 21;
    public static inline var A_SHARP :Root = cast 22;
    public static inline var B :Root = cast 23;
    public static inline var C :Root = cast 24;
    public static inline var C_SHARP :Root = cast 25;
    public static inline var D :Root = cast 26;
    public static inline var D_SHARP :Root = cast 27;
    public static inline var E :Root = cast 28;
    public static inline var F :Root = cast 29;
    public static inline var F_SHARP :Root = cast 30;
    public static inline var G :Root = cast 31;
    public static inline var G_SHARP :Root = cast 32;
}