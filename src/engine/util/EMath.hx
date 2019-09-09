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

package engine.util;

import engine.display.Sprite;

class EMath
{
    public static inline var PI = 3.141592653589793;

    public static function angle(x1 :Float, y1 :Float, x2 :Float, y2 :Float) : Float
    {
        return Math.atan2(y2 - y1, x2 - x1);
    }

    public static function distance(x1 :Float, y1 :Float, x2 :Float, y2 :Float) : Float
    {
        var a = x1 - x2;
        var b = y1 - y2;
        return Math.sqrt( a*a + b*b );
    }

    public static function cubeOut (t :Float) :Float
    {
        return 1 + (--t) * t * t;
    }

    public static function clamp<T:Float>(val :T, min :T, max :T) : T
    {
        return cast Math.min(Math.max(val, min), max);
    }

    public static function sign(number :Float) : Int
    {
        if (number < 0) {
            return -1;
        } else if (number > 0) {
            return 1;
        }
        return 0;
    }

    public static function bounceOut (t :Float) :Float
    {
        if (t < B1) return 7.5625 * t * t;
        if (t < B2) return 7.5625 * (t - B3) * (t - B3) + .75;
        if (t < B4) return 7.5625 * (t - B5) * (t - B5) + .9375;
        return 7.5625 * (t - B6) * (t - B6) + .984375;
    }

    private static inline var PIhalf :Float = EMath.PI / 2;
    private static inline var PI2 :Float = EMath.PI * 2;
    private static inline var B1 :Float = 1 / 2.75;
    private static inline var B2 :Float = 2 / 2.75;
    private static inline var B3 :Float = 1.5 / 2.75;
    private static inline var B4 :Float = 2.5 / 2.75;
    private static inline var B5 :Float = 2.25 / 2.75;
    private static inline var B6 :Float = 2.625 / 2.75;
    private static inline var ELASTIC_AMPLITUDE :Float = 1;
    private static inline var ELASTIC_PERIOD :Float = 0.4;
}