extends Node2D

func UpdateUnlocks(var level):
	for i in get_child_count():
		if i <= level:
			get_child(i).visible = true;
		else:
			get_child(i).visible = false;
