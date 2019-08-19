package engine.sound;

import engine.sound.theory.Pulse;
import engine.sound.theory.Note;
import engine.sound.theory.Octave;
import engine.sound.theory.Duration;
import js.html.audio.OscillatorType;

typedef Track =
{
    bpm:Int,
    duration: Duration,
    infos: Array<TrackInfo>
}

typedef TrackInfo = {
    type:OscillatorType,
    noteLength: Pulse,
    octave: Octave,
    lanes: Array<String>,
    ?notes: Map<Pulse, Array<{note:Note,duration:Duration,start:Pulse, type :OscillatorType}>>,
    adsr: ADSR
}

typedef ADSR = {
    var attackDur :Float;
    var attackAmp :Float;
    var decayDur :Float;
    var sustainDur :Float;
    var sustainAmp :Float;
    var releaseDur :Float;
}