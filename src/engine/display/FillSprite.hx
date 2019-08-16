package engine.display;

class FillSprite extends Sprite
{
    public var r :Int;
    public var g :Int;
    public var b :Int;
    public var a :Int;
    public var width :Float;
    public var height :Float;

    public function new(r :Int, g :Int, b :Int, a :Int, width :Float, height :Float) : Void
    {
        super();
        this.r = r;
        this.g = g;
        this.b = b;
        this.a = a;
        this.width = width;
        this.height = height;
    }

    override function draw(canvas:Canvas) {
        canvas.setColor(r,g,b,a);
        canvas.drawRect(0, 0, width, height);
    }

    override public function naturalWidth() : Float
    {
        return this.width;
    }

    override public function naturalHeight() : Float
    {
        return this.height;
    }
}