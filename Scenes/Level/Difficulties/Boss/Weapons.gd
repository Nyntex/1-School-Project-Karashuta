extends Node2D

func _ready():
	FireThinWall();
		
func FireThinWall():
	$WallWeapons/ThinWall.Fire(Vector2(0,1), self);
