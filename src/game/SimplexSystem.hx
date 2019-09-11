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

import engine.display.FillSprite;
import engine.display.Sprite;
import engine.Entity;
import engine.System;
import engine.Engine;
import game.display.SimplexSprite;
import game.camera.Stage;
import game.enemy.Enemy;

class SimplexSystem implements System<GameState>
{
    public function new() : Void
    {
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        var hasSprite = e.has(SimplexSprite);
        return hasSprite ? e.get(SimplexSprite).setSimpXY != null : false; 
    }

    public function logic(engine :Engine<GameState>, e :Entity, dt :Float) : Void
    {
        engine.iterate(other -> other.has(Stage) && other.has(Sprite), other -> {
            var spr = other.get(Sprite);
            e.get(SimplexSprite).setSimpXY(spr.x, spr.y);
            return true;
        });

        engine.iterate(other -> other.has(Player) && other.has(Sprite), other -> {
            var spr = other.get(Sprite);
            if(shouldCreateEnemy(engine.state, spr.x,spr.y)) {
                var angle = Math.random() * Math.PI*2;
                var distance = 800;
                var _x = Math.cos(angle) * distance + spr.x;
                var _y = Math.sin(angle) * distance + spr.y;
                engine.state.background()
                    .addChild(new Entity()
                        .add(new FillSprite(10,200,40,1,30,30)
                            .setXY(_x, _y)
                            .centerAnchor())
                        .add(new Enemy()));
            }
            return true;
        });
    }

    private function shouldCreateEnemy(state :GameState, x :Float, y :Float) : Bool
    {
        return state.simplex().get(x,y) > 0.8;
    }
}