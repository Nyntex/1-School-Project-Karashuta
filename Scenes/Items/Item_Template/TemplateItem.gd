extends Node

onready var collision = $CollisionShape2D
onready var itemSprite = $ItemSprite

#important template things
var player

func _on_TemplateItem_body_entered(body):
	#the item can only collide with the Player so we shouldn't have the need to check if the
	#collided body is the Player or not
	collision.disabled = true
	itemSprite.visible = false
	AddToPlayer(body)
	set_owner(body.items) #Godot function to set the Owner to the Player Items
	OnPickup(body)
	pass

func ColorChanged():
	#when the Player changes his color, this function will be called
	pass

func Shot():
	#when the weapon of the Player shoots, this fucntion will be called
	pass

func TakenDamage():
	#when the Player takes damage, this function will be called
	pass

func OnPickup(body):
	#when the Item is collected, this function will be called
	pass

func AddToPlayer(body):
	#the add_child() function fails if the object has a parent, so you have to remove the Parent first
	#and then add the item as a child to where you want to have it
	if self.get_parent():
		self.get_parent().remove_child(self)
		body.items.add_child(self)
		player = body
		self.position = Vector2.ZERO
		itemSprite.visible = false
	pass
