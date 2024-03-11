extends Node2D

func UpdateAnimation(rotationOfCharacter, walking):
	if !visible:
		return
	
	if walking:
		$Walking.EnableAnimation(rotationOfCharacter)
		$Idle.DisableAnimation()
	else:
		$Idle.EnableAnimation(rotationOfCharacter)
		$Walking.DisableAnimation()
