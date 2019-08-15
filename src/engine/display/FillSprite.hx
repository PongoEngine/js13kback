package engine.display;

class FillSprite extends Sprite
{
    public var color :String;
    public var width :Float;
    public var height :Float;

    public function new(color :String, width :Float, height :Float) : Void
    {
        super();
        this.color = color;
        this.width = width;
        this.height = height;
    }

    override function draw(canvas:Canvas) {
        canvas.setColor(color);
        canvas.drawRect(0, 0, width, height);
    }

    public function centerAnchor() : Void
    {
        this.anchorX = this.width/2;
        this.anchorY = this.height/2;
    }
}