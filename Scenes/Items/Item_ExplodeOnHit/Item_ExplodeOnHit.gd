extends Node

export (NodePath) var collision
export (NodePath) var itemSprite

export (NodePath) var explosionArea2D
export (NodePath) var explosionCollision

var currentColor
var player

export (float) var explosionDamage
export (float) var explosionRange

#possible stats that the Player may get for picking up this Item
export (float) var bonusDamage
export (float) var bonusHealth
export (float) var bonusSpeed

func _ready():
	
	#Change the NodePaths to Nodes
	itemSprite = get_node(itemSprite)
	collision = get_node(collision)
	explosionCollision = get_node(explosionCollision)
	explosionArea2D = get_node(explosionArea2D)
	explosionCollision.shape.radius = explosionRange
	#print(explosionCollision.shape.radius)


func _on_TemplateItem_body_entered(body):
	#the item can only collide with the Player so we shouldn't have the need to check if the
	#collided body is the Player or not
	collision.disabled = true
	itemSprite.visible = false
	AddToPlayer(body)
	set_owner(body.itemContainer) #Godot function to set the Owner to the Player Items


func ColorChanged():
	#when the Player changes his color, this function will be called
	currentColor = player.currentColor

func TakenDamage():
	#when the Player takes damage, this function will be called
	#print(explosionArea2D.get_overlapping_bodies())
	
	for i in explosionArea2D.get_overlapping_bodies():
		#print(i)
		i.TakeDamage(currentColor, explosionDamage * 1 + (1 * bonusDamage), self)


func AddToPlayer(body):
	#the add_child() function fails if the object has a parent, so you have to remove the Parent first
	#and then add the item as a child to where you want to have it
	if self.get_parent():
		self.get_parent().remove_child(self)
		body.itemContainer.add_child(self)
		player = body
		currentColor = player.currentColor
		self.position = Vector2(0.0,0.0)



