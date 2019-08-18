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
import engine.display.ImageSprite;
import engine.Entity;
import engine.Engine;
import game.Player;
import game.Stage;
import game.SoundComp;
import game.ControllerSystem;
import game.CameraSystem;
import game.SoundSystem;
import game.CanvasTools;
import js.Browser;

import engine.sound.theory.Scale;
import engine.sound.theory.Scale.ScaleType;
import engine.sound.theory.Note;
import engine.sound.theory.Note.Root;
import engine.sound.theory.Step;
import engine.sound.theory.Pulse;
import engine.sound.theory.Octave;
import engine.sound.theory.Duration;
import engine.sound.Sequencer;
import js.html.audio.OscillatorType;

class Main {
	public static var GAME_WIDTH :Int = 800;
	public static var GAME_HEIGHT :Int = 600;

	static function main() {
		var app = Browser.document.getElementById("app");
		var canvas = Browser.document.createCanvasElement();
		canvas.width = GAME_WIDTH;
		canvas.height = GAME_HEIGHT;
		app.appendChild(canvas);
		startGame(new Engine(canvas));
	}

	static inline function startGame(engine :Engine) : Void
	{
		var background = CanvasTools.createGradient(255,200,30,80,1900,GAME_HEIGHT,10);
		var character = CanvasTools.createGradient(10,40,100,200,40,40,10);
		var c = new Entity();
		engine.root.addChild(c);
		engine.root.add(new SoundComp());
		c.add(new ImageSprite(background));
		c.add(new Stage());

		var nc = new Entity();
		nc.add(new ImageSprite(character));
		nc.get(Sprite).blendmode = NORMAL;
		nc.add(new Player());
		nc.get(Sprite).x = 35;
		nc.get(Sprite).y = 35;
		nc.get(ImageSprite).centerAnchor();
		c.addChild(nc);

		for(i in 0...20) {
			c.addChild(new Entity()
				.add(new ImageSprite(CanvasTools.createCircle(20, 100, 20, 33, 140, 10))
					.centerAnchor()
					.setBlendmode(HARD_LIGHT)
					.setXY(1900 * Math.random(), GAME_HEIGHT * Math.random())));

			c.addChild(new Entity()
				.add(new ImageSprite(CanvasTools.createGradient(140,40,40,50,90,40,3))
					.centerAnchor()
					.setBlendmode(HARD_LIGHT)
					.setXY(1900 * Math.random(), GAME_HEIGHT * Math.random())));
		}

		engine.addSystem(new ControllerSystem());
		engine.addSystem(new CameraSystem());

		var scale = new Scale(Root.A, ScaleType.NATURAL_MINOR);
		engine.addSystem(new SoundSystem(new Sequencer([
			{note:scale.getNote(new Step(0), new Octave(3)), duration:Duration.QUARTER, start:new Pulse(0), type:OscillatorType.SQUARE},
			{note:scale.getNote(new Step(1), new Octave(3)), duration:Duration.QUARTER, start:new Pulse(Duration.QUARTER.toInt()), type:OscillatorType.SQUARE},
			{note:scale.getNote(new Step(2), new Octave(3)), duration:Duration.QUARTER, start:new Pulse(Duration.QUARTER.toInt()*2), type:OscillatorType.SQUARE},
			{note:scale.getNote(new Step(3), new Octave(3)), duration:Duration.QUARTER, start:new Pulse(Duration.QUARTER.toInt()*3), type:OscillatorType.SQUARE},
		], Duration.WHOLE)));
	}
}
