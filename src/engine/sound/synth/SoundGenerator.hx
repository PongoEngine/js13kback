package engine.sound.synth;

import engine.sound.track.Sound;
import engine.sound.track.Envelope;

typedef SoundGenerator = (samplingFreq :Int, freq :Float, sound :Sound, envelope :Envelope, data :Array<Float>, sampleNumber :Int) -> Void;