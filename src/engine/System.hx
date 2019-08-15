package engine;

interface System
{
    public function shouldUpdate(e :Entity) : Bool;
    public function logic(e :Entity, dt :Float) : Void;
}