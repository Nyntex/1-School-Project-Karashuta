extends Node2D

func ActivateParticles(direction, color):
	ChangeParticleColor(color)
	EmitParticles(direction)

func ChangeParticleColor(color):
	match color:
		ColorEnum.colors.RED:
			modulate = ColorEnum.redColor
		ColorEnum.colors.BLUE:
			modulate = ColorEnum.blueColor
		ColorEnum.colors.NEUTRAL:
			modulate = ColorEnum.neutralColor

func EmitParticles(direction):
	look_at(direction + global_position)
	#global_rotation_degrees += 180
	self.emitting = true
