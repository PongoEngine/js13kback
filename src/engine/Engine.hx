package engine;

import js.html.CanvasElement;
import engine.display.Sprite;
import engine.Entity;
import engine.display.Canvas;
import engine.System;
import js.Browser;

class Engine 
{
    public var root (default, null) :Entity;

    public function new(canvas :CanvasElement) : Void
    {
        this.root = new Entity();
        this._systems = [];

        var canvas2d = new Canvas(canvas);
        var lastTime :Float = 0;

		function updateFn(time :Float) {
			canvas2d.clear(800, 600);
			var dt = (time - lastTime) * 0.001;
			if(dt < 0) {
				dt = 0;
			}
			lastTime = time;
			update(root, canvas2d, dt, _systems);
			Browser.window.requestAnimationFrame(updateFn);
		}
		Browser.window.requestAnimationFrame(updateFn);
    }

	public inline function addSystem(system :System) : Void
	{
		_systems.push(system);
	}

    private var _systems :Array<System>;

    private static function update(entity :Entity, canvas :Canvas, dt :Float, systems :Array<System>) : Void
	{
		canvas.save();
		for(system in systems) {
			if(system.shouldUpdate(entity)) {
				system.logic(entity, dt);
			}
		}
		var sprite = entity.getComponent(Sprite);
		if(sprite != null) {
			canvas.translate(sprite.x, sprite.y);
			canvas.rotate(sprite.angle);
			canvas.translate(-sprite.anchorX, -sprite.anchorY);
			sprite.draw(canvas);
		}
		for(c in entity.children()) {
			update(c, canvas, dt, systems);
		}
		canvas.restore();
	}
}