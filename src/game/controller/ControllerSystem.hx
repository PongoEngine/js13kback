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

package game.controller;

import js.Browser;
import engine.Entity;
import engine.System;
import engine.Engine;
import engine.display.Sprite;
import game.collision.Collider;

class ControllerSystem implements System
{
    public function new() : Void
    {
        Browser.window.onkeydown = (e) -> _keyChange(true, e.keyCode);
        Browser.window.onkeyup = (e) -> _keyChange(false, e.keyCode);
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.has(Player) && e.has(Sprite) && e.has(Collider);
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        if(_player == null) {
            _player = e.get(Collider);
        }
    }

    private function _keyChange(isKeyDown :Bool, keyCode :String) : Void
    {
        if(_player != null) {
            if (keyCode == '38') {
                _player.isUp = isKeyDown;
                if(_player.isUp && _player.isDown) {
                    _player.isDown = false;
                }
            }
            else if (keyCode == '40') {
                _player.isDown = isKeyDown;
                if(_player.isDown && _player.isUp) {
                    _player.isUp = false;
                }
            }
            else if (keyCode == '37') {
                _player.isLeft = isKeyDown;
                if(_player.isLeft && _player.isRight) {
                    _player.isRight = false;
                    _player.velocityX = 0;
                }
                if(_player.velocityX > 0) {
                    _player.velocityX = 0;
                }
            }
            else if (keyCode == '39') {
                _player.isRight = isKeyDown;
                if(_player.isRight && _player.isLeft) {
                    _player.isLeft = false;
                }
                if(_player.velocityX < 0) {
                    _player.velocityX = 0;
                }
            }
        }
    }

    private var _player :Collider = null;
}