extends Node2D

func TryToFireWeapons(var amount, var target):
	for i in range(clamp(amount,0,get_child_count())):
		var weapon = get_child(i);
		var direction = target.global_position - weapon.global_position;
		
		weapon.TryFire(direction, self);
