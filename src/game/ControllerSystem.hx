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
        return e.has(Player) && e.has(Sprite);
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        var sprite :Sprite = e.get(Sprite);
        if(_isUp) sprite.y -= dt * VELOCITY;
        if(_isDown) sprite.y += dt * VELOCITY;
        if(_isLeft) sprite.x -= dt * VELOCITY;
        if(_isRight) sprite.x += dt * VELOCITY;
        e.get(Player).isLeft = _isLeft;
        e.get(Player).isRight = _isRight;
        e.get(Player).isUp = _isUp;
        e.get(Player).isDown = _isDown;
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

    private static inline var VELOCITY = 300;
}