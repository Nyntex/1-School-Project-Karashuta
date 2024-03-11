extends Node2D;

func RotateSpriteTowards(var target):
	$PlayerSprite.RotateSpriteTowards(target)

func SetColor(var color):
	$Shield.SetColor(color);

func EnableShootSprite():
	$PlayerSprite.animation = "Shooting"
	yield(get_tree().create_timer(0.1), "timeout")
	$PlayerSprite.animation = "Neutral"

func PlayDeathAnimation():
	$PlayerDeathAnimation.PlayDeath();
	$ShieldDisruptAnimation.PlayDeath();
	HideBaseSprites();

func HideBaseSprites():
	$PlayerShadowPlayer.visible = false;
	$PlayerSprite.visible = false;
	$Shield.visible = false;

func ShowBaseSprites():
	$PlayerShadowPlayer.visible = true;
	$PlayerSprite.visible = true;
	$Shield.visible = true;

func Revive():
	HideBaseSprites()
	$PlayerDeathAnimation.Revive()
