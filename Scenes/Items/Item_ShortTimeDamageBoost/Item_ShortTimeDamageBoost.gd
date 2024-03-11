extends Node

export (float) var damagePercent
export (float) var damageDuration

func _on_TemplateItem_body_entered(body):
	#the item can only collide with the Player so we shouldn't have the need to check if the
	#collided body is the Player or not
	$CollisionShape2D.disabled = true
	$ItemSprite.visible = false
	OnPickup(body)
	pass

func OnPickup(body):
	#when the Item is collected, this function will be called
	if body.weapon != null:
		#print("picked up")
		
		var addedDamage = (body.weapon.baseBulletDamage * (damagePercent / 100))
		body.weapon.bulletDamage += addedDamage
		yield(get_tree().create_timer(damageDuration), "timeout")
		body.weapon.bulletDamage -= addedDamage
	
	queue_free()
	pass
