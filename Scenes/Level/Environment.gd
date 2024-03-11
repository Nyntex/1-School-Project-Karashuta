extends Node2D

func SetUp(var player):
	for enemy in get_children():
		if enemy.has_method("Setup"):
			enemy.Setup(player)
		elif enemy.has_method("MakeReady"):
			enemy.MakeReady()
