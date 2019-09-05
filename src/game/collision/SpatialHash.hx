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

import engine.display.Sprite;
import engine.Entity;

class SpatialHash
{
    public function new (power_of_two :Int = 7) : Void
    {
        _getKeys = makeKeysFn(power_of_two);
        _hash = new Map<String, Map<{},Entity>>();
        _fatTiles = cast new Map<{},Entity>();
    }

    public function insert(obj :Entity, isFat :Bool = false) : Void
    {
        if(isFat) {
            _fatTiles.set(obj,obj);
        }
        else {
            var keys = _getKeys(obj);
            var key;
            for (i in 0...keys.length) {
                key = keys[i];
                if (_hash.exists(key)) {
                    _hash.get(key).set(cast obj,obj);
                } else {
                    _hash.set(key, [(cast obj) => obj]);
                }
            }
        }
    }

    public function remove(obj :Entity, isFat :Bool = false) : Void
    {
        if(isFat) {
            _fatTiles.remove(obj);
        }
        else {
            var keys = _getKeys(obj);
            var key;
            for (i in 0...keys.length) {
                key = keys[i];
                if (_hash.exists(key)) {
                    _hash.get(key).remove(cast obj);
                }
            }
        }
    }

    public function update(obj :Entity, isFat :Bool = false) : Void
    {
        this.remove(obj, isFat);
        this.insert(obj, isFat);
    }

    public function retrieve(obj :Entity) : Array<Entity>
    {
        if (obj == null) {
            return [];
        }

        var keys :Array<String>;
        var key :String;
        keys = _getKeys(obj);
        _scratchRet.resize(0);
        for (i in 0...keys.length) {
            key = keys[i];
            if (_hash.exists(key)) {
                for(item in _hash[key]) {
                    _scratchRet.push(item);
                }
            }
        }
        for(fatTile in _fatTiles) {
            _scratchRet.push(fatTile);
        }
        return _scratchRet;
    }

    private static function makeKeysFn(shift :Int) {
        return function(ent :Entity) :Array<String> {
            var obj = ent.get(Sprite);
            var sx = Std.int(obj.x) >> shift;
            var sy = Std.int(obj.y) >> shift;
            var ex = Std.int(obj.x + obj.naturalWidth()) >> shift;
            var ey = Std.int(obj.y + obj.naturalHeight()) >> shift;
            _scratchKeys.resize(0);
            for(y in sy...ey+1) {
                for(x in sx...ex+1) {
                    _scratchKeys.push("" + x + ":" + y);
                }
            }
            return _scratchKeys;
        };
    }  

    private var _getKeys :Entity -> Array<String>;
    private var _hash :Map<String, Map<{},Entity>>;
    private var _fatTiles :Map<Entity,Entity>;
    private static var _scratchKeys :Array<String> = [];
    private static var _scratchRet :Array<Entity> = [];
}