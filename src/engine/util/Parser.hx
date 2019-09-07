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