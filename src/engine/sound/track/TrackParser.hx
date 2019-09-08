package engine.sound.track;

import haxe.Json;
#if macro
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.FileSystem;
import sys.io.File;
import engine.util.Parser;
import engine.sound.track.Track;
import engine.sound.track.Envelope;
import engine.sound.track.Sound;
#end

class TrackParser
{
    public static macro function parse(filePath :String):ExprOf<engine.sound.track.TrackData>
    {
        if (FileSystem.exists(filePath)) {
            var fileContent:String = File.getContent(filePath);
            var parser = new Parser(fileContent);
            var envelopes :Map<String, Envelope> = new Map<String, Envelope>();
            var sounds :Map<String, Sound> = new Map<String, Sound>();
            var loops :Map<String, Array<String>> = new Map<String, Array<String>>();
            var tracks :Map<String, Array<{sound:String,envelope:String, octave :Int,loops:Array<String>}>> 
                = new Map<String, Array<{sound:String,envelope:String, octave :Int,loops:Array<String>}>>();

            while(parser.hasNext()) {
                consumeWhitespace(parser);
                if(parser.hasNext()) {
                    var keyword :BaseKeyword = consumeWord(parser);
                    switch keyword {
                        case ENVELOPE:
                            var e = parseEnvelope(parser);
                            envelopes.set(e.name, e.envelope);
                        case SOUND: 
                            var s = parseSound(parser);
                            sounds.set(s.name, s.sound);
                        case LOOP: 
                            var l = parseLoop(parser);
                            loops.set(l.name, l.notes);
                        case TRACK: 
                            var t = parseTrack(parser);
                            if(!tracks.exists(t.name)) {
                                tracks.set(t.name, []);
                            }
                            tracks.get(t.name).push({sound:t.sound,envelope:t.envelope,octave:t.octave,loops:t.loops});
                        case _: Context.error('Error while parsing. Recieved: ${keyword}', Context.currentPos());
                    }
                    parser.nextChar();
                }
            }

            checkReferences(tracks.iterator(), envelopes, sounds, loops);
            var code = '{
                tracks: ${writeTracks(tracks)},
                envelopes: ${writeEnvelopes(envelopes)},
                sounds: ${writeSounds(sounds)},
                loops: ${writeLoops(loops)}
            }';
            return Context.parse(code, Context.currentPos());
        }  else {
            Context.warning('${filePath}: is not valid', Context.currentPos());
            return Context.parse('null', Context.currentPos());
        }
    }

