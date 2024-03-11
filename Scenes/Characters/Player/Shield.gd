extends AnimatedSprite

func SetColor(var color):
	var currentFrame = frame;
	
	match color:
		ColorEnum.colors.BLUE:
			play("Blue");
		ColorEnum.colors.RED:
			play("Red");
		ColorEnum.colors.NEUTRAL:
			play("Neutral");
	
	frame = currentFrame;
