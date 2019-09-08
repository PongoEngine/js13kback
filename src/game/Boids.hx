//https://github.com/hughsk/boids/blob/master/index.js

package game;

import engine.display.Sprite;
import engine.util.EMath;
import engine.display.Canvas;

class Boids extends Sprite
{
    public function new(attractors :Array<Sprite>) {
        super();
    }

    override function draw(canvas:Canvas, dt :Float) :Void
    {
        canvas.setColor(0,0,255,1);
    }

}