package engine.sound;

import engine.sound.theory.Duration;
import js.html.audio.OscillatorType;

typedef Track =
{
    type:OscillatorType,
    duration: Duration,
    sequence: Array<String>
}