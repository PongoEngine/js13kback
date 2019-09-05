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

class FlipbookSprite extends Sprite
{
    public var image :ImageElement = null;

    public function new(image :Promise<ImageElement>, width :Float, height :Float) : Void
    {
        super();
        image.then(img -> {
            this.image = img;
            _onLoaded(this);
        });
        _width = width;
        _height = height;
    }

    override function draw(canvas:Canvas, dt :Float) : Void
    {
        if(this.image != null) {
            canvas.drawCanvas(image, 0, 0);
        }
    }

    public function onLoaded(fn :FlipbookSprite -> Void) : FlipbookSprite
    {
        _onLoaded = fn;
        return this;
    }

    override public function naturalWidth() : Float
    {
        return _width;
    }

    override public function naturalHeight() : Float
    {
        return _height;
    }

    private var _onLoaded : FlipbookSprite -> Void = img -> {};
    private var _width :Float;
    private var _height :Float;
}