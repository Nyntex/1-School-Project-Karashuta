extends CanvasLayer

func UpdateValue(var value, var color):
	match color:
		ColorEnum.colors.BLUE:
			$Blue.SetValue(value);
		ColorEnum.colors.RED:
			$Red.SetValue(value);

func UpdateBonusdamage(var value, var color):
	match color:
		ColorEnum.colors.RED:
			$Bonusdamage/RedBonusDamage.text = str(value);
		ColorEnum.colors.BLUE:
			$Bonusdamage/BlueBonusDamage.text = str(value);

func StartHighLight():
	$AnimationPlayer.play("StartHighLight");

func EndHighLight():
	$AnimationPlayer.play_backwards("StartHighLight");
