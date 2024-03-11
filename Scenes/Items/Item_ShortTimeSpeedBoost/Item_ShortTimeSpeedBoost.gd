extends Node

onready var collision = $CollisionShape2D
onready var itemSprite = $ItemSprite

export (float) var speedBoostPercent
export (float) var speedDuration

func _on_TemplateItem_body_entered(body):
	#the item can only collide with the Player so we shouldn't have the need to check if the
	#collided body is the Player or not
	collision.disabled = true
	itemSprite.visible = false
	OnPickup(body)
	pass

func OnPickup(body):
	#when the Item is collected, this function will be called
	if body.get("baseMovementSpeed") == null || body.get("movementSpeed") == null:
		push_error(body + " doesn`t have variable 'baseMovementSpeed' or 'movementSpeed'.")
	elif body.get("baseMovementSpeed") == null && body.get("movementSpeed") == null:
		push_error(body + " doesn`t have variable 'baseMovementSpeed' and 'movementSpeed'.")
	else:
		var addedSpeed = (body.baseMovementSpeed * (speedBoostPercent / 100))
		body.movementSpeed += addedSpeed
		yield(get_tree().create_timer(speedDuration),"timeout")
		body.movementSpeed -= addedSpeed
	queue_free()
