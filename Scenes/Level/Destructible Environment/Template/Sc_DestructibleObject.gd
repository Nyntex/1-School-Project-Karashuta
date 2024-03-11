extends StaticBody2D

export (float) var maxHealth = 1.0
var health = 1.0

func _ready():
	health = maxHealth

# warning-ignore:unused_argument
func TakeDamage(color, damage, _source):
	if health > 0.0:
		health -= damage
		if health <= 0.0:
			health = 0.0
			yield(get_tree().create_timer(0), "timeout")
			$Sprite.frame += 1
