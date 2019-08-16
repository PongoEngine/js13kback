package game;

import js.Browser;
import engine.Entity;
import engine.System;
import engine.Engine;
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

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        var sprite :Sprite = e.getComponent(Sprite);
        if(_isUp) sprite.y -= dt * VELOCITY;
        if(_isDown) sprite.y += dt * VELOCITY;
        if(_isLeft) sprite.x -= dt * VELOCITY;
        if(_isRight) sprite.x += dt * VELOCITY;
    }

    private function _keyChange(isKeyDown :Bool, keyCode :String) : Void
    {
        if (keyCode == '38') {
            _isUp = isKeyDown;
            if(_isUp) _isDown = false;
        }
        else if (keyCode == '40') {
            _isDown = isKeyDown;
            if(_isDown) _isUp = false;
        }
        else if (keyCode == '37') {
            _isLeft = isKeyDown;
            if(_isLeft) _isRight = false;
        }
        else if (keyCode == '39') {
            _isRight = isKeyDown;
            if(_isRight) _isLeft = false;
        }
    }

    private static inline var VELOCITY = 230;
}