extends Node2D

var bulletsShot = 0;

func SetUp(var player):
	for enemy in get_children():
		enemy.connect("OnBulletFire", self, "OnBulletShot");
		
		if enemy.has_method("Setup"):
			enemy.Setup(player)
		elif enemy.has_method("MakeReady"):
			enemy.MakeReady()

func RemoveAll():
	for enemy in get_children():
		enemy.queue_free();

func OnBulletShot():
	bulletsShot += 1;
