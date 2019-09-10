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

import engine.util.Simplex;

class SimplexSprite extends Sprite
{

    public function new(simplex :Void -> Simplex, width :Float, height :Float, tileWidth :Int) : Void
    {
        super();
        _simplex = simplex;
        _x = 0;
        _y = 0;
        _xPercent = 0;
        _yPercent = 0;
        _elapsed = 0;
        _width = width;
        _height = height;
        _tileWidth = tileWidth;
    }

    public function setSimpXY(x :Float, y :Float) : SimplexSprite
    {
        var nX = Math.floor(x / _tileWidth);
        var nXP = (x % _tileWidth) / _tileWidth;
        var nY = Math.floor(y / _tileWidth);
        var nYP = (y % _tileWidth) / _tileWidth;

        _x = nX;
        _xPercent = (nXP+1)%1;
        _y = nY;
        _yPercent = (nYP+1)%1;
        return this;
    }

    override function draw(canvas:Canvas, dt :Float) :Void
    {
        var xPos = 0;
        var yPos = 0;
        _elapsed += dt*0.4;
        while((yPos*_tileWidth) < _height+2) {
            xPos = 0;
            while((xPos*_tileWidth) < _width+2) {
                var canDraw = setColor(canvas, xPos - _x, yPos - _y);
                if(canDraw) {
                    var dX = (xPos-1)*_tileWidth + _xPercent*_tileWidth;
                    var dY = (yPos-1)*_tileWidth + _yPercent*_tileWidth;
                    canvas.drawRect(dX, dY, _tileWidth, _tileWidth);
                }
                xPos += 1;
            }
            yPos += 1;
        }
    }

    private function setColor(canvas:Canvas, x :Int, y :Int) : Bool
    {
        var val = _simplex().get(x, y);
        if(val > 0.98) {
            var alpha = (_simplex().get(x,y+_elapsed) + 1)/2;
            canvas.setColor(255,255,255,alpha);
            return true;
        }
        else if(val > 0.95) {
            canvas.setColor(230,230,230,1);
            return true;
        }
        else {
            return false;
        }
    }

    override public function naturalWidth() : Float
    {
        return _width;
    }

    override public function naturalHeight() : Float
    {
        return _height;
    }

    private var _simplex :Void -> Simplex;
    public var _x :Int;
    public var _y :Int;
    public var _xPercent :Float;
    public var _yPercent :Float;
    public var _width :Float;
    public var _height:Float;
    public var _tileWidth:Int;
    public var _elapsed :Float;
}

@:enum abstract SimplexTile(Int) from Int {
    var WATER = 0;
    var SAND = 1;
    var WALL = 2;
    var FLOOR = 3;
    var CARLA = 4;
}