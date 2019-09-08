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

    public function setColor(r :Int, g :Int, b :Int, a :Float) : Void
    {
        this.fillStyle = 'rgb(${r},${g},${b},${a})';
    }

    @:extern public inline function drawRect(x :Float, y :Float, width :Float, height :Float) : Void
    {
        this.fillRect(x,y,width,height);
    }

    @:extern public inline function drawImage(image :ImageElement, dx :Float, dy :Float) : Void
    {
        this.drawImage(image, dx, dy);
    }

    @:extern public inline function drawSubimage(image :ImageElement, dx :Float, dy :Float, sx :Float, sy :Float, dWidth :Float, dHeight :Float) : Void
    {
        this.drawImage(image, sx, sy, dWidth, dHeight, dx, dy, dWidth, dHeight);
    }

    @:extern public inline function translate(x :Float, y :Float) : Void
    {
        this.translate(x, y);
    }

    @:extern public inline function scale(x :Float, y :Float) : Void
    {
        this.scale(x, y);
    }

    public function rotate(radians :Float) : Void
    {
        this.rotate(radians);
    }

    public function setBlendMode(blendmode :BlendMode) : Void
    {
        this.globalCompositeOperation = blendmode;
    }
}