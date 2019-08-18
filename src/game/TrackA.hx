package game;

import engine.sound.Track;
import engine.sound.theory.Duration;
import js.html.audio.OscillatorType;

class TrackA
{
    public static var a :Track = {
        type: OscillatorType.TRIANGLE,
        duration: (Duration.WHOLE * 4),
        sequence: [
            "|1---|1---|1---|1---|",
            "|-1--|-2--|-1--|-2--|",
            "|--1-|----|--1-|----|",
            "|---1|--11|---1|---1|",
            "|----|----|----|--1-|"
        ]
    };
}