// Minor changes to https://github.com/cyclejs-community/boids/blob/master/index.js

package game;

import engine.util.Simplex;
import engine.display.Sprite;
import engine.util.EMath;
import engine.display.Canvas;

using Lambda;

class Boids extends Sprite
{
    public function new(attractor :Sprite, simplex :Simplex) {
        super();
        _settings = {
            avoidance: 110,
            avoidanceDistance: 50,
            flockCentre: 20,
            targetPosition: 50
        }
        _flock = makeflock(40, attractor.x + 1, attractor.y + 1);
        _attractor = attractor;
        _simplex = simplex;
    }

    override function draw(canvas:Canvas, dt :Float) :Void
    {
        _scratch.x = _attractor.x;
        _scratch.y = _attractor.y;
        update(dt * 60, _scratch);
        canvas.setColor(130,30,150,1);
        for(boid in _flock) {
            canvas.save();
            canvas.rotate(boid.angle);
            canvas.drawRect(boid.x, boid.y, 10, 10);
            canvas.restore();
        }
    }

    function update (dt :Float, targetPosition :Vector) {
        var flockCentre = calculateFlockCentre(_flock);

        for(boid in _flock) {
            updateBoid(boid, dt, targetPosition, flockCentre, _flock, _settings);
        }
    }

    private var _settings : Settings;
    private var _simplex : Simplex;
    private var _flock : Array<Boid>;
    private var _attractor :Sprite;
    private var _scratch :Vector = {x:0,y:0};

    private static function makeflock (count :Int, x :Float, y :Float) :Array<Boid>
    {
        return [for(i in 0...count) new Boid(x, y)];
    }

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

    private static function calculateFlockCentre(flock :Array<Boid>) : Vector
    {
        var sumX :Float = 0;
        var sumY :Float = 0;
        for(boid in flock) {
            sumX += boid.x;
            sumY += boid.y;
        }
        _scratchFlockCenter.x = sumX / flock.length;
        _scratchFlockCenter.y = sumY / flock.length;
        return _scratchFlockCenter;
    }

    private static function moveAwayFromCloseBoids(boid :Boid, flock :Array<Boid>, avoidance :Float, avoidanceDistance :Float, dt :Float) : Void
    {
        flock.iter(otherBoid -> {
            if (boid == otherBoid) { return; }

            var distanceVecX = Math.abs(boid.x - otherBoid.x);
            var distanceVecY = Math.abs(boid.y - otherBoid.y);

            var distance = Math.sqrt(
                Math.pow(distanceVecX, 2) +
                Math.pow(distanceVecY, 2)
            );

            if (distance < avoidanceDistance) {
                moveTowards(boid, dt, otherBoid, -avoidance);
            }
        });
    }

    private static function updateBoid(boid :Boid, dt :Float, targetPosition :Vector, flockCentre :Vector, flock :Array<Boid>, settings :Settings) : Boid
    {
        moveTowards(
            boid,
            dt,
            targetPosition,
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

        boid.x += boid.veloX * dt;
        boid.y += boid.veloY * dt;

        boid.veloX *= FRICTION / dt;
        boid.veloY *= FRICTION / dt;

        return boid;
    }

    private static var _scratchFlockCenter : Vector = {x:0,y:0};
    private static inline var BOID_COUNT = 75;
    private static inline var FRICTION = 0.98;
}

class Boid
{
    public var x :Float;
    public var y :Float;
    public var angle :Float;
    public var veloX :Float;
    public var veloY :Float;

    public function new(x :Float, y :Float) : Void
    {
        this.x = x;
        this.y = y;
        this.angle = 0;
        this.veloX = 0;
        this.veloY = 0;
    }
}

typedef Vector = {x:Float, y:Float};
typedef Settings = {
    avoidance :Float,
    avoidanceDistance :Float,
    flockCentre :Float,
    targetPosition :Float,
};