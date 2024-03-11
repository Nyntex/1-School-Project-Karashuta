extends KinematicBody2D


var saver = Saver.new()
export (ColorEnum.colors) var currentColor;
export (PackedScene) var weaponScene;
var weapon
var standardWeapon

signal OnDeath();
signal OnColorSwitched();

#berserk
var berserk = false
export (float) var berserkDamage = 10.0

#stats
export (float) var baseMovementSpeed;
export (float) var maxHealth;
signal FinishedDeath
signal FinishedRevive

func _ready():#
	SpawnWeapon();
	SetUp();

func SetUp():
	$Containers/ControlContainer.SetUp(baseMovementSpeed);
	$Containers.SetUp(self, maxHealth);
	
	SwitchColor(currentColor);
	ActivateColoredPowerMeter()
	
func _process(_delta):
	if $Containers/HealthContainer.health > 0:
		$Sprites.RotateSpriteTowards($Containers/ControlContainer.GetAim() + global_position);

func _physics_process(_delta):
	if $Containers/HealthContainer.health > 0:
		var _velocity = move_and_slide($Containers/ControlContainer.GetMovement());

func SwitchColor(var color):
	if color != currentColor:
		emit_signal("OnColorSwitched");
	
	if color == ColorEnum.colors.YELLOW:
		if currentColor == ColorEnum.colors.BLUE:
			color = ColorEnum.colors.RED;
		else:
			color = ColorEnum.colors.BLUE;
	
	currentColor = color;
	$Sprites.SetColor(color);
	$Sprites.RotateSpriteTowards(get_global_mouse_position())
	weapon.currentColor = currentColor;
	ActivateColoredPowerMeter()
	$Particles.ChangeBerserkColor(currentColor)
	#TriggerItems("ColorChanged")

func TryFire(var direction):
	weapon.TryFire(direction, self, $Containers/ColorContainer.GetBonusDamage(currentColor), $Containers/ColorContainer.GetBonusSize(currentColor));

func TakeDamage(var color, var damage, var source):
	if color == currentColor:
		$Containers.Absorb(color, damage)
		$Particles/GlowAnimationPlayer.stop(true)
		match currentColor:
			ColorEnum.colors.RED:
				$Particles/GlowAnimationPlayer.play("RedGlow")
			ColorEnum.colors.BLUE:
				$Particles/GlowAnimationPlayer.play("BlueGlow")
	else:
		$Containers/HealthContainer.TakeDamage(damage);
		$Particles.ActivateHitParticles(global_position - source.global_position, currentColor)
		#TriggerItems("TakenDamage")

func Healdamage(var healing):
	$Containers/HealthContainer.HealDamage(healing);
	ActivateHealParticles()

func Die():
	visible = false;
	DisableCollision(true);
	
	DisableBerserk()
	$Particles.SpawnDeathParticles();
	
	saver.LoadSave();
	saver.playerSavingStats.totalDeaths += 1
	saver.WriteSave()
	
	yield(get_tree().create_timer(1.0), "timeout")
	emit_signal("OnDeath");

func OnHubEnter():
	$Camera2D.Zoom($Camera2D.baseZoom - Vector2(0.2, 0.2),1);

func OnHubLeft():
	$Camera2D.freezeZoom = false;
	$Camera2D.Zoom($Camera2D.baseZoom, 1);

func OnBulletFire(var direction):
	$Camera2D.Shake(direction)
	$Sprites.EnableShootSprite()
	
	#saver.LoadSave();
	#saver.playerSavingStats.totalBulletsShot += 1;
	#saver.WriteSave()
	
func Ressurect():
	visible = true;
	DisableCollision(false);
	
	$Containers/HealthContainer.Reset();
	$Containers/StatContainer.Reset();
	$Containers/ColorContainer.Reset();

func SetControlScheme(var scheme):
	$Containers/ControlContainer.controlScheme = scheme;

func OnBulletMiss():
	$Containers/StatContainer.missedShots += 1;

func OnBulletHit(var _target):
	$Containers/StatContainer.hitShots += 1;
	
	#saver.LoadSave();
	#saver.playerSavingStats.totalBulletsHit +=1;
	#saver.WriteSave()
	
func GetStats():
	return $Containers/StatContainer;

func CanGetHitByColor(color):
	if color == ColorEnum.colors.NEUTRAL:
		return true;
	elif currentColor == color:
		return false;
	return true;

func ActivateBerserk():
	if !berserk:
		berserk = true
		$Particles.ActivateBerserk()
		weapon.bulletDamage += berserkDamage
		$Containers/ControlContainer.ActivateBerserkSpeed(true);

func DisableBerserk():
	if berserk:
		berserk = false
		$Particles.DisableBerserk()
		weapon.bulletDamage -= berserkDamage
		$Containers/ControlContainer.ActivateBerserkSpeed(false);

func SpawnWeapon():
	weapon = weaponScene.instance()
	add_child(weapon)
	standardWeapon = weapon
	weapon.currentColor = currentColor;

func DisableCollision(var state):
	set_collision_mask_bit(0, !state);
	set_collision_layer_bit(0, !state);

func ActivateColoredPowerMeter():
	$Particles/PowerMeter_Red.visible = false
	$Particles/PowerMeter_Blue.visible = false
	
	match currentColor:
		ColorEnum.colors.RED:
			$Particles/PowerMeter_Red.visible = true
		ColorEnum.colors.BLUE:
			$Particles/PowerMeter_Blue.visible = true

func ActivateHealParticles():
	$Particles.ActivateHealParticles()

func DisableEffects():
	$Sprites/Shield.visible = false
	$Particles.visible = false

func EnableEffects():
	$Sprites.ShowBaseSprites();
	$Particles.visible = true
	set_process(true)
	set_physics_process(true)

func PlayFinish():
	DisableEffects()
	$Sprites.PlayDeathAnimation();
	yield($Sprites/PlayerDeathAnimation,"animation_finished")
	emit_signal("FinishedDeath")

func PlayRevive():
	DisableEffects()
	$Sprites.Revive();
	yield($Sprites/PlayerDeathAnimation,"animation_finished")
	emit_signal("FinishedRevive")
