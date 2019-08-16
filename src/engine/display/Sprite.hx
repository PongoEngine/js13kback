package engine.display;

import engine.display.Canvas;

class Sprite implements Component
{
    public var x :Float = 0;
    public var y :Float = 0;
    public var anchorX :Float = 0;
    public var anchorY :Float = 0;
    public var angle :Float = 0;

    public function new() : Void
    {
    }

    public function draw(canvas :Canvas) : Void
    {

    }

    public function centerAnchor() : Void
    {
        this.anchorX = this.naturalWidth()/2;
        this.anchorY = this.naturalHeight()/2;
    }

    public function naturalWidth() : Float
    {
        return 0;
    }

    public function naturalHeight() : Float
    {
        return 0;
    }
}