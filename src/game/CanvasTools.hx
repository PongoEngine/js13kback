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

import engine.display.Canvas;
import js.html.ImageElement;
import engine.display.Texture;

class CanvasTools
{
    public static function createGradient(r :Int, g :Int, b :Int, randomAmount :Int, width :Int, height :Int, cellWidth :Int) : ImageElement
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

    public static function createCircle(r :Int, g :Int, b :Int, randomAmount :Int, radius :Int, cellWidth :Int) : ImageElement
    {
        var count = Math.floor(radius/cellWidth) / 2;
        return Texture.create(radius*2+cellWidth, radius*2+cellWidth, function(canvas) {
            var offset = 0;
            var i = 0;
            while(radius > 0) {
                drawCircle(canvas, r, g, b, i/count, radius, cellWidth, offset, offset);
                radius -= cellWidth;
                offset += cellWidth;
                i++;
            }
        });
    }

    private static function drawCircle(canvas :Canvas, r :Int, g :Int, b :Int, a :Float, radius :Int, cellWidth :Int, offsetX :Int, offsetY :Int) {
        var x = radius;
        var y = 0;
        var radiusError = 1 - x;
        var x0 = radius + offsetX;
        var y0 = radius + offsetY;
        canvas.setColor(r,g,b,a);
        while (x >= y) {
            drawPixel(canvas, x + x0, y + y0, cellWidth);
            drawPixel(canvas, y + x0, x + y0, cellWidth);
            drawPixel(canvas, -x + x0, y + y0, cellWidth);
            drawPixel(canvas, -y + x0, x + y0, cellWidth);
            drawPixel(canvas, -x + x0, -y + y0, cellWidth);
            drawPixel(canvas, -y + x0, -x + y0, cellWidth);
            drawPixel(canvas, x + x0, -y + y0, cellWidth);
            drawPixel(canvas, y + x0, -x + y0, cellWidth);
            y+=cellWidth;

            if (radiusError < 0) {
                radiusError += 2 * y + 1;
            }
            else {
                x-=cellWidth;
                radiusError+= 2 * (y - x + 1);
            }
        }
    }

    private static function drawPixel(canvas :Canvas, x :Int, y :Int, cellWidth :Int) {
        canvas.drawRect(x, y, cellWidth, cellWidth);
    }

    private static function val(input :Int, change :Int) :Int
    {
        var min = input - change;
        return Math.floor(min + (change/2) + (change * Math.random()));
    }
}