extends RayCast2D

var origin:KinematicBody2D = null
var player:KinematicBody2D = null

func _process(delta):
	if player != null:
		set_cast_to(player.global_position - global_position)
		#print(get_collider())
		if get_collider() == player:
			origin.SeesPlayer()
