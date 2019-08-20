/*
 * MIT License
 *
 * Copyright (c) 2019 Jeremy Meltingtallow
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

package engine.util;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

class NameMacro {
  macro static public function fromInterface():Array<Field> {
    var fields = Context.getBuildFields();
    var id = _uniqueID + "";

    var name = TypeTools.findField(Context.getLocalClass().get(), "name");
    if(name == null) {
      fields.push({
        name:  "name",
        access:  [Access.APublic, Access.AFinal],
        kind: FieldType.FVar(macro:String, macro $v{id}), 
        pos: Context.currentPos(),
      });
      _uniqueID++;
    }

    if(name != null) {
      fields.push({
        name:  "_n",
        access:  [Access.APublic, Access.AFinal, Access.AStatic],
        kind: FieldType.FVar(macro:String, Context.getTypedExpr(name.expr())), 
        pos: Context.currentPos(),
      });
    }
    else {
      fields.push({
        name:  "_n",
        access:  [Access.APublic, Access.AFinal, Access.AStatic],
        kind: FieldType.FVar(macro:String, macro $v{id}), 
        pos: Context.currentPos(),
      });
    }
    
    return fields;
  }

  private static var _uniqueID = 0;
}