/*

The MIT License (MIT)

Copyright (c) 2014 Christer Bystrom

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

A spatial hash. For an explanation, see

http://www.gamedev.net/page/resources/_/technical/game-programming/spatial-hashing-r2697

For computational efficiency, the positions are bit-shifted n times. This means
that they are divided by a factor of power of two. This factor is the
only argument to the constructor.

*/

package game.collision;

import js.Syntax;
import engine.display.Sprite;
import engine.Entity;
import haxe.ds.List;

class SpatialHash
{
    public function new (power_of_two :Int = 6) : Void
    {
        _iterateKeys = makeKeysFn(power_of_two);
        _hash = new FastMap();
        _fatTiles = cast new Map<{},Entity>();
    }

    public function insert(obj :Entity, isFat :Bool = false) : Void
    {
        if(isFat) {
            _fatTiles.set(obj,obj);
        }
        else {
            _iterateKeys(obj, key -> {
                if(!_hash.exists(key)) {
                    _hash.set(key, new List<Entity>());
                }
                _hash.get(key).push(obj);
            });
        }
    }

    public function remove(obj :Entity, isFat :Bool = false) : Void
    {
        if(isFat) {
            _fatTiles.remove(obj);
        }
        else {
            _iterateKeys(obj, key -> {
                if (_hash.exists(key)) {
                    _hash.get(key).remove(obj);
                    if(_hash.get(key).length == 0) {
                        _hash.delete(key);
                    }
                }
            });
        }
    }

    public function update(obj :Entity, isFat :Bool = false) : Void
    {
        this.remove(obj, isFat);
        this.insert(obj, isFat);
    }

    public function iterate(obj :Entity, fn :Entity -> Void) : Void
    {
        if (obj == null) {
            return;
        }

        _iterateKeys(obj, key -> {
            if (_hash.exists(key)) {
                for(item in _hash.get(key)) {
                    if(item != obj) {
                        fn(item);
                    }
                }
            }
        });
        for(fatTile in _fatTiles) {
            if(fatTile != obj) {
                fn(fatTile);
            }
        }
    }

    private static function makeKeysFn(shift :Int) {
        return function(ent :Entity, fnKey :String -> Void) : Void {
            var obj = ent.get(Sprite);
            var sx = Std.int(obj.x) >> shift;
            var sy = Std.int(obj.y) >> shift;
            var ex = Std.int(obj.x + obj.naturalWidth()) >> shift;
            var ey = Std.int(obj.y + obj.naturalHeight()) >> shift;
            for(y in sy...ey+1) {
                for(x in sx...ex+1) {
                    fnKey("" + x + ":" + y);
                }
            }
        };
    }  

    private var _iterateKeys :Entity -> (String -> Void) -> Void;
    private var _hash :FastMap;
    private var _fatTiles :Map<Entity,Entity>;
}

extern abstract FastMap({})
{
    public inline function new() : Void
    {
        this = {};
    }

    public inline function exists(key :String) : Bool
    {
        return untyped this[key];
    }

    public inline function get(key :String) : List<Entity>
    {
        return untyped this[key];
    }

    public inline function set(key :String, entities :List<Entity>) : Void
    {
        untyped this[key] = entities;
    }

    public inline function delete(key :String) : Void
    {
        untyped __js__('delete {0}[{1}]', this, key);
    }
}