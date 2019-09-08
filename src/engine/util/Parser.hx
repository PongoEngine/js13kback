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

package engine.util;

class Parser
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

    public function consumeWhile(fn :String -> Bool) : String
    {
        var str = "";
        while(fn(peek())) {
            str += nextChar();
        }
        return str;
    }

    public function nextChar() : String
    {
        return _content.charAt(_charIndex++);
    }

    public function peek() : String
    {
        return _content.charAt(_charIndex);
    }

    public function isWhitespace(ch :String) : Bool
    {
        return (ch == ' ') || (ch == '\t') || (ch == '\n');
    }

    public function isNumber(ch :String) : Bool
    {
        return (ch == '0') 
            || (ch == '1')
            || (ch == '2')
            || (ch == '3')
            || (ch == '4')
            || (ch == '5')
            || (ch == '6')
            || (ch == '7')
            || (ch == '8')
            || (ch == '9')
        ;
    }

    private var _content :String;
    private var _charIndex :Int;
}