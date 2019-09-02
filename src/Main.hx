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
import engine.display.ImageSprite;
import engine.Entity;
import engine.Engine;
import game.Player;
import game.Orbit;
import game.Stage;
import game.Collider;
import game.SoundComp;
import game.ControllerSystem;
import game.OrbitSystem;
import game.CameraSystem;
import game.SoundSystem;
import game.CollisionSystem;
import game.CanvasTools;
import js.Browser;

import engine.util.Simplex;
import engine.sound.theory.Scale;
import engine.sound.theory.Scale.ScaleType;
import engine.sound.theory.Note.Root;
import engine.sound.Sequencer;
import game.TrackA;
import engine.map.TileMap;

class Main {
	public static var GAME_WIDTH :Int = 800;
	public static var GAME_HEIGHT :Int = 600;
	public static var TILE_WIDTH :Int = 40;

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
		var simplex = new Simplex(938470);
		var background = CanvasTools.createGradient(255,200,30,80,1900,GAME_HEIGHT,10, simplex);
		var character = CanvasTools.createGradient(10,40,100,200,TILE_WIDTH,TILE_WIDTH,10, simplex);
		var ball = CanvasTools.createGradient(220,220,220,200,10,10,1, simplex);
		var c = new Entity();
		engine.root.addChild(c);
		engine.root.add(new SoundComp());
		c.add(new ImageSprite(background));
		c.add(new Stage());

		var x :TileMap = TileMap.parse("./src/game/tiles.dsmap");
		x.populate(function(x :Int, y :Int, type :TileType, width :Int) {
			switch type {
				case FLOOR: {
					c.addChild(new Entity()
						.add(new Collider())
						.add(new ImageSprite(CanvasTools.createGradient(140,40,40,50,TILE_WIDTH*width,TILE_WIDTH,3, simplex))
							.setBlendmode(HARD_LIGHT)
							.setXY(x*TILE_WIDTH, y*TILE_WIDTH)));
				}
				case PLAYER: {
					c.addChild(new Entity()
						.add(new ImageSprite(character)
							.setXY(x*TILE_WIDTH, y*TILE_WIDTH)
							.setBlendmode(DARKEN)
							.centerAnchor())
						.add(new Player())
						.add(new Collider())
						.addChild(new Entity()
							.add(new Orbit(character.width/2, character.height/2))
							.add(new ImageSprite(ball)
								.centerAnchor())));
				}
			}
		});

		engine.addSystem(new ControllerSystem());
		engine.addSystem(new CameraSystem());
		engine.addSystem(new OrbitSystem());
		engine.addSystem(new CollisionSystem());
		var scale = new Scale(Root.D, ScaleType.NATURAL_MINOR);
		engine.addSystem(new SoundSystem(new Sequencer(TrackA.a, scale)));
	}
}

@:enum
abstract TileType(Int) from Int
{
	var FLOOR = 0;
	var PLAYER = 1;
}