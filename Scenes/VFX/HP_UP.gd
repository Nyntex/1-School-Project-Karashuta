extends Node2D

func Emit():
	for child in get_children():
		if child.has_method("Emit"):
			child.Emit()
