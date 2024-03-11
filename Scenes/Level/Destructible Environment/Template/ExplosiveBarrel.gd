extends StaticBody2D

export (float) var maxHealth = 1.0
var health = 1.0
export (float) var explosionDamage = 1.0;

func _ready():
	health = maxHealth
	#$DestroyedCollision.disabled = true
	$DestroyedSprite.visible = false
	$WallChecker.free()

func TakeDamage(_color, damage, _source):
	if health > 0.0:
		health -= damage
		yield(get_tree().create_timer(0.1),"timeout")
		if health <= 0.0:
			#$DestroyedCollision.disabled = true
			$DestroyedSprite.visible = true
			
			yield(get_tree().create_timer(0), "timeout")
			$CompleteCollision.disabled = true
			$CompleteSprite.visible = false
			$BarrelExplosion.emitting = true
			for body in $ExplosionArea.get_overlapping_bodies():
				if body.has_method("TakeDamage"):
					body.TakeDamage(ColorEnum.colors.NEUTRAL, explosionDamage, self)
