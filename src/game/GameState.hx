package game;

import engine.util.Simplex;

class GameState
{
    public var simplex (default, null) :Simplex;

    public function new(simplex :Simplex) : Void
    {
        this.simplex = simplex;
    }
}