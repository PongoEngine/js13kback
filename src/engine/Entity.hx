package engine;

abstract Entity({children:Array<Entity>})
{
    @:extern public inline function new() : Void
    {
        this = {children:[]};
    }

    @:extern public inline function children() : Array<Entity>
    {
        return this.children;
    }

    @:extern public inline function addComponent(component :Component) : Void
    {
        untyped this[component.name] = component;
    }

    @:extern public inline function removeComponent<T:Component>(class_ :Class<T>) : Void
    {
        #if !macro
        js.Syntax.delete(this, untyped class_._n);
        #end
    }

    @:extern public inline function getComponent<T:Component>(class_ :Class<T>) : T
    {
        return untyped this[class_._n];
    }

    @:extern public inline function hasComponent<T:Component>(class_ :Class<T>) : Bool
    {
        return untyped this[class_._n];
    }

    @:extern public inline function addChild(child :Entity) : Void
    {
         this.children.push(child);
    }

    @:extern public inline function removeChild(child :Entity) : Void
    {
        this.children.remove(child);
    }
}