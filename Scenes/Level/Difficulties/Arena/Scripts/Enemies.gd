extends Node2D

export (int) var maxEnemies;

func _on_Enemies_child_entered_tree(node):
	if get_child_count() > maxEnemies:
		node.queue_free();
