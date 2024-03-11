extends Node2D

export (PackedScene) var deathParticles;

func SpawnDeathParticles():
	var particles = deathParticles.instance();
	get_tree().root.add_child(particles)
	particles.global_position = global_position;
	particles.emitting = true;

func ActivateHitParticles(direction, color):
	$PlayerHitEffect.ActivateParticles(direction, color)

func ActivateHealParticles():
	$HealParticles.Emit()

func ActivateBerserk():
	$RageMode.emitting = true

func DisableBerserk():
	$RageMode.emitting = false

func ChangeBerserkColor(color):
	match color:
		ColorEnum.colors.BLUE:
			$RageMode.process_material.color = ColorEnum.blueColor
		ColorEnum.colors.RED:
			$RageMode.process_material.color = ColorEnum.redColor
