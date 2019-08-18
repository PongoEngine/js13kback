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

package shen.midi;

extern abstract Velocity(Int)
{
    inline public function new(val :Int)
    {
        this = val.clamp(0, 127);
    }

    public inline static function velocity(val :Int) : Velocity return new Velocity(val);

    public static inline var PPP = cast 15;
    public static inline var PP = cast 31;
    public static inline var P = cast 47;
    public static inline var MP = cast 63;
    public static inline var MF = cast 79;
    public static inline var F = cast 95;
    public static inline var FF = cast 111;
    public static inline var FFF = cast 127;

    inline public function toInt() : Int return this;

    //Unary
    @:op(A++) static function increment(a :Velocity) : Velocity;
    @:op(A--) static function decrement(a :Velocity) : Velocity;

    //Arithmetic with Velocity
    @:op(A % B) static function modulo(a :Velocity, b :Velocity) : Velocity;
    @:op(A * B) static function multiplication(a :Velocity, b :Velocity) : Velocity;
    @:op(A / B) static inline function divideByVelocity(a :Velocity, b :Velocity) : Velocity return cast Math.floor(a.toInt()/b.toInt());
    @:op(A + B) static function addition(a :Velocity, b :Velocity) : Velocity;
    @:op(A - B) static function subtraction(a :Velocity, b :Velocity) : Velocity;

    //Comparison with Velocity
    @:op(A == B) static function equal(a :Velocity, b :Velocity) : Bool;
    @:op(A != B) static function notEqual(a :Velocity, b :Velocity) : Bool;
    @:op(A < B) static function lessThan(a :Velocity, b :Velocity) : Bool;
    @:op(A <= B) static function lessThanOrEqual(a :Velocity, b :Velocity) : Bool;
    @:op(A > B) static function greaterThan(a :Velocity, b :Velocity) : Bool;
    @:op(A >= B) static function greaterThanOrEqual(a :Velocity, b :Velocity) : Bool;
}