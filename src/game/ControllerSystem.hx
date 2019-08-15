package game;

import js.Browser;
import engine.Entity;
import engine.System;
import engine.display.Sprite;

class ControllerSystem implements System
{
    private var _isUp :Bool = false;
    private var _isDown :Bool = false;
    private var _isLeft :Bool = false;
    private var _isRight :Bool = false;

    public function new() : Void
    {
        Browser.window.onkeydown = (e) -> _keyChange(true, e.keyCode);
        Browser.window.onkeyup = (e) -> _keyChange(false, e.keyCode);
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.hasComponent(Robot) && e.hasComponent(Sprite);
    }

    public function logic(e :Entity, dt :Float) : Void
    {
        var sprite :Sprite = e.getComponent(Sprite);
        // sprite.angle += 4;
    }

    private function _keyChange(isKeyDown :Bool, keyCode :String) : Void
    {
        _isUp = false;
        _isDown = false;
        _isLeft = false;
        _isRight = false;
        if (keyCode == '38') {
            _isUp = isKeyDown;
        }
        else if (keyCode == '40') {
            _isDown = isKeyDown;
        }
        else if (keyCode == '37') {
            _isLeft = isKeyDown;
        }
        else if (keyCode == '39') {
            _isRight = isKeyDown;
        }
    }
}