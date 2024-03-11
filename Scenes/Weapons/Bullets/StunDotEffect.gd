extends Node2D

export (float) var damagePerSecond
export (float) var duration
var damagingObject
export (PackedScene) var damageNumber

func _on_Timer_timeout():
	duration -= $Timer.wait_time
	if duration <= 0.0:
		queue_free()
		return
	if damagingObject.has_method("TakeDamage"):
		damagingObject.TakeDamage(ColorEnum.colors.NEUTRAL, damagePerSecond * $Timer.wait_time, self)
	else:
		queue_free()

func SummonDamageText():
	if damageNumber != null:
			var number = damageNumber.instance();
			get_tree().root.add_child(number);
			number.SetText(str(int(damagePerSecond * $Timer.wait_time)));
			number.rect_position = global_position + Vector2(rand_range(-10,10), rand_range(-10,10));
