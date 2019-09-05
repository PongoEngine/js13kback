package engine.util;

import engine.display.Sprite;

class EMath
{
    public static function angle(p1 :Sprite, p2 :Sprite) : Float
    {
        return Math.atan2(p2.y - p1.y, p2.x - p1.x);
    }

    public static function distance(p1 :Sprite, p2 :Sprite) : Float
    {
        var a = p1.x - p2.x;
        var b = p1.y - p2.y;
        return Math.sqrt( a*a + b*b );
    }
}