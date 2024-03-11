extends Node

onready var collision = $CollisionShape2D
onready var itemSprite = $ItemSprite

export (float) var fireRatePercent
export (float) var fireRateDuration

func _on_TemplateItem_body_entered(body):
	#the item can only collide with the Player so we shouldn't have the need to check if the
	#collided body is the Player or not
	collision.disabled = true
	itemSprite.visible = false
	OnPickup(body)
	pass

func OnPickup(body):
	#when the Item is collected, this function will be called
	if body.get("weapon") == null:
		push_error(body + " doesn`t have a weapon")
	else:
		var addedFireRate = (body.weapon.baseFireRate * (fireRatePercent / 100))
		body.weapon.fireRate += addedFireRate
		yield(get_tree().create_timer(fireRateDuration),"timeout")
		body.weapon.fireRate -= addedFireRate
	queue_free()
