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

package shen.virtual;

import shen.virtual.Msg;
import shen.theory.Note;
import shen.midi.Velocity;
import shen.midi.Channel;
import shen.theory.Duration;
import shen.theory.Scale;

class Keys
{
	public function new(name :String) : Void
	{
		_noteData = new Map<Note, {duration :Duration, velocity :Velocity, channel :Channel}>();
		for(i in 0...Note.MAX.toInt()) {
			_noteData.set(new Note(i),{duration:new Duration(0),velocity:new Velocity(0),channel:CHANNEL_1});
		}
	}

	public function update() : Void
	{
		var min = new Duration(0);
		for(i in 0...Note.MAX.toInt()) {
			var noteItem = _noteData.get(new Note(i));
			if(noteItem.duration != min) {
				noteItem.duration--;
				if(noteItem.duration == min) {
					toggleNote(new Note(i), noteItem.velocity, noteItem.channel, false);
				}
			}
		}
	}

	public function playNote(note :Note, duration :Duration, velocity :Velocity, channel :Channel) : Void
	{
		if(_noteData.exists(note)) {
			_noteData.get(note).duration = duration;
			_noteData.get(note).velocity = velocity;
			_noteData.get(note).channel = channel;
			toggleNote(note, velocity, channel, true);
		}
	}

	private function toggleNote(note :Note, velocity :Velocity, channel :Channel, turnOn :Bool) : Void
	{
		// _output.send(turnOn ? NoteMsg.NOTE_ON : NoteMsg.NOTE_OFF, {
		// 	note: note,
		// 	velocity: velocity,
		// 	channel: channel
		// });
	}

	private var _noteData :Map<Note, {duration :Duration, velocity :Velocity, channel :Channel}>;
}