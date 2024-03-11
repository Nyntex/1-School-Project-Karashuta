extends Node2D

func SetUp(var difficulty):
	for node in get_children():
		if node.has_method("Setup"):
			node.Setup(difficulty, $ItemHolder);
