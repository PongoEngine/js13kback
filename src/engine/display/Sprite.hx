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

import engine.display.Canvas;

class Sprite implements Component
{
    public var x (default, set):Float = 0;
    public var y (default, set):Float = 0;
    public var lastX (default, null):Float = 0;
    public var lastY (default, null):Float = 0;
    public var anchorX :Float = 0;
    public var anchorY :Float = 0;
    public var angle :Float = 0;
    public var blendmode :BlendMode = null;

    public function new() : Void
    {
    }

    public function draw(canvas :Canvas) : Void
    {

    }

    public function setBlendmode(blendmode :BlendMode) : Sprite
    {
        this.blendmode = blendmode;
        return this;
    }

    public function setXY(x :Float, y :Float) : Sprite
    {
        this.x = x;
        this.y = y;
        return this;
    }

    public function centerAnchor() : Sprite
    {
        this.anchorX = this.naturalWidth()/2;
        this.anchorY = this.naturalHeight()/2;
        return this;
    }

    public function left(?x :Float) : Float
    {
        if(x == null) {
            x = this.x;
        }
        return x - this.anchorX;
    }

    public function right(?x :Float) : Float
    {
        return this.left(x) + this.naturalWidth();
    }

    public function top(?y :Float) : Float
    {
        if(y == null) {
            y = this.y;
        }
        return y - this.anchorY;
    }

    public function bottom(?y :Float) : Float
    {
        return this.top(y) + this.naturalHeight();
    }

    public function naturalWidth() : Float
    {
        return 0;
    }

    public function naturalHeight() : Float
    {
        return 0;
    }

    private function set_x(x :Float) : Float
    {
        this.lastX = this.x;
        this.x = x;
        return x;
    }

    private function set_y(y :Float) : Float
    {
        this.lastY = this.y;
        this.y = y;
        return y;
    }
}