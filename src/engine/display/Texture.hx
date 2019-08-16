package engine.display;

import js.html.CanvasElement;
import js.Browser;

class Texture
{
    public static function create(width :Int, height :Int, draw :Canvas -> Void) : CanvasElement
    {
        var canvas = Browser.document.createCanvasElement();
        canvas.width = width;
        canvas.height = height;
        draw(new Canvas(canvas));
        return canvas;
    }
}