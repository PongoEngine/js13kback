package engine.sound;

import js.Syntax;
import js.html.audio.AudioContext;
import js.html.audio.GainNode;
import js.html.audio.OscillatorType;
import engine.sound.theory.Duration;

abstract Frequencies(Array<Float>)
{
    public inline function new() : Void
    {
        this = [for(i in 0...21) 0];
        var aFreqs = [27.5, 55, 110, 220, 440, 880, 1760, 3520];
        for(freq in aFreqs) {
            this = this.concat(createNotes(freq));
        }
    }

    public function get(index :Int) : Float
    {
        return this[index];
    }

    public static function createNotes(a :Float) : Array<Float>
    {
        var p = Math.pow;
        return [
            a,
            a *  p(2, Syntax.code("1/12")),
            a *  p(2, Syntax.code("2/12")),
            a *  p(2, Syntax.code("3/12")),
            a *  p(2, Syntax.code("4/12")),
            a *  p(2, Syntax.code("5/12")),
            a *  p(2, Syntax.code("6/12")),
            a *  p(2, Syntax.code("7/12")),
            a *  p(2, Syntax.code("8/12")),
            a *  p(2, Syntax.code("9/12")),
            a *  p(2, Syntax.code("10/12")),
            a *  p(2, Syntax.code("11/12")),
        ];
    }
}