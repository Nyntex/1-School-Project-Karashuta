extends Node2D

func UpdateUnlocks(easy, mid, hard):
	$Easy.UpdateUnlocks(easy);
	$Mid.UpdateUnlocks(mid);
	$Hard.UpdateUnlocks(hard);
