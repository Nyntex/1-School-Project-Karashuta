extends Node

export (float) var health

func _on_TemplateItem_body_entered(body):
	#the item can only collide with the Player so we shouldn't have the need to check if the
	#collided body is the Player or not
	OnPickup(body)
	queue_free()


func OnPickup(body):
	if body.has_method("Healdamage"):
		body.Healdamage(health)
