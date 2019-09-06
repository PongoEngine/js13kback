package game;

import engine.sound.theory.Step;
import engine.sound.theory.Octave;
import engine.sound.Track;
import engine.sound.theory.Duration;
import js.html.audio.OscillatorType;
import engine.sound.theory.Pulse;

class TrackA
{
    public static var a :Track = {
        bpm:170,
        duration: ((Duration.EIGHTH*6) * 8),
        infos: [{
            octave: new Octave(1),
            offset: new Step(0),
            settings: {
                volume: 1, 
                randomness: 0.01,
                length: 0.2,
                attack: 0,
                slide: 0,
                noise: 1,
                modulation: 0,
                modulationPhase: 0
            },
            noteLength: new Pulse(Duration.EIGHTH.toInt()),
            lanes: [
                "|2-----|2-----|2-----|------|2-----|2-----|2-----|------|",

            ],
            adsr: {
                attackDur: 0,
                attackAmp: 0.5,
                decayDur: 0.1,
                sustainDur: 0.5,
                sustainAmp: 0.1,
                releaseDur: 0.3
            }
        }, {
            octave: new Octave(3),
            offset: new Step(0),
            settings: {
                volume: 1, 
                randomness: 0,
                length: 1.4,
                attack: 0,
                slide: 0,
                noise: 2.7,
                modulation: 0.1,
                modulationPhase: 0
            },
            noteLength: new Pulse(Duration.EIGHTH.toInt()),
            lanes: [
                "|---2--|---2--|---2--|---22-|---2--|---2--|---2--|---2--|",

            ],
            adsr: {
                attackDur: 0,
                attackAmp: 0.8,
                decayDur: 0.1,
                sustainDur: 0.1,
                sustainAmp: 0.1,
                releaseDur: 0.1
            }
        }]
    };
}