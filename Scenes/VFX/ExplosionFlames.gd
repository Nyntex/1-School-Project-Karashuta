extends Node2D

func _ready():
	$ExplosionBarrel_VFX.emitting = true;

func _on_Timer_timeout():
	queue_free();
