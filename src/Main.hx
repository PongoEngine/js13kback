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

import js.html.ImageElement;
import engine.display.Texture;
import engine.Component;
import engine.sound.track.TrackData;
import engine.display.FillSprite;
import engine.display.ImageSprite;
import engine.display.Sprite;
import engine.display.FlipbookSprite;
import engine.Entity;
import engine.sound.track.TrackParser;
import engine.Engine;
import game.Player;
import game.Enemy;
import game.EnemySystem;
import game.Boid;
import game.BoidSystem;
import game.Stage;
import game.collision.Collider;
import game.SoundComp;
import game.ControllerSystem;
import game.CameraSystem;
import game.SoundSystem;
import game.collision.CollisionSystem;
// import game.collision.SpatialHash;
import game.CanvasTools;
import game.TileType;
// import game.Boids;
import js.Browser;
import js.lib.Promise;

import engine.util.Simplex;
import engine.sound.theory.Scale;
import engine.sound.theory.Scale.ScaleType;
import engine.sound.theory.Note.Root;
import engine.sound.Sequencer;
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
		var MEGA_HEIGHT = 2200;
		var MEGA_WIDTH= 1600;
		var tileMap :TileMap = TileMap.parse("./src/game/tiles.dsmap");
		var simplex = new Simplex(4730);
		var backgroundSquare2 = CanvasTools.createGradient(60,10,130,100,TILE_WIDTH,TILE_WIDTH,1, simplex);
		var background = new Entity()
			.add(new ImageSprite(CanvasTools.createTileThing(backgroundSquare2, tileMap, MEGA_WIDTH,MEGA_HEIGHT, simplex, 20, 0.01)))
			.add(new Stage())
			.addChild(new Entity()
				.add(new FillSprite(0,0,0,1,MEGA_WIDTH,MEGA_HEIGHT)
					.setBlendmode(SOFT_LIGHT)));

		engine.root
			.addChild(new Entity()
				.add(new ImageSprite(CanvasTools.createGradient(10,10,30,40,MEGA_WIDTH,MEGA_HEIGHT,10, simplex))))
			.addChild(background);
		engine.root.add(new SoundComp());

		tileMap.populate(function(x :Int, y :Int, type :TileType, width :Int) {
			switch type {
				case TILE_WALL: {
					background.addChild(new Entity()
						.add(new Collider(COLLIDER_WALL))
						.add(new ImageSprite(CanvasTools.createGradient(0,0,0,50,TILE_WIDTH*width,TILE_WIDTH,3, simplex))
							// .setBlendmode(HUE)
							.setXY(x*TILE_WIDTH, y*TILE_WIDTH)));
				}
				case TILE_ENEMY: {
					var texture = CanvasTools.createGradient(255,200,210,50,TILE_WIDTH,TILE_WIDTH,10, simplex);
					var enemy = createThing(new Enemy(), texture, simplex, x, y, type);
					background.addChild(enemy);

					for(i in 0...30) {
						background.addChild(new Entity()
							.add(new FillSprite(200,200,200,1,20,10)
								.setBlendmode(OVERLAY)
								.setAnchor(10,5))
							.add(new Collider(COLLIDER_BOID))
							.add(new Boid(enemy.get(Sprite))));
					}
				}
				case TILE_PLAYER: {
					var texture = CanvasTools.createGradient(230,230,220,50,TILE_WIDTH,Std.int(TILE_WIDTH*0.8),10, simplex);
					var player = createThing(new Player(), texture, simplex, x, y, type);
					background.addChild(player);

					for(i in 0...30) {
						background.addChild(new Entity()
							.add(new FillSprite(255,255,255,1,20,10)
								.setBlendmode(OVERLAY)
								.setAnchor(10,5))
							.add(new Collider(COLLIDER_BOID))
							.add(new Boid(player.get(Sprite))));
					}
				}
			}
		});

		haxe.Timer.delay(() -> {
			engine.addSystem(new ControllerSystem());
			engine.addSystem(new EnemySystem());
			engine.addSystem(new CameraSystem());
			engine.addSystem(new CollisionSystem());
			engine.addSystem(new BoidSystem());
			var scale = new Scale(Root.G_SHARP, ScaleType.NATURAL_MINOR);
			var trackData :TrackData = cast TrackParser.parse("./src/game/track.dstrack");
			engine.addSystem(new SoundSystem(Sequencer.create("introSong", trackData, 130, scale)));
		}, 4);
	}

	private static function createThing(comp :Component, mainTexture :Promise<ImageElement>, simplex :Simplex, x :Int, y :Int, type :TileType) : Entity
	{
		// var texture = CanvasTools.createGradient(30,230,220,50,TILE_WIDTH,Std.int(TILE_WIDTH*0.8),10, simplex);
		return new Entity()
			.add(new ImageSprite(mainTexture)
				.onLoaded(img -> {
					img.centerAnchor();
				})
				.setBlendmode(COLOR_DODGE)
				.setXY(x*TILE_WIDTH, y*TILE_WIDTH))
			.add(comp)
			.add(new Collider(COLLIDER_CHARACTER))
			.addChild(new Entity()
				.add(new ImageSprite(CanvasTools.createGradient(0,0,0,40,5,5,5, simplex))
					.onLoaded(img -> {
						img
							.setXY(6, 15)
							.centerAnchor()
							.setBlendmode(MULTIPLY);
					})))
			.addChild(new Entity()
				.add(new ImageSprite(CanvasTools.createGradient(0,0,0,40,5,5,5, simplex))
					.onLoaded(img -> {
						img
							.setXY(15, 15)
							.centerAnchor()
							.setBlendmode(MULTIPLY);
					})));
	}
}