#if macro
    private static function checkReferences(
        tracks :Iterator<Array<{sound:String,envelope:String,loops :Array<String>}>>,
        envelopes :Map<String, Envelope>,
        sounds :Map<String, Sound>,
        loops :Map<String, Array<String>>
    ) : Void
    {
        for(track in tracks) {
            for(section in track) {
                if(!envelopes.exists(section.envelope)) {
                    Context.error('Envelope: ${section.envelope} is missing', Context.currentPos());
                }
                
                if(!sounds.exists(section.sound)) {
                    Context.error('Sound: ${section.sound} is missing', Context.currentPos());
                }
                for(loop in section.loops) {
                    if(!loops.exists(loop)) {
                        Context.error('Loop: ${loop} is missing', Context.currentPos());
                    }
                }
            }
        }
    }

    private static function writeTracks(tracks :Map<String, Array<{sound:String,envelope:String,octave:Int,loops:Array<String>}>>) : String
    {
        var t = "{";
        for(track in tracks.keyValueIterator()) {
            t+= '"${track.key}":[';
            for(section in track.value) {
                t+='{';
                t+='snd:"${section.sound}",';
                t+='env:"${section.envelope}",';
                t+='octave:"${section.octave}",';
                t+='loops:[';
                for(loop in section.loops) {
                    t+='"${loop}",';
                }
                t+='],';
                t+='},';
            }
            t+= '],';
        }
        t += "}";
        return t;
    }

    private static function writeEnvelopes(envelopes :Map<String, Envelope>) : String
    {
        var e = "{";
        for(env in envelopes.keyValueIterator()) {
            e+= '"${env.key}":${env.value},';
        }
        e += "}";
        return e;
    }

    private static function writeSounds(sounds :Map<String, Sound>) : String
    {
        var s = "{";
        for(sound in sounds.keyValueIterator()) {
            s+= '"${sound.key}":${sound.value},';
        }
        s += "}";
        return s;
    }

    private static function writeLoops(loops :Map<String, Array<String>>) : String
    {
        var l = "{";
        for(loop in loops.keyValueIterator()) {
            l+='"${loop.key}":[';
            for(note in loop.value) {
                l+= '"${note}",';
            }
            l+='],';
        }
        l += "}";
        return l;
    }

    private static function parseEnvelope(parser :Parser) : {name :String, envelope :Envelope}
    {
        consumeWhitespace(parser);
        var envelopName = consumeWord(parser);

        var attackDur :Float = 0;
        var attackAmp :Float = 0;
        var decayDur :Float = 0;
        var sustainDur :Float = 0;
        var sustainAmp :Float = 0;
        var releaseDur :Float = 0;

        while(true) {
            consumeWhitespace(parser);
            var keyword :EnvelopeKeyword = parser.consumeWhile(str -> !parser.isWhitespace(parser.peek()) && parser.hasNext());
            switch keyword {
                case ATTACK_DUR: 
                    attackDur = parseFloat(parser);
                case ATTACK_AMP: 
                    attackAmp = parseFloat(parser);
                case DECAY_DUR: 
                    decayDur = parseFloat(parser);
                case SUSTAIN_DUR: 
                    sustainDur = parseFloat(parser);
                case SUSTAIN_AMP: 
                    sustainAmp = parseFloat(parser);
                case RELEASE_DUR: 
                    releaseDur = parseFloat(parser);
                case SEMI:
                    break;
                case _: Context.error('Error while parsing envelope. Recieved: ${keyword}', Context.currentPos());
            }
        }

        return {name:envelopName, envelope: new Envelope([
            attackDur, 
            attackAmp,
            decayDur,
            sustainDur,
            sustainAmp,
            releaseDur
        ])};
    }

    private static function parseSound(parser :Parser) : {name :String, sound :Sound}
    {
        consumeWhitespace(parser);
        var soundName = consumeWord(parser);
        var volume :Float = 3;
        var length :Float = 0.2;
        var noise :Float = 0.3333;
        var sine :Float = 0.3333;
        var square :Float = 0.3333;

        while(true) {
            consumeWhitespace(parser);
            var keyword :SoundKeyword = parser.consumeWhile(str -> !parser.isWhitespace(parser.peek()) && parser.hasNext());
            switch keyword {
                case VOLUME: 
                    volume = parseFloat(parser);
                    if(volume < 0) Context.error("Volume must be 0 or positive", Context.currentPos());
                case LENGTH: 
                    length = parseFloat(parser);
                    if(length < 0) Context.error("Length must be 0 or positive", Context.currentPos());
                case NOISE: 
                    noise = parseFloat(parser);
                    if(noise < 0) Context.error("Noise must be 0 or positive", Context.currentPos());
                case SINE: 
                    sine = parseFloat(parser);
                    if(sine < 0) Context.error("Sine must be 0 or positive", Context.currentPos());
                case SQUARE: 
                    square = parseFloat(parser);
                    if(square < 0) Context.error("Square must be 0 or positive", Context.currentPos());
                case SEMI:
                    break;
                case _: Context.error('Error while parsing sound. Recieved: ${keyword}', Context.currentPos());
            }
        }

        var sum = (noise + sine + square);
        if(sum <= 0) {
            Context.error("Sound summation must be greater than 0", Context.currentPos());
        }

        var scale = 1 / (noise + sine + square);
        noise = scale * noise;
        sine = scale * sine;
        square = scale * square;

        return {name:soundName, sound: new Sound([
            volume, 
            length,
            noise,
            sine,
            square
        ])};
    }

    private static function parseLoop(parser :Parser) : {name:String,notes:Array<String>}
    {
        consumeWhitespace(parser);
        var loopName = consumeWord(parser);
        var loop = parser.consumeWhile(str -> str != ";" && parser.hasNext());
        return {name:loopName, notes:parseNotes(new Parser(loop))};
    }

    private static function parseNotes(parser :Parser) : Array<String>
    {
        var notes = [];
        while(parser.hasNext()) {
            var garbage = parser.consumeWhile(str -> parser.isWhitespace(str) || (!parser.isNumber(str) && str != "~") && parser.hasNext());
            var restCount = 0;
            for(i in 0...garbage.length) {
                if(garbage.charAt(i) == "-") {
                    restCount++;
                }
            }
            if(parser.hasNext()) {
                var step :Int = parseInt(parser, true);
                var hold = parser.consumeWhile(str -> str == "~" && parser.hasNext());
                notes.push('${restCount}|${step}|${(hold.length + 1)}');
            }
        }
        return notes;
    }

    private static function parseTrack(parser :Parser) : {name:String,sound:String,envelope:String, octave:Int,loops :Array<String>}
    {
        consumeWhitespace(parser);
        var trackName = consumeWord(parser);
        consumeWhitespace(parser);
        var soundName = consumeWord(parser);
        consumeWhitespace(parser);
        var envelopeName = consumeWord(parser);
        consumeWhitespace(parser);
        var octave = parseInt(parser, true);
        var loops = [];

        while(parser.peek() != ";" && parser.hasNext()) {
            consumeWhitespace(parser);
            loops.push(consumeWord(parser));
        }

        return {name:trackName, sound:soundName, envelope: envelopeName, octave: octave, loops: loops};
    }

    private static function parseFloat(parser :Parser) : Float
    {
        consumeWhitespace(parser);
        var numberStr = parser.consumeWhile(str -> parser.isNumber(str) || str == ".");
        var num = Std.parseFloat(numberStr);
        if(num == null) {
            Context.error('Error while parsing Float. Recieved: ${numberStr}', Context.currentPos());
        }
        return num;
    }

    private static function parseInt(parser :Parser, onlyFirst :Bool) : Int
    {
        consumeWhitespace(parser);
        var numberStr = onlyFirst
            ? parser.nextChar()
            : parser.consumeWhile(str -> parser.isNumber(str));
        var num = Std.parseInt(numberStr);
        if(num == null) {
            Context.error('Error while parsing Int. Recieved: ${numberStr}', Context.currentPos());
        }
        return num;
    }

    private static function consumeWord(parser :Parser) : String
    {
        return parser.consumeWhile(str -> !parser.isWhitespace(str) && str != ";" && parser.hasNext());
    }

    private static function consumeWhitespace(parser :Parser) : Void
    {
        parser.consumeWhile(str -> parser.isWhitespace(str));
    }
#end
}

#if macro
@:enum abstract BaseKeyword(String) from String {
    var ENVELOPE = "envelope";
    var SOUND = "sound";
    var LOOP = "loop";
    var TRACK = "track";
}

@:enum abstract EnvelopeKeyword(String) from String {
    var ATTACK_DUR = "attackDur";
    var ATTACK_AMP = "attackAmp";
    var DECAY_DUR = "decayDur";
    var SUSTAIN_DUR = "sustainDur";
    var SUSTAIN_AMP = "sustainAmp";
    var RELEASE_DUR = "releaseDur";
    var SEMI = ";";
}

@:enum abstract SoundKeyword(String) from String {
    var VOLUME = "volume";
    var LENGTH = "length";
    var NOISE = "noise";
    var SINE = "sine";
    var SQUARE = "square";
    var SEMI = ";";
}
#end