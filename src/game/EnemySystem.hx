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
import engine.util.EMath;

class EnemySystem implements System
{

    public function new() : Void
    {
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.has(Enemy) && e.has(Collider);
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        var collider :Collider = e.get(Collider);
        var enemy :Enemy = e.get(Enemy);
        enemy.elapsed += dt;
        if(enemy.elapsed > enemy.timeout && collider.isOnGround) {
            engine.iterate(other -> {other.has(Player) && other.has(Sprite);}, other -> {
                var distance = EMath.distance(other.get(Sprite), e.get(Sprite));
                if(distance < 800) {
                    var angle = EMath.angle(other.get(Sprite), e.get(Sprite));
                    if(angle < middle) {
                        collider.isLeft = true;
                        collider.isRight = false;
                        if(collider.velocityX > 0) {
                            collider.velocityX *= 0.2;
                        }
                    }
                    else {
                        collider.isLeft = false;
                        collider.isRight = true;
                        if(collider.velocityX < 0) {
                            collider.velocityX *= 0.2;
                        }
                    }

                    if(angle > above && angle < Math.PI - above) {
                        collider.isUp = true;
                    }
                }
                else {
                    collider.isLeft = false;
                    collider.isRight = false; 
                }
                return true;
            });
            enemy.elapsed = 0;
        }

    
        
        
    }

    private static var middle = Math.PI/2;
    private static var above = (Math.PI - 2.5) / 2;
}