package engine.sound;

import engine.sound.theory.Pulse;
import engine.sound.theory.Note;
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
    lanes: Array<String>,
    ?notes: Map<Pulse, Array<{note:Note,duration:Duration,start:Pulse, type :OscillatorType}>>,
    asdr: ASDR
}

typedef ASDR = {
    var attack :Float;
    var sustain :Float;
    var sustainVal :Float;
    var decay :Float;
    var release :Float;
}