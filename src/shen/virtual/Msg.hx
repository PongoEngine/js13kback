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

import shen.theory.Note;
import shen.midi.Velocity;
import shen.midi.Channel;
import shen.rhythm.Pulse;

@:enum
@:notNull
abstract NoteMsg(String)
{
    var NOTE_ON = "noteon";
    var NOTE_OFF = "noteoff";
    var POLY_AFTERTOUCH = "poly aftertouch";
}

typedef NoteInfo =
{
    var note :Note;
    var velocity :Velocity;
    var channel :Channel;
}

@:enum
@:notNull
abstract ControllerMsg(String)
{
    var CC = "cc";
}

typedef ControllerInfo =
{
    var controller :Int;
    var velocity :Velocity;
    var channel :Channel;
}

@:enum
@:notNull
abstract ProgramMsg(String)
{
    var PROGRAM = "program";
}

typedef ProgramInfo =
{
    var number :Int;
    var channel :Channel;
}

@:enum
@:notNull
abstract ChannelAfterTouchMsg(String)
{
    var CHANNEL_AFTERTOUCH = "channel aftertouch";
}

typedef ChannelAfterTouchInfo =
{
    var pressure :Int;
    var channel :Channel;
}

@:enum
@:notNull
abstract PitchMsg(String)
{
    var PITCH = "pitch";
}

typedef PitchInfo =
{
    var value :Int;
    var channel :Channel;
}

@:enum
@:notNull
abstract PositionMsg(String)
{
    var POSITION = "position";
}

typedef PositionInfo =
{
    var value :Pulse;
}

@:enum
@:notNull
abstract MtcMsg(String)
{
    var MTC = "mtc";
}

typedef MtcInfo =
{
    var type :Int;
    var value :Int;
}

@:enum
@:notNull
abstract SelectMsg(String)
{
    var SELECT = "select";
}

typedef SelectInfo =
{
    var song :Int;
}

@:enum
@:notNull
abstract SyncMsg(String)
{
    var CLOCK = "clock";
    var START = "start";
    var CONTINUE = "continue";
    var STOP = "stop";
    var RESET = "reset";
}