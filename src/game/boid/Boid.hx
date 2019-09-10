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

package game.boid;

import game.collision.Collider;
import engine.Component;

import engine.Entity;
import engine.display.Sprite;

class Boid implements Component
{
    public var x :Float;
    public var y :Float;
    public var angle :Float;
    public var veloX :Float;
    public var veloY :Float;
    public var target (get, null):{x:Float, y:Float};

    public function new(attractor :Entity) : Void
    {
        _attractor = attractor;
        var sprite = _attractor.get(Sprite);
        this.x = sprite.x + sprite.anchorX;
        this.y = sprite.y + sprite.anchorY;
        this.angle = 0;
        this.veloX = 0;
        this.veloY = 0;
        _target = {x:this.x,y:this.y};
    }

    private function get_target() : {x:Float, y:Float}
    {
        var sprite = _attractor.get(Sprite);
        if(_attractor.has(Collider)) {
            var collider = _attractor.get(Collider);
            var offsetX = collider.isLeft ? -OFFSET_X : collider.isRight ? OFFSET_X : 0;
            _target.x = sprite.x + offsetX;
            var offsetY = collider.isUp ? 0 : collider.isDown ? OFFSET_Y : 20;
            _target.y = sprite.y + sprite.naturalHeight() + offsetY;
        }

        
        return _target;
    }

    private var _attractor :Entity;
    private var _target :{x:Float, y:Float};
    private static inline var OFFSET_X = 40;
    private static inline var OFFSET_Y = -200;

}