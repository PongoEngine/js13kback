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

package game.enemy;

import engine.Entity;
import engine.System;
import engine.Engine;
import engine.display.Sprite;
import engine.util.EMath;

class EnemySystem implements System<GameState>
{

    public function new() : Void
    {
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.has(Enemy) && e.has(Sprite);
    }

    public function logic(engine :Engine<GameState>, e :Entity, dt :Float) : Void
    {
        var thisSprite :Sprite = e.get(Sprite);
        engine.iterate(other -> {other.has(Player) && other.has(Sprite);}, other -> {
            var thatSprite = other.get(Sprite);
            var angle = EMath.angle(thisSprite.x, thisSprite.y, thatSprite.x, thatSprite.y);

            var x = Math.cos(angle) * 200*dt;
            var y = Math.sin(angle) * 200*dt;
            thisSprite.x += x;
            thisSprite.y += y;

            return true;
        });
    }

    private static var middle = Math.PI/2;
    private static var above = (Math.PI - 2.5) / 2;
}