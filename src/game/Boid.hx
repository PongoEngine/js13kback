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

package game;

import engine.Component;

import engine.display.Sprite;

class Boid implements Component
{
    public var x :Float;
    public var y :Float;
    public var angle :Float;
    public var veloX :Float;
    public var veloY :Float;
    public var target (get, null):{x:Float, y:Float};

    public function new(attractor :Sprite) : Void
    {
        _attractor = attractor;
        this.x = attractor.x + attractor.anchorX;
        this.y = attractor.y + attractor.anchorY;
        this.angle = 0;
        this.veloX = 0;
        this.veloY = 0;
        _target = {x:this.x,y:this.y};
    }

    private function get_target() : {x:Float, y:Float}
    {
        _target.x = _attractor.x;
        _target.y = _attractor.y + _attractor.naturalHeight();
        return _target;
    }

    private var _attractor :Sprite;
    private var _target :{x:Float, y:Float};

}