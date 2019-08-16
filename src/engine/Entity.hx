/*
 * MIT License
 *
 * Copyright (c) 2019 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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