package engine.display;

class GradientFillSprite extends Sprite
{
    public var color :Int;
    public var width :Float;
    public var height :Float;

    public function new(color :Int, width :Float, height :Float) : Void
    {
        super();
        this.color = color;
        this.width = width;
        this.height = height;

        _colors = [];
        var cellWidth = 10;
        var widthLength = Math.round(this.width / cellWidth);
        var heightLength = Math.round(this.height / cellWidth);

        for(i in 0...heightLength*widthLength) {
            _colors.push(color + Math.round(100 * Math.random()));
        }
    }

    override function draw(canvas:Canvas) {
        var cellWidth = 10;
        var widthLength = Math.round(this.width / cellWidth);
        var heightLength = Math.round(this.height / cellWidth);

        for(y in 0...heightLength) {
            for(x in 0...widthLength) {
                canvas.setColor(_colors[x + (widthLength*y)]);
                canvas.drawRect(x*cellWidth, y*cellWidth, cellWidth, cellWidth);
            }
        }
    }

    public function centerAnchor() : Void
    {
        this.anchorX = this.width/2;
        this.anchorY = this.height/2;
    }

    private var _colors :Array<Int>;
}