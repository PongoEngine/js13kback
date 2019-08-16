package game;

import js.html.CanvasElement;
import engine.display.Texture;

class CanvasTools
{
    public static function createGradient(r :Int, g :Int, b :Int, width :Int, height :Int, cellWidth :Int) : CanvasElement
    {
        return Texture.create(width, height, function(canvas) {
            var widthLength = Math.round(width / cellWidth);
            var heightLength = Math.round(height / cellWidth);

            for(y in 0...heightLength) {
                for(x in 0...widthLength) {
                    canvas.setColor(val(r, 20),val(g, 20),val(b, 20),1);
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