package engine;

abstract Filter(Entity -> Bool)
{
    public function new(fn :Entity -> Bool) : Void
    {
        
    }
}