/*
 * MIT License
 *
 * Copyright (c) 2019 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

package engine;

import js.html.CanvasElement;
import engine.display.Sprite;
import engine.Entity;
import engine.display.Canvas;
import engine.System;
import engine.sound.Sound;
import js.Browser;

class Engine 
{
    public var root (default, null) :Entity;
    public var sound (default, null) :Sound;

    public function new(canvas :CanvasElement) : Void
    {
        this.root = new Entity();
        this._systems = [];
		var hasTouched = false;
		this.sound = new Sound();

		canvas.onclick = function() {
			if(!hasTouched) {
				hasTouched = true;
				this.sound.resume();
			}
		}

        var canvas2d = new Canvas(canvas);
        var lastTime :Float = 0;

		function updateFn(time :Float) {
			canvas2d.clear(800, 600);
			var dt = (time - lastTime) * 0.001;
			if(dt < 0) {
				dt = 0;
			}
			lastTime = time;
			update(this, root, canvas2d, dt, _systems);
			Browser.window.requestAnimationFrame(updateFn);
		}
		Browser.window.requestAnimationFrame(updateFn);
    }

	public function getGroup(fn :Entity -> Bool) : Array<Entity>
	{
		var group = [];
		addToGroup(this.root, fn, group);
		return group;
	}

	public inline function addSystem(system :System) : Void
	{
		_systems.push(system);
	}

    private var _systems :Array<System>;

	private static function addToGroup(entity :Entity, fn :Entity -> Bool, group :Array<Entity>) : Void
	{
		if(fn(entity)) {
			group.push(entity);
		}
		for(c in entity.children()) {
			addToGroup(c, fn, group);
		}
	}

    private static function update(engine :Engine, entity :Entity, canvas :Canvas, dt :Float, systems :Array<System>) : Void
	{
		canvas.save();
		for(system in systems) {
			if(system.shouldUpdate(entity)) {
				system.logic(engine, entity, dt);
			}
		}
		var sprite = entity.get(Sprite);
		if(sprite != null) {
			canvas.translate(sprite.x, sprite.y);
			canvas.rotate(sprite.angle);
			canvas.translate(-sprite.anchorX, -sprite.anchorY);
			canvas.setBlendMode(sprite.blendmode);
			sprite.draw(canvas);
		}
		for(c in entity.children()) {
			update(engine, c, canvas, dt, systems);
		}
		canvas.restore();
	}
}