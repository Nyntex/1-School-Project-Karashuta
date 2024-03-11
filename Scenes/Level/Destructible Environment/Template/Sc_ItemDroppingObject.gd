extends StaticBody2D

export (float) var maxHealth = 1.0
var health = 1.0
var itemsFolder = null
var itemDropChance = 100.0
var source = null

export (PackedScene) var itemDrop

func _ready():
	health = maxHealth
	#$DestroyedCollision.disabled = true
	$DestroyedSprite.visible = false

func Setup(difficulty, sourceNew):
	itemDropChance = difficulty * 2.0 + 200.0
	source = sourceNew

# warning-ignore:unused_argument
func TakeDamage(color, damage, _source):
	if health > 0.0:
		health -= damage
		if health <= 0.0:
			health = 0.0
			yield(get_tree().create_timer(0), "timeout")
			#$DestroyedCollision.disabled = true
			$DestroyedSprite.visible = true
			
			$CompleteCollision.disabled = true
			$CompleteSprite.visible = false
			DropItem()

func DropItem():
	if rand_range(0,100.0) >= itemDropChance:
		return
	if itemDrop != null && source != null:
		var itemInst = itemDrop.instance()
		var dropPlace = $WallChecker.CheckForWalls()
		source.add_child(itemInst)
		itemInst.global_position = global_position + (Vector2(rand_range(dropPlace.left, dropPlace.right), rand_range(dropPlace.top, dropPlace.bottom)).normalized() * 25.0)
