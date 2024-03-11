extends Node2D



func SetUp(var player, var maxHealth):
	$ColorContainer.SetUp(player)
	$HealthContainer.SetUp(maxHealth);

func Absorb(var color, var damage):
	$StatContainer.absorbedBullets += 1;
	$ColorContainer.Absorb(color, damage);
	
	

func HideSmall(var isVisible):
	if isVisible:
		$ColorContainer.HideSmall();
	else:
		$ColorContainer.ShowSmall();
