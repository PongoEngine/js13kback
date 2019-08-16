package engine.display;

import js.html.CanvasElement;

class CanvasSprite extends Sprite
{
    public var canvasElement :CanvasElement;

    public function new(canvasElement :CanvasElement) : Void
    {
        super();
        this.canvasElement = canvasElement;
    }

    override function draw(canvas:Canvas) : Void
    {
        canvas.drawCanvas(canvasElement, 0, 0);
    }

    override public function naturalWidth() : Float
    {
        return canvasElement.width;
    }

    override public function naturalHeight() : Float
    {
        return canvasElement.height;
    }
}