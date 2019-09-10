package game;

import engine.util.Simplex;

class GameState
{
    public var simplex (default, null) :Void -> Simplex;

    public function new(simplex :Simplex) : Void
    {
        // this.simplex = simplex;
        _simplex = simplex;
        this.simplex = function() {
            return _simplex;
        }
    }

    private var _simplex :Simplex;
}