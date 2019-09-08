package engine.sound.track;

import engine.util.KeyMap;

typedef TrackData =
{
    tracks: KeyMap<Array<{snd:String,env:String,octave:Int,loops:Array<String>}>>,
    envelopes: KeyMap<Envelope>,
    sounds: KeyMap<Sound>,
    loops: KeyMap<Array<String>>
}