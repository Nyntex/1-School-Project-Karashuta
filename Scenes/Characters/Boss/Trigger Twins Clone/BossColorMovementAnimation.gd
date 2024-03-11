extends Node2D

func UpdateAnimation(rotationOfCharacter, walking, ultimate):
	if !visible:
		return
	
	if ultimate:
		pass
	elif walking:
		$Walking.EnableAnimation(rotationOfCharacter)
		$Idle.DisableAnimation()
	else:
		$Idle.EnableAnimation(rotationOfCharacter)
		$Walking.DisableAnimation()
