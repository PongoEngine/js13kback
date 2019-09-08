package engine.phys.ecs;

import engine.display.Sprite;
import engine.System;
import engine.Entity;
import engine.Engine;

import engine.phys.CollisionDetector;
import engine.phys.ecs.Phys;

class PhysicsSystem implements System
{
    public function new() : Void
    {
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.has(Phys) && e.has(Sprite);
    }

    public function logic(engine :Engine, current :Entity, dt :Float) : Void
    {
        var gx = GRAVITY_X * dt;
        var gy = GRAVITY_Y * dt;
        _scratchCollisions.resize(0);

        engine.iterate(other -> other.has(Phys) && other.has(Sprite) && other != current, other -> {
            var otherPhys = other.get(Phys);
            var otherSprite = other.get(Sprite);
            switch (otherPhys.bodyType) {
                case DYNAMIC:
                    otherPhys.vx += otherPhys.ax * dt + gx;
                    otherPhys.vy += otherPhys.ay * dt + gy;
                    otherSprite.x  += otherPhys.vx * dt;
                    otherSprite.y  += otherPhys.vy * dt;
                case KINEMATIC:
                    otherPhys.vx += otherPhys.ax * dt;
                    otherPhys.vy += otherPhys.ay * dt;
                    otherSprite.x  += otherPhys.vx * dt;
                    otherSprite.y  += otherPhys.vy * dt;
            }

            if(CollisionDetector.isColliding(current, other)) {
                _scratchCollisions.push(other);
            }

            return false;
        });

        for(other in _scratchCollisions) {
            CollisionDetector.resolveElastic(current, other);
        }
    }

    private static inline var GRAVITY_X = 0;
    private static inline var GRAVITY_Y = 200;
    private static var _scratchCollisions :Array<Entity> = [];
}