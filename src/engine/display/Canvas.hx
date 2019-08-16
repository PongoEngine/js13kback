package engine.display;

import js.html.CanvasElement;
import js.Browser;
import js.html.CanvasRenderingContext2D;

abstract Canvas(CanvasRenderingContext2D)
{
    public inline function new(canvas :CanvasElement) : Void
    {
        this = canvas.getContext2d();
    }

    @:extern public inline function clear(width :Int, height :Int) : Void
    {
        this.clearRect(0,0,width,height);
    }

    @:extern public inline function save() : Void
    {
        this.save();
    }

    @:extern public inline function restore() : Void
    {
        this.restore();
    }

    public function setColor(r :Int, g :Int, b :Int, a :Int) : Void
    {
        this.fillStyle = 'rgb(${r},${g},${b},${a})';
    }

    @:extern public inline function drawRect(x :Float, y :Float, width :Float, height :Float) : Void
    {
        this.fillRect(x,y,width,height);
    }

    @:extern public inline function drawCanvas(canvas :CanvasElement, x :Float, y :Float) : Void
    {
        this.drawImage(canvas, x, y);
    }

    @:extern public inline function translate(x :Float, y :Float) : Void
    {
        this.translate(x, y);
    }

    public function rotate(degrees :Float) : Void
    {
        this.rotate(degrees * Math.PI / 180);
    }
}