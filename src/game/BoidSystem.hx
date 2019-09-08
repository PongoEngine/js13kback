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
import engine.display.FillSprite;
import engine.util.EMath;

class BoidSystem implements System
{
    public function new() : Void
    {
        _settings = {
            avoidance: 400,
            avoidanceDistance: 5,
            flockCentre: 1,
            targetPosition: 100
        }
        _flock = [];
        _targets = [];
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.has(Boid) && e.has(FillSprite);
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        _flock.resize(0);
        _targets.resize(0);
        engine.iterate(e -> e.has(Boid), e -> {
            _flock.push(e);
            return false;
        });
        calculateFlockCentre(_flock, _scratchFlockCenter);

        var b = e.get(Boid);
        var s = e.get(FillSprite);
        updateBoid(b, dt * 60, _scratchFlockCenter, _flock, _settings);
        s.x = b.x;
        s.y = b.y;
        s.angle = b.angle;
        var colorVelo = Std.int(EMath.clamp(Math.abs(b.veloX) * 20, 0, 255));
        s.r = colorVelo;
        s.g = colorVelo;
        s.b = colorVelo;
    }

    private var _settings : Settings;
    private var _flock : Array<Entity>;
    private var _targets : Array<Entity>;
    private var _scratchFlockCenter : Vector = {x:0,y:0};

    private static function moveTowards (boid :Boid, dt :Float, position :Vector, speed :Float) : Void
    {
        var distanceX = position.x - boid.x;
        var distanceY = position.y - boid.y;
        var absoluteDistanceX = Math.abs(distanceX);
        var absoluteDistanceY = Math.abs(distanceY);

        var vectorLength = Math.abs(absoluteDistanceX + absoluteDistanceY);
        if (vectorLength == 0) {
            absoluteDistanceX = 0;
            absoluteDistanceY = 0;
        }
        else {
            absoluteDistanceX /= vectorLength;
            absoluteDistanceY /= vectorLength;
        };

        boid.veloX += absoluteDistanceX * EMath.sign(distanceX) * speed * dt;
        boid.veloY += absoluteDistanceY * EMath.sign(distanceY) * speed * dt;
    }

    private static function calculateFlockCentre(entities :Array<Entity>, scratch :Vector) : Void
    {
        var sumX :Float = 0;
        var sumY :Float = 0;
        for(boid in entities) {
            sumX += boid.get(FillSprite).x;
            sumY += boid.get(FillSprite).y;
        }
        scratch.x = sumX / entities.length;
        scratch.y = sumY / entities.length;
    }

    private static function moveAwayFromCloseBoids(boid :Boid, flock :Array<Entity>, avoidance :Float, avoidanceDistance :Float, dt :Float) : Void
    {
        for(otherBoid in flock) {
            if (boid == otherBoid.get(Boid)) { return; }

            var distanceVecX = Math.abs(boid.x - otherBoid.get(Boid).x);
            var distanceVecY = Math.abs(boid.y - otherBoid.get(Boid).y);

            var distance = Math.sqrt(
                Math.pow(distanceVecX, 2) +
                Math.pow(distanceVecY, 2)
            );

            if (distance < avoidanceDistance) {
                moveTowards(boid, dt, otherBoid.get(Boid), -avoidance);
            }
        };
    }

    private static function updateBoid(boid :Boid, dt :Float, flockCentre :Vector, flock :Array<Entity>, settings :Settings) : Boid
    {
        moveTowards(
            boid,
            dt,
            boid.target,
            settings.targetPosition / 100
        );

        moveTowards(
            boid,
            dt,
            flockCentre,
            settings.flockCentre / 100
        );

        moveAwayFromCloseBoids(
            boid,
            flock,
            settings.avoidance / 100,
            settings.avoidanceDistance,
            dt
        );

        var lastX = boid.x;
        var lastY = boid.y;
        boid.x += boid.veloX * dt;
        boid.y += boid.veloY * dt;
        boid.angle = EMath.angle(boid.x, boid.y, lastX, lastY);

        boid.veloX *= FRICTION / dt;
        boid.veloY *= FRICTION / dt;

        return boid;
    }

    private static inline var BOID_COUNT = 75;
    private static inline var FRICTION = 0.98;
}

typedef Vector = {x:Float, y:Float};
typedef Settings = {
    avoidance :Float,
    avoidanceDistance :Float,
    flockCentre :Float,
    targetPosition :Float,
};