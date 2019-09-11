package game;

import engine.Entity;
import engine.util.Simplex;

class GameState
{
    public var simplex (default, null) :Void -> Simplex;
    public var background (default, null) :Void -> Entity;
    public var enemyCount :Int = 0;

    public function new(simplex :Simplex) : Void
    {
        // this.simplex = simplex;
        _simplex = simplex;
        this.simplex = function() {
            return _simplex;
        }
        this.background = function() {
            return _background;
        }
    }

    public function setBackground(background :Entity) : Void
    {
        this._background = background;
    }

    private var _simplex :Simplex;
    private var _background :Entity;
}