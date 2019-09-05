package game;

@:enum
abstract TileType(Int) from Int
{
	var FLOOR = 0;
	var PLAYER = 1;
	var WALL = 2;
	var ENEMY = 3;
	var WATERFALL = 9;
}