extends Node2D

func SetColorAndAnimation(color, rotationOfCharacter, walking, ultimate):
	if get_node_or_null("Neutral") != null:
		$Neutral.visible = false
	if get_node_or_null("Red") != null:
		$Red.visible = false
	if get_node_or_null("Blue") != null:
		$Blue.visible = false
	
	match color:
		ColorEnum.colors.RED:
			if get_node_or_null("Red") != null:
				$Red.visible = true
			
		ColorEnum.colors.BLUE:
			if get_node_or_null("Blue") != null:
				$Blue.visible = true
			
		ColorEnum.colors.NEUTRAL:
			if get_node_or_null("Neutral") != null:
				$Neutral.visible = true
	
	#print(rotationOfCharacter)
	
	if rotationOfCharacter < 0:
		rotationOfCharacter += 360
	
	UpdateAnimation(rotationOfCharacter, walking, ultimate)


func UpdateAnimation(rotationOfCharacter, walking, ultimate):
	for child in get_children():
		child.UpdateAnimation(rotationOfCharacter, walking, ultimate)
