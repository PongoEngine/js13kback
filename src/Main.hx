import engine.display.Sprite;
import engine.display.FillSprite;
import engine.display.GradientFillSprite;
import engine.Entity;
import engine.Engine;
import game.Robot;
import game.RobotSystem;
import game.ControllerSystem;
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
		var c = new Entity();
		engine.root.addChild(c);
		c.addComponent(new GradientFillSprite(0xff00ff, 800, 600));

		var nc = new Entity();
		nc.addComponent(new FillSprite(0x00f33f, 20, 20));
		nc.addComponent(new Robot());
		nc.getComponent(FillSprite).angle = 55;
		nc.getComponent(Sprite).x = 35;
		nc.getComponent(Sprite).y = 35;
		nc.getComponent(FillSprite).centerAnchor();
		c.addChild(nc);

		engine.addSystem(new RobotSystem());
		engine.addSystem(new ControllerSystem());
	}
}
