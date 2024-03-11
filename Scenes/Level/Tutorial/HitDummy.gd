extends StaticBody2D

export (ColorEnum.colors) var currentColor;

func TakeDamage(var color, var _damage, _source):
	if color != currentColor:
		queue_free();
