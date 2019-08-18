package engine.sound;

import js.Syntax;
import js.html.audio.AudioContext;
import js.html.audio.GainNode;
import js.html.audio.PeriodicWave;

abstract Keys(Array<Note>) 
{
    public inline function new(ctx :AudioContext, gain :GainNode, wav :PeriodicWave) : Void
    {
        this = [for(i in 0...20) null];
        var aFreqs = [27.5, 55, 110, 220, 440, 880, 1760, 3520];
        for(freq in aFreqs) {
            this = this.concat(createNotes(freq, ctx, gain, wav));
        }
    }

    public function get(key :Int) : Note
    {
        return this[key];
    }

    public static function createNotes(a :Float, ctx :AudioContext, gain :GainNode, wav :PeriodicWave) : Array<Note>
    {
        var p = Math.pow;
        return [
            new Note(a, ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("1/12")), ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("2/12")), ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("3/12")), ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("4/12")), ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("5/12")), ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("6/12")), ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("7/12")), ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("8/12")), ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("9/12")), ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("10/12")), ctx, gain, wav),
            new Note(a *  p(2, Syntax.code("11/12")), ctx, gain, wav),

        ];
    }
}