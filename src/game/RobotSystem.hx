package game;

import engine.Entity;
import engine.Engine;
import engine.System;
import engine.display.Sprite;

class RobotSystem implements System
{
    public function new() : Void
    {
        
    }

    public function shouldUpdate(e :Entity) : Bool
    {
        return e.hasComponent(Robot) && e.hasComponent(Sprite);
    }

    public function logic(engine :Engine, e :Entity, dt :Float) : Void
    {
        var sprite :Sprite = e.getComponent(Sprite);
        sprite.angle += 190 * dt;
    }
}