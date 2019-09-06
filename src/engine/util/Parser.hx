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