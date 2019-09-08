package engine.phys.ecs;

import engine.Component;

class Phys implements Component
{
    public var bodyType (default, null):BodyType; 
    public var solverType (default, null):SolverType; 
    public var restitution (default, null):Float;
    public var vx :Float; 
    public var vy :Float; 
    public var ax :Float; 
    public var ay :Float; 

    public function new(bodyType :BodyType, solverType :SolverType) : Void
    {
        this.bodyType = bodyType;
        this.solverType = solverType;

        this.restitution = .2;

        // Velocity
        this.vx = 0;
        this.vy = 0;

        // Acceleration
        this.ax = 0;
        this.ay = 0;
    }
}