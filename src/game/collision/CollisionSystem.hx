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

package game.collision;

import engine.Entity;
import engine.System;
import engine.Engine;
import engine.display.Sprite;
import game.collision.SpatialHash;

class CollisionSystem implements System
{
    private static inline var MAX_VELOX = 10;
    private static inline var MAX_VELOY = 24;
    private static inline var VELOX_DECEL = 0.8;
    private static inline var VELOX_MIN = 0.1;
    private static inline var JUMP_VELO = 14;
    private static inline var GRAVITY = 30;
    // private var _hash :SpatialHash;

    public function new() : Void
    {
    }

    public function shouldUpdate(e :Entity) : Bool
    {

        return e.has(Collider) && e.has(Sprite);
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        var collider = e.get(Collider);
        if(collider.type == COLLIDER_CHARACTER) {
            var sprite = e.get(Sprite);
            if(collider.isUp && collider.isOnGround) {
                collider.velocityY = -JUMP_VELO;
                collider.isOnGround = false;
                collider.isUp = false;
            }
            if(collider.isLeft) collider.velocityX -= collider.acceleration *dt;
            if(collider.isRight) collider.velocityX += collider.acceleration *dt;

            if(collider.velocityX > MAX_VELOX) {
                collider.velocityX  = MAX_VELOX;
            }
            else if(collider.velocityX < -MAX_VELOX) {
                collider.velocityX = -MAX_VELOX;
            }
            if(collider.velocityX > 0) {
                sprite.scaleX = -1;
            }
            else if(collider.velocityX < 0) {
                sprite.scaleX = 1;
            }

            if(!collider.isLeft && !collider.isRight) {
                if(Math.abs(collider.velocityX) < VELOX_MIN) {
                    collider.velocityX = 0;
                }
                else {
                    collider.velocityX *= VELOX_DECEL;
                }
            }

            sprite.x += collider.velocityX;
            collider.velocityY += GRAVITY * dt;
            if(collider.velocityY > MAX_VELOY) {
                collider.velocityY = MAX_VELOY;
            }
            sprite.y += collider.velocityY;

            // _hash.update(e);
            // _hash.iterate(e, function(other) {
            engine.iterate(other -> other.has(Collider) && other.has(Sprite) && other != e, other -> {
                var hasHit = checkCollision(sprite, other.get(Sprite));
                var otherType = other.get(Collider).type;
                switch [hasHit, otherType] {
                    case [true, COLLIDER_CHARACTER]:
                        if(collidedWithLeft(sprite, other.get(Sprite))) {
                            handleWithLeft(sprite, collider, other);
                        }
                        else if(collidedWithRight(sprite, other.get(Sprite))) {
                            handleWithRight(sprite, collider, other);
                        }
                        else if(collidedWithTop(sprite, other.get(Sprite))) {
                            handleWithTop(sprite, collider, other);
                        }
                        else if(collidedWithBottom(sprite, other.get(Sprite))) {
                            handleWithBottom(sprite, collider, other);
                        }
                    case [true, COLLIDER_BOID]:
                        if(collidedWithTop(sprite, other.get(Sprite))) {
                            handleWithTop(sprite, collider, other, 1);
                        }
                    case [true, COLLIDER_WALL]: {
                        if(collidedWithLeft(sprite, other.get(Sprite))) {
                            handleWithLeft(sprite, collider, other);
                        }
                        else if(collidedWithRight(sprite, other.get(Sprite))) {
                            handleWithRight(sprite, collider, other);
                        }
                        else if(collidedWithTop(sprite, other.get(Sprite))) {
                            handleWithTop(sprite, collider, other);
                        }
                        else if(collidedWithBottom(sprite, other.get(Sprite))) {
                            handleWithBottom(sprite, collider, other);
                        }
                        else {
                            handleWithBottom(sprite, collider, other, 2);
                        }
                    }
                    case [false, _]:
                }
                return false;
            });
        }   
    }

    private static function handleWithLeft(sprite :Sprite, collider :Collider, other :Entity, offset :Float = 0) : Void
    {
        sprite.x -= sprite.right() - other.get(Sprite).left() + offset;
        collider.velocityX = 0;
    }

    private static function handleWithRight(sprite :Sprite, collider :Collider, other :Entity, offset :Float = 0) : Void
    {
        sprite.x += other.get(Sprite).right() - sprite.left() + offset;
        collider.velocityX = 0;
    }

    private static function handleWithTop(sprite :Sprite, collider :Collider, other :Entity, offset :Float = 0) : Void
    {
        sprite.y -= sprite.bottom() - other.get(Sprite).top() + offset;
        collider.velocityY = 0;
        collider.isOnGround = true;
    }

    private static function handleWithBottom(sprite :Sprite, collider :Collider, other :Entity, offset :Float = 0) : Void
    {
        sprite.y += other.get(Sprite).bottom() - sprite.top() + offset;
        collider.velocityY = 0;
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
        return spr1.right(spr1.lastX) <= spr2.left(spr2.x) && // was not colliding
            spr1.right(spr1.x) >= spr2.left(spr2.x);
    }

    private function collidedWithRight(spr1 :Sprite, spr2 :Sprite) :Bool
    {
        return spr1.left(spr1.lastX) >= spr2.right(spr2.x) && // was not colliding
            spr1.left(spr1.x) <= spr2.right(spr2.x);
    }

    private function collidedWithTop(spr1 :Sprite, spr2 :Sprite) :Bool
    {
        return spr1.bottom(spr1.lastY) <= spr2.top(spr2.y) && // was not colliding
            spr1.bottom(spr1.y) >= spr2.top(spr2.y);
    }

    private function collidedWithBottom(spr1 :Sprite, spr2 :Sprite) :Bool
    {
        return spr1.top(spr1.lastY) >= spr2.bottom(spr2.y) && // was not colliding
            spr1.top(spr1.y) <= spr2.bottom(spr2.y);
    }

}