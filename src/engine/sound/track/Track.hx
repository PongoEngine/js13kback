package engine.sound.track;

import engine.sound.theory.Pulse;
import engine.sound.theory.Note;
import engine.sound.theory.Duration;

typedef Track = Map<Pulse, Array<{note:Note,duration:Duration,start:Pulse, sound :Sound, envelope :Envelope}>>;