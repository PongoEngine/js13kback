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
import engine.Component;
import engine.sound.track.TrackData;
import engine.display.FillSprite;
import engine.display.ImageSprite;
import engine.display.Sprite;
import engine.display.TileSprite;
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
import game.BackgroundSystem;

import engine.util.Simplex;
import engine.sound.theory.Scale;
import engine.sound.theory.Scale.ScaleType;
import engine.sound.theory.Note.Root;
import engine.sound.Sequencer;
import engine.map.TileMap;
import engine.Assets;
import engine.display.SimplexSprite;

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
		var simplex = new Simplex(239);

		

		Assets.load([
			CanvasTools.createGradient("enemy", 100,0,0,20,120,60,10, simplex),
			CanvasTools.createGradient("player", 0,0,0,20,60,60,10, simplex),
			CanvasTools.createGradient("eyes", 255,255,255,40,5,5,5, simplex)
		]).then(assets -> {
			startGame(new Engine(canvas), assets, simplex);
		});
	}

	static inline function startGame(engine :Engine, assets :Assets, simplex :Simplex) : Void
	{
		var tileMap :TileMap = TileMap.parse("./src/game/tiles.dsmap");
		var background = new Entity()
			.add(new Sprite())
			.add(new Stage());

		engine.root
			.add(new SimplexSprite(simplex, GAME_WIDTH, GAME_HEIGHT, 4))
			.addChild(background
				.addChild(new Entity()
					.add(new FillSprite(0,0,0,1,300,300))));
		engine.root.add(new SoundComp());

		tileMap.populate(function(x :Int, y :Int, type :TileType, width :Int) {
			switch type {
				case TILE_WALL: {
					// background.addChild(new Entity()
					// 	.add(new Collider(COLLIDER_WALL))
					// 	.add(new TileSprite(assets.getImage("border"),TILE_WIDTH*width,TILE_WIDTH)
					// 		.setXY(x*TILE_WIDTH, y*TILE_WIDTH)));
				}
				case TILE_ENEMY: {
					// var enemy = createThing(new Enemy(), assets.getImage("enemy"), assets.getImage("eyes"), simplex, x, y, type);
					// background.addChild(enemy);

					// for(i in 0...30) {
					// 	background.addChild(new Entity()
					// 		.add(new FillSprite(200,200,200,1,20,10)
					// 			// .setBlendmode(OVERLAY)
					// 			.setAnchor(10,5))
					// 		.add(new Collider(COLLIDER_BOID))
					// 		.add(new Boid(enemy)));
					// }
				}
				case TILE_PLAYER: {
					var player = createThing(new Player(), assets.getImage("player"), assets.getImage("eyes"), simplex, x, y, type);
					background.addChild(player);

					for(i in 0...30) {
						background.addChild(new Entity()
							.add(new FillSprite(255,255,255,1,20,10)
								.setAnchor(10,5))
							.add(new Collider(COLLIDER_BOID))
							.add(new Boid(player)));
					}
				}
			}
		});

		engine.addSystem(new ControllerSystem());
		engine.addSystem(new EnemySystem());
		engine.addSystem(new CameraSystem());
		engine.addSystem(new CollisionSystem());
		engine.addSystem(new BoidSystem());
		engine.addSystem(new BackgroundSystem());
		var scale = new Scale(Root.G_SHARP, ScaleType.NATURAL_MINOR);
		var trackData :TrackData = cast TrackParser.parse("./src/game/track.dstrack");
		engine.addSystem(new SoundSystem(Sequencer.create("introSong", trackData, 130, scale)));
	}

	private static function createThing(comp :Component, mainTexture :ImageElement, eyes :ImageElement, simplex :Simplex, x :Int, y :Int, type :TileType) : Entity
	{
		return new Entity()
			.add(new ImageSprite(mainTexture)
				.centerAnchor()
				.setXY(x*TILE_WIDTH, y*TILE_WIDTH))
			.add(comp)
			.add(new Collider(COLLIDER_CHARACTER))
			.addChild(new Entity()
				.add(new ImageSprite(eyes)
					.setXY(6, 15)
					.centerAnchor()))
			.addChild(new Entity()
				.add(new ImageSprite(eyes)
					.setXY(15, 15)
					.centerAnchor()));
	}
}