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

class CollisionSystem implements System
{

    public function new() : Void
    {
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.has(Collider) && e.has(Sprite);
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        if(e.has(Player)) {
            if(!e.get(Player).isOnGround) {
                e.get(Player).velocityY += 29.81 *dt;
                e.get(Sprite).y += e.get(Player).velocityY;
            }
            
            engine.iterate(other -> {
                return other.has(Collider) && other.has(Sprite) && other != e;
            }, other -> {
                var hasHit = checkCollision(e.get(Sprite), other.get(Sprite));
                if(hasHit) {
                    if(collidedWithLeft(e.get(Sprite), other.get(Sprite))) {
                        var offsetX = e.get(Sprite).right() - other.get(Sprite).left();
                        e.get(Sprite).x -= Math.ceil(offsetX);
                    }
                    if(collidedWithRight(e.get(Sprite), other.get(Sprite))) {
                        var offsetX = other.get(Sprite).right() - e.get(Sprite).left();
                        e.get(Sprite).x += Math.ceil(offsetX);
                    }
                    if(collidedWithTop(e.get(Sprite), other.get(Sprite))) {
                        var offsetY = e.get(Sprite).bottom() - other.get(Sprite).top();
                        e.get(Sprite).y -= Math.ceil(offsetY);
                        e.get(Player).velocityY = 0;
                        e.get(Player).isOnGround = true;
                    }
                    if(collidedWithBottom(e.get(Sprite), other.get(Sprite)) && other.get(Collider).type == WALL) {
                        var offsetY = other.get(Sprite).bottom() - e.get(Sprite).top();
                        e.get(Sprite).y += Math.ceil(offsetY);
                        e.get(Player).velocityY = 0;
                    }
                }
                return hasHit;
            });
        }   
    }

    private function checkCollision(spr1 :Sprite, spr2 :Sprite) : Bool
    {
        var x1 = spr1.x - spr1.anchorX;
        var y1 = spr1.y - spr1.anchorY;
        var x2 = spr2.x - spr2.anchorX;
        var y2 = spr2.y - spr2.anchorY;
        return x1 < x2 + spr2.naturalWidth() &&
            x1 + spr1.naturalWidth() > x2 &&
            y1 < y2 + spr2.naturalHeight() &&
            y1 + spr1.naturalHeight() > y2;
    }

    private function collidedWithLeft(spr1 :Sprite, spr2 :Sprite) :Bool
    {
        return spr1.right(spr1.lastX) < spr2.left(spr2.x) && // was not colliding
            spr1.right(spr1.x) >= spr2.left(spr2.x);
    }

    private function collidedWithRight(spr1 :Sprite, spr2 :Sprite) :Bool
    {
        return spr1.left(spr1.lastX) >= spr2.right(spr2.x) && // was not colliding
            spr1.left(spr1.x) < spr2.right(spr2.x);
    }

    private function collidedWithTop(spr1 :Sprite, spr2 :Sprite) :Bool
    {
        return spr1.bottom(spr1.lastY) < spr2.top(spr2.y) && // was not colliding
            spr1.bottom(spr1.y) >= spr2.top(spr2.y);
    }

    private function collidedWithBottom(spr1 :Sprite, spr2 :Sprite) :Bool
    {
        return spr1.top(spr1.lastY) >= spr2.bottom(spr2.y) && // was not colliding
            spr1.top(spr1.y) < spr2.bottom(spr2.y);
    }
}