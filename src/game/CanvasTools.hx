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

import js.html.CanvasElement;
import engine.display.Texture;

class CanvasTools
{
    public static function createGradient(r :Int, g :Int, b :Int, randomAmount :Int, width :Int, height :Int, cellWidth :Int) : CanvasElement
    {
        return Texture.create(width, height, function(canvas) {
            var widthLength = Math.round(width / cellWidth);
            var heightLength = Math.round(height / cellWidth);

            for(y in 0...heightLength) {
                for(x in 0...widthLength) {
                    canvas.setColor(val(r, randomAmount),val(g, randomAmount),val(b, randomAmount),1);
                    canvas.drawRect(x*cellWidth, y*cellWidth, cellWidth, cellWidth);
                }
            }
        });
    }

    private static function val(input :Int, change :Int) :Int
    {
        var min = input - change;
        return Math.floor(min + (change/2) + (change * Math.random()));
    }
}