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

import engine.display.Sprite;
import engine.display.FillSprite;
import engine.display.CanvasSprite;
import engine.Entity;
import engine.Engine;
import game.Robot;
import game.RobotSystem;
import game.ControllerSystem;
import game.CanvasTools;
import js.Browser;

class Main {
	static function main() {
		var app = Browser.document.getElementById("app");
		var canvas = Browser.document.createCanvasElement();
		canvas.width = 800;
		canvas.height = 600;
		app.appendChild(canvas);
		startGame(new Engine(canvas));
	}

	static inline function startGame(engine :Engine) : Void
	{
		var background = CanvasTools.createGradient(255,200,30,800,600,10);
		var character = CanvasTools.createGradient(20,200,150,40,40,10);
		var c = new Entity();
		engine.root.addChild(c);
		c.addComponent(new CanvasSprite(background));

		var nc = new Entity();
		nc.addComponent(new CanvasSprite(character));
		nc.addComponent(new Robot());
		// nc.getComponent(CanvasSprite).angle = 55;
		nc.getComponent(Sprite).x = 35;
		nc.getComponent(Sprite).y = 35;
		nc.getComponent(CanvasSprite).centerAnchor();
		c.addChild(nc);

		engine.addSystem(new RobotSystem());
		engine.addSystem(new ControllerSystem());
	}
}
