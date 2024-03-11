extends Node2D

func SetColorAndAnimation(color, rotationOfCharacter, walking):
	$Yellow.visible = false
	$Red.visible = false
	$Blue.visible = false
	
	match color:
		ColorEnum.colors.RED:
			$Red.visible = true
			
		ColorEnum.colors.BLUE:
			$Blue.visible = true
			
		ColorEnum.colors.YELLOW:
			$Yellow.visible = true
	
	#print(rotationOfCharacter)
	
	if rotationOfCharacter < 0:
		rotationOfCharacter += 360
	
	UpdateAnimation(rotationOfCharacter, walking)


func UpdateAnimation(rotationOfCharacter, walking):
	for child in get_children():
		child.UpdateAnimation(rotationOfCharacter, walking)
