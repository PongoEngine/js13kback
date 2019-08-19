package game;

import engine.sound.Track;
import engine.sound.theory.Duration;
import js.html.audio.OscillatorType;
import engine.sound.theory.Pulse;

class TrackA
{
    public static var a :Track = {
        bpm:120,
        duration: ((Duration.EIGHTH*6) * 8),
        infos: [{
            type: OscillatorType.SAWTOOTH,
            noteLength: new Pulse(Duration.EIGHTH.toInt()),
            lanes: [
                "|3-----|3-----|3-----|3-----|3-----|3-----|3-----|3-----|",
                "|--3---|--3---|--3---|--3---|--3---|--3---|--3---|--3---|",
                "|----3-|----3-|------|------|----3-|----3-|------|------|",
                "|------|------|----3-|----3-|------|------|----3-|----3-|",
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|------|------|------|------|------|",

            ],
            asdr: {
                attack: 0.2,
                sustain: 1,
                sustainVal: 2,
                decay: 1,
                release: 0
            }
        }, {
            type: OscillatorType.SQUARE,
            noteLength: new Pulse(Duration.EIGHTH.toInt()),
            lanes: [
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|------|------|------|------|------|",
                "|------|------|------|--11--|------|------|------|------|",
                "|--11--|------|--11--|------|------|------|------|------|",

            ],
            asdr: {
                attack: 0.2,
                sustain: 1,
                sustainVal: 2,
                decay: 0,
                release: 0
            }
        }]
    };
}