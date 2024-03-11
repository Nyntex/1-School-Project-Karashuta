extends Node2D

func UpdateValue(var value, var color):
	match color:
		ColorEnum.colors.BLUE:
			$Blue.SetValue(value);
		ColorEnum.colors.RED:
			$Red.SetValue(value);
