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
import shen.virtual.Keys;
import shen.rhythm.Pulse;
import shen.midi.Data;

@:expose class Sage
{
	public function new(pulse :Pulse, keys:Keys, fn :Pulse -> Data) : Void
	{
		_pulse = pulse;
		_fn = fn;
		_keys = (keys == null) 
			? new Keys("Shen")
			: keys;
	}

	@:final public function destroy() : {pulse:Pulse,keys:Keys}
	{
		return {pulse:_pulse, keys:_keys};
	}

	@:final private function position(msg :PositionInfo) : Void
	{
		_pulse = cast msg.value.toInt() * 6;
	}

	@:final private function clock() : Void
	{
		var data = _fn(_pulse);
		for(note in data.notes) {
			_keys.playNote(note.note, note.duration, note.velocity, note.channel);
		}
		_keys.update();
		_pulse++;
	}

	private var _keys (default, null):Keys;
	private var _pulse :Pulse;
	private var _fn :Pulse -> Data;
}