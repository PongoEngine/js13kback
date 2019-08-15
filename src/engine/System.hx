package engine;

interface System
{
    public function shouldUpdate(e :Entity) : Bool;
    public function logic(engine :Engine, e :Entity, dt :Float) : Void;
}