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

import engine.sound.theory.Octave;
import engine.sound.Track.TrackData;
import engine.display.FillSprite;
import engine.display.ImageSprite;
import engine.display.Sprite;
import engine.display.FlipbookSprite;
import engine.Entity;
import engine.sound.util.SoundFile;
import engine.Engine;
import game.Player;
import game.Enemy;
import game.EnemySystem;
import game.Stage;
import game.collision.Collider;
import game.SoundComp;
import game.ControllerSystem;
import game.OrbitSystem;
import game.CameraSystem;
import game.SoundSystem;
import game.collision.CollisionSystem;
import game.collision.SpatialHash;
import game.CanvasTools;
import game.TileType;
import js.Browser;

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
		var spatialHash = new SpatialHash();
		var tileMap :TileMap = TileMap.parse("./src/game/tiles.dsmap");
		var simplex = new Simplex(4730);
		var backgroundSquare2 = CanvasTools.createGradient(90,10,30,100,TILE_WIDTH,TILE_WIDTH,1, simplex);
		var background = new Entity()
			.add(new ImageSprite(CanvasTools.createTileThing(backgroundSquare2, tileMap, 2200,1200, simplex, 20, 0.01)))
			.add(new Stage())
			.addChild(new Entity()
				.add(new FillSprite(0,0,0,1,3000,3000)
					.setBlendmode(SOFT_LIGHT)));

		engine.root
			.addChild(new Entity()
				.add(new ImageSprite(CanvasTools.createGradient(90,10,30,100,2200,1200,10, simplex))))
			.addChild(background);
		engine.root.add(new SoundComp());

		tileMap.populate(function(x :Int, y :Int, type :TileType, width :Int) {
			switch type {
				case WATERFALL: {
					background.addChild(new Entity()
						.add(new FlipbookSprite(CanvasTools.createGradient(30,30,140,10,TILE_WIDTH*width,TILE_WIDTH*3,10, simplex), 10, 10)
							.setBlendmode(LIGHTEN)
							.setXY(x*TILE_WIDTH, y*TILE_WIDTH)));
				}
				case FLOOR: {
					background.addChild(new Entity()
						.add(new Collider(type, false, 0))
						.add(new ImageSprite(CanvasTools.createGradient(140,140,140,50,TILE_WIDTH*width,TILE_WIDTH,3, simplex))
							// .setBlendmode(HUE)
							.setXY(x*TILE_WIDTH, y*TILE_WIDTH)));
				}
				case WALL: {
					background.addChild(new Entity()
						.add(new Collider(type, false, 0))
						.add(new ImageSprite(CanvasTools.createGradient(100,90,0,50,TILE_WIDTH*width,TILE_WIDTH,3, simplex))
							// .setBlendmode(HUE)
							.setXY(x*TILE_WIDTH, y*TILE_WIDTH)));
				}
				case ENEMY: {
					background.addChild(new Entity()
						.add(new ImageSprite(CanvasTools.createGradient(30,100,110,50,TILE_WIDTH,TILE_WIDTH,10, simplex))
							.onLoaded(img -> {
								img.centerAnchor();
							}).setXY(x*TILE_WIDTH, y*TILE_WIDTH))
						.add(new Enemy())
						.add(new Collider(type, true, 10))
						.addChild(new Entity()
							.add(new ImageSprite(CanvasTools.createGradient(220,220,220,40,15,15,5, simplex))
								.onLoaded(img -> {
									img
										.setXY(2, 15)
										.centerAnchor();
								})))
						.addChild(new Entity()
							.add(new ImageSprite(CanvasTools.createGradient(220,220,220,40,15,15,5, simplex))
								.onLoaded(img -> {
									img
										.setXY(20, 15)
										.centerAnchor();
								}))));
				}
				case PLAYER: {
					background.addChild(new Entity()
						.add(new ImageSprite(CanvasTools.createGradient(130,100,10,50,TILE_WIDTH,TILE_WIDTH,10, simplex))
							.onLoaded(img -> {
								img.centerAnchor();
							}).setXY(x*TILE_WIDTH, y*TILE_WIDTH))
						.add(new Player())
						.add(new Collider(type, true, 40))
						.addChild(new Entity()
							.add(new ImageSprite(CanvasTools.createGradient(220,220,220,40,15,15,5, simplex))
								.onLoaded(img -> {
									img
										.setXY(2, 15)
										.centerAnchor();
								})))
						.addChild(new Entity()
							.add(new ImageSprite(CanvasTools.createGradient(220,220,220,40,15,15,5, simplex))
								.onLoaded(img -> {
									img
										.setXY(20, 15)
										.centerAnchor();
								}))));
				}
			}
		});

		haxe.Timer.delay(() -> {
			engine.iterate(e -> e.has(Collider) && e.has(Sprite), e -> {
				var isFat = e.get(Sprite).naturalWidth() > TILE_WIDTH;
				spatialHash.insert(e, isFat);
				return true;
			});

			engine.addSystem(new ControllerSystem());
			engine.addSystem(new EnemySystem());
			engine.addSystem(new CameraSystem());
			engine.addSystem(new OrbitSystem());
			engine.addSystem(new CollisionSystem(spatialHash));
			var scale = new Scale(Root.D, ScaleType.NATURAL_MINOR);
			var trackData :TrackData = cast SoundFile.parse("./src/game/track.dstrack");
			engine.addSystem(new SoundSystem(Sequencer.create("introSong", trackData, 130, scale)));
		}, 4);
	}
}