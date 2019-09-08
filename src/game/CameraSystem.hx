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

import engine.Entity;
import engine.System;
import engine.Engine;
import engine.display.Sprite;

class CameraSystem implements System
{
    public function new() : Void
    {
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.has(Stage) && e.has(Sprite);
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        var players = engine.getGroup(e -> e.has(Player) && e.has(Sprite));
        var p = players[0];
        var stageSprite = e.get(Sprite);
        if(p != null) {
            var pSprite = p.get(Sprite);
            var player = p.get(Player);
            stageSprite.x = getVal(player.isShiftedLeft, true, Main.GAME_WIDTH/2, pSprite.x + pSprite.naturalWidth()/2, stageSprite.x, _hasStarted);
            stageSprite.y = getVal(false, false, Main.GAME_HEIGHT/2, pSprite.y + pSprite.naturalHeight()/2, stageSprite.y, _hasStarted);
            _hasStarted = true;
        }
    }

    private static function getVal(isShiftedLeft :Bool, isX :Bool, mid :Float, playerCur :Float, stageCur :Float, hasStarted :Bool) : Float
    {
        // var offset = isX ? (isShiftedLeft ? -200 : 200) : 0;
        var offset = 0;
        var target = -playerCur + (mid) + offset;
        var distX = target - stageCur;
        var percentage = Math.abs(distX) / 400;
        if(!hasStarted) {
            return stageCur += distX;
        }

        stageCur += isX ? percentage * distX : percentage*percentage*percentage * distX;
        return stageCur;
    }

    private var _targetX :Float = 0;
    private var _targetY :Float = 0;
    private var _hasStarted :Bool = false;
}