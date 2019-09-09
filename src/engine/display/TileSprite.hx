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
import js.lib.Promise;

class TileSprite extends Sprite
{
    public var image :ImageElement = null;

    public function new(image :ImageElement, width :Float, height :Float) : Void
    {
        super();
        this.image = image;
        _width = width;
        _height = height;
    }

    override function draw(canvas:Canvas, dt :Float) : Void
    {
        if(this.image != null) {
            var x = 0;
            var y = 0;
            while(y < _height) {
                x = 0;
                while(x < _width) {
                    canvas.drawImage(image, x, y);
                    x += image.width;
                }
                y += image.height;
            }
        }
    }

    override public function naturalWidth() : Float
    {
        return this.image == null ? 0 : image.width;
    }

    override public function naturalHeight() : Float
    {
        return this.image == null ? 0 : image.height;
    }

    private var _width :Float;
    private var _height :Float;
}