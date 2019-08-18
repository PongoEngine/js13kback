package engine.sound;

import js.Syntax;
import js.html.audio.AudioContext;
import js.html.audio.GainNode;
import js.html.audio.PeriodicWave;

abstract Keys(Array<Array<Note>>) 
{
    public inline function new(ctx :AudioContext, gain :GainNode, wav :PeriodicWave) : Void
    {
        var c = createNotes;
        this = [
            c(27.5, ctx, gain, wav),
            c(55, ctx, gain, wav),
            c(110, ctx, gain, wav),
            c(220, ctx, gain, wav),
            c(440, ctx, gain, wav),
            c(880, ctx, gain, wav),
            c(1760, ctx, gain, wav),
            c(3520, ctx, gain, wav)
        ];
    }

    public function get(key :Key, octave :Int) : Note
    {
        return this[octave][key];
    }

    public static function createNotes(a :Float, ctx :AudioContext, gain :GainNode, wav :PeriodicWave) : Array<Note>
    {
        var p = Math.pow;
        return [
            new Note(a *  p(2, Syntax.code("2/12")), ctx, gain, wav),  //B
            new Note(a *  p(2, Syntax.code("1/12")), ctx, gain, wav),  //A_SHARP
            new Note(a, ctx, gain, wav),                //A
            new Note(a *  p(2, Syntax.code("-1/12")), ctx, gain, wav), //G_SHARP
            new Note(a *  p(2, Syntax.code("-2/12")), ctx, gain, wav), //G
            new Note(a *  p(2, Syntax.code("-3/12")), ctx, gain, wav), //F_SHARP
            new Note(a *  p(2, Syntax.code("-4/12")), ctx, gain, wav), //F
            new Note(a *  p(2, Syntax.code("-5/12")), ctx, gain, wav), //E
            new Note(a *  p(2, Syntax.code("-6/12")), ctx, gain, wav), //D_SHARP
            new Note(a *  p(2, Syntax.code("-7/12")), ctx, gain, wav), //D
            new Note(a *  p(2, Syntax.code("-8/12")), ctx, gain, wav), //C_SHARP
            new Note(a *  p(2, Syntax.code("-9/12")), ctx, gain, wav)  //C
        ];
    }
}

@:enum abstract Key(Int) to Int
{
    var B = 0;
    var A_SHARP = 1;
    var A = 2;
    var G_SHARP = 3;
    var G = 4;
    var F_SHARP = 5;
    var F = 6;
    var E = 7;
    var D_SHARP = 8;
    var D = 9;
    var C_SHARP = 10;
    var C = 11;
}