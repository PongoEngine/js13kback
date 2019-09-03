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

package engine.map;

#if macro
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;
#end

@:extern abstract TileMap(Array<Int>)
{
    public inline function new(content :Array<Int>) : Void
    {
        this = content;
    }

    public inline function populate(fn :(x :Int, y :Int, tile :Int, width :Int) -> Void) : Void
    {
        var i = 0;
        while(i < this.length) {
            fn(this[i],this[i+1],this[i+2],this[i+3]);
            i+=4;
        }
    }

    public static macro function parse(filePath :String):ExprOf<TileMap>
    {
        if (FileSystem.exists(filePath)) {
            var fileContent:String = File.getContent(filePath);
            var parser = new MapParser(fileContent);

            var x = 0;
            var y = 0;
            var last = -1;
            var content :Array<Int> = [];

            while(parser.hasNext()) {
                parser.consumeWhile(str -> str == " ");
                var char = parser.nextChar();
                if(char == "\n") {
                    last = -1;
                    x = 0;
                    y++;
                }
                else {
                    var cur :Int = Std.parseInt(char);
                    switch [cur != null, last == cur] {
                        case [true, false]: {
                            content.push(x);
                            content.push(y);
                            content.push(cur);
                            content.push(1);
                            last = cur;
                        }
                        case [true, true]: {
                            content[content.length-1] += 1;
                        }
                        case [false, _]: {
                            last = -1;
                        }
                    }
                    x++;
                }
            }
            return Context.parse('new TileMap(${content})', Context.currentPos());
        }  else {
            Context.warning('${filePath}: is not valid', Context.currentPos());
            return Context.parse('new TileMap(${[]})', Context.currentPos());
        }
    }
}

private class MapParser
{
    public function new(content :String) : Void
    {
        _content = content;
        _charIndex = 0;
    }

    public function hasNext() : Bool
    {
        return _charIndex < _content.length;
    }

    public function consumeWhile(fn :String -> Bool) : Void
    {
        while(fn(peek())) nextChar();
    }

    public function nextChar() : String
    {
        return _content.charAt(_charIndex++);
    }

    public function peek() : String
    {
        return _content.charAt(_charIndex);
    }

    private var _content :String;
    private var _charIndex :Int;
}