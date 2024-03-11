extends Node2D

func SetSpriteColor(var color):
	match color:
		ColorEnum.colors.RED:
			$Blue.visible = false;
			$Shieldless.visible = false;
			$Red.visible = true;

		ColorEnum.colors.BLUE:
			$Shieldless.visible = false;
			$Red.visible = false;
			$Blue.visible = true;

		ColorEnum.colors.NEUTRAL:
			$Blue.visible = false;
			$Red.visible = false;
			$Shieldless.visible = true;

func RotateSprites(var target):
	$Blue.RotateSpriteTowards(target);
	$Red.RotateSpriteTowards(target);
	$Shieldless.RotateSpriteTowards(target);
