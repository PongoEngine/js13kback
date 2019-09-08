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

import engine.Component;

class Collider implements Component
{
    public var type (default, null):BodyType;
    public var acceleration :Float = 30;
    public var velocityX :Float = 0;
    public var velocityY :Float = 0;
    public var isOnGround :Bool = true;
    public var isLeft :Bool = false;
    public var isRight :Bool = false;
    public var isUp :Bool = false;
    public var isDown :Bool = false;

    public function new(type :BodyType) : Void
    {
        this.type = type;
    }
}

@:enum abstract BodyType(Int)
{
    var COLLIDER_CHARACTER = 0;
    var COLLIDER_BOID = 1;
    var COLLIDER_WALL = 2;
}