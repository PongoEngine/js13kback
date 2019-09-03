package game;

@:enum
abstract TileType(Int) from Int
{
	var FLOOR = 0;
	var PLAYER = 1;
	var WALL = 2;
}