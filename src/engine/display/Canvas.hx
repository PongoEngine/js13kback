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

package engine.display;

import js.html.ImageElement;
import js.html.CanvasElement;
import js.Browser;
import js.html.CanvasRenderingContext2D;

abstract Canvas(CanvasRenderingContext2D)
{
    public inline function new(canvas :CanvasElement) : Void
    {
        this = canvas.getContext2d();
    }

    @:extern public inline function clear(width :Int, height :Int) : Void
    {
        this.clearRect(0,0,width,height);
    }

    @:extern public inline function save() : Void
    {
        this.save();
    }

    @:extern public inline function restore() : Void
    {
        this.restore();
    }

    public function setColor(r :Int, g :Int, b :Int, a :Int) : Void
    {
        this.fillStyle = 'rgb(${r},${g},${b},${a})';
    }

    @:extern public inline function drawRect(x :Float, y :Float, width :Float, height :Float) : Void
    {
        this.fillRect(x,y,width,height);
    }

    @:extern public inline function drawCanvas(image :ImageElement, x :Float, y :Float) : Void
    {
        this.drawImage(image, x, y);
    }

    @:extern public inline function translate(x :Float, y :Float) : Void
    {
        this.translate(x, y);
    }

    public function rotate(degrees :Float) : Void
    {
        this.rotate(degrees * Math.PI / 180);
    }

    public function setBlendMode(blendmode :BlendMode) : Void
    {
        this.globalCompositeOperation = blendmode;
    }
}

@:enum
abstract BlendMode(String) to String
{
    var NORMAL = "source-over";
    var MULTIPLY = "multiply";
    var SCREEN = "screen";
    var OVERLAY = "overlay";
    var DARKEN = "darken";
    var LIGHTEN = "lighten";
    var COLOR_DODGE = "color-dodge";
    var COLOR_BURN = "color-burn";
    var HARD_LIGHT = "hard-light";
    var SOFT_LIGHT = "soft-light";
    var DIFFERENCE = "difference";
    var EXCLUSION = "exclusion";
    var HUE = "hue";
    var SATURATION = "saturation";
    var COLOR = "color";
    var LUMINOSITY = "luminosity";
}