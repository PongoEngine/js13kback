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

class FillSprite extends Sprite
{
    public var r :Int;
    public var g :Int;
    public var b :Int;
    public var a :Float;
    public var width :Float;
    public var height :Float;

    public function new(r :Int, g :Int, b :Int, a :Float, width :Float, height :Float) : Void
    {
        super();
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.width = width;
        this.height = height;
    }

    override function draw(canvas:Canvas) {
        canvas.setColor(r,g,b,a);
        canvas.drawRect(0, 0, width, height);
    }

    override public function naturalWidth() : Float
    {
        return this.width;
    }

    override public function naturalHeight() : Float
    {
        return this.height;
    }
}