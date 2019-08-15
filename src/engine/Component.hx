package engine;

@:autoBuild(NameMacro.fromInterface())
interface Component
{
    public var name (default, null):String;
}