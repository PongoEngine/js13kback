package engine.sound;

#if macro
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;
#end

import engine.util.Parser;

class SoundFile
{
    public static macro function parse(filePath :String):ExprOf<Dynamic>
    {
        if (FileSystem.exists(filePath)) {
            var fileContent:String = File.getContent(filePath);
            var parser = new Parser(fileContent);

            trace(fileContent);


            return Context.parse('null', Context.currentPos());
        }  else {
            Context.warning('${filePath}: is not valid', Context.currentPos());
            return Context.parse('null', Context.currentPos());
        }
    }
}

typedef Envelope =
{
    var attackDur :Float;
    var attackAmp :Float;
    var decayDur :Float;
    var sustainDur :Float;
    var sustainAmp :Float;
    var releaseDur :Float;
}

typedef Sound =
{
    volume :Float, 
    randomness :Float,
    length :Float,
    attack :Float,
    slide :Float,
    noise :Float,
    modulation :Float,
    modulationPhase :Float
}

abstract Note(Array<Int>)
{
    public function new(vals :Array<Int>) : Void
    {
        this = vals;
    } 
}