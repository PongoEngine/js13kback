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
