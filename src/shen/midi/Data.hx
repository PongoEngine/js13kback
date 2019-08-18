/*
 * Copyright (c) 2018 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package shen.midi;

import shen.theory.Duration;
import shen.theory.Note;

@:notNull
@:forward(playNote)
extern abstract Data(__Data__)
{
    public var notes (get, never) :Iterator<DataNote>;
    public var length (get, never) :Int;

    inline public function new() : Void
    {
        this = new __Data__();
    }

    inline public function last() : DataNote
    {
        return this.notes[this.notes.length - 1];
    }

    @:op(A + B) static inline function addition(a :Data, b :Data) : Data
    {
        for(bNote in b.notes) {
            (cast a).notes.push(bNote);
        }
        return a;
    }

    inline private function get_notes() : Iterator<DataNote>
    {
        return this.notes.iterator();
    }

    inline private function get_length() : Int
    {
        return this.notes.length;
    }
}

class __Data__
{
    public var notes :Array<DataNote>;

    public function new() : Void
    {
        this.notes = [];
    }

    public function playNote(note :Note, duration :Duration, velocity :Velocity, channel :Channel) : Void
    {
        notes.push(new DataNote(note, duration, velocity, channel));
    }

}

class DataNote
{
    public var note (default, null) :Note;
    public var duration (default, null) :Duration;
    public var velocity (default, null) :Velocity;
    public var channel (default, null) :Channel;

    public function new(note :Note, duration :Duration, velocity :Velocity, channel :Channel) : Void
    {
        this.note = note;
        this.duration = duration;
        this.velocity = velocity;
        this.channel = channel;
    }
}