extends Node2D

func SetUp(player):
	for child in get_children():
		if child.has_method("SpawnerSetup"):
			child.SpawnerSetup(player, $Enemies);


func IncreaseSpawningSpeed(var bonusspeed):
	for child in get_children():
		if child.has_method("IncreaseSpawnSpeed"):
			child.IncreaseSpawnSpeed(bonusspeed);

func Finish():
	for child in get_children():
		if child != $Enemies:
			child.queue_free();
	
	for enemy in $Enemies.get_children():
		if enemy.has_method("Die"):
			enemy.Die();
