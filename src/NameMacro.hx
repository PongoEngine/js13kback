import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;
import haxe.macro.ExprTools;

